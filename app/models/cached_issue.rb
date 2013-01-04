require 'open-uri'
require 'redirect_follower'

class CachedIssue < ActiveRecord::Base

  has_many :links
  attr_accessible :body, :title, :url
  validates_uniqueness_of :url
  after_create :extract_links
  acts_as_indexed :fields => [ :plaintext_body ]


  def self.search( term )
    if term.match(%r{^http://})
      Link.where( :url => term ).order('created_at desc')
    else
      CachedIssue.find_with_index( term ).sort { |a,b| a.created_at <=> b.created_at }
    end
  end

  def self.domain_search( href )
    uri = URI.parse( href )
    Link.where( 'url LIKE ?', "%#{uri.hostname}%" )
  end

  def self.update
    this_sunday = Date.today.sunday - 1.week
    current_issue = self.where( 'created_at >= ?', this_sunday ).order('created_at desc').first
    self.fetch_new_issues unless current_issue
  end

  def self.fetch_new_issues
    doc = Nokogiri::HTML( open('http://3dprintweekly.com/') )
    doc.css('#archiveBox li a').each do |issue_link|
      title = issue_link.inner_html
      url  = issue_link.attr('href')
      next if self.find_by_url( url ).present?
      body = open( url ).read
      self.create(
        title: title,
        url: url,
        body: body
      )
    end
  end

  def plaintext_body
    ActionController::Base.helpers.strip_tags( self.body )
  end

  def extract_links
    doc = Nokogiri::HTML( self.body )
    doc.css('a').each do |link|
      title = link.inner_html
      url   = link.attr('href')
      next unless url && url.match(%r{createsend1\.com/t/})
      resolved_url = RedirectFollower.resolve( url )
      next unless URI.parse( resolved_url ).absolute?
      Link.create(
        title: title,
        url: resolved_url,
        cached_issue_id: self.id
      )
    end
  end

end
