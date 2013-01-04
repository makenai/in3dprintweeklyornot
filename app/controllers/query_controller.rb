class QueryController < ApplicationController

  def search
    CachedIssue.update
    @results = CachedIssue.search( params[:term] )
    if @results.empty? && params[:term].match(%r{^http://})
      @similar = CachedIssue.domain_search( params[:term] )
    end

  end

end