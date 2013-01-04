class Link < ActiveRecord::Base
  attr_accessible :cached_issue_id, :title, :url
  belongs_to :cached_issue
  validates_uniqueness_of :url, :scope => :cached_issue_id
end
