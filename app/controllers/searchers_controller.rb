class SearchersController < ApplicationController

  def slack
    respond_to do |format|
      format.json { render json: search_slack(search_params[:term]) }
    end
  end

  def mediawiki
    respond_to do |format|
      format.json { render json: search_mediawiki(search_params[:term]) }
    end
  end

  private

  def search_slack(term)
    searcher = SlackMessageSearcher.new(Rails.application.credentials.slack[:api_key])
    json = searcher.search(term)
  end

  def search_mediawiki(term)
    searcher = MediawikiSearcher.new(Rails.application.credentials.mediawiki[:base_api_url])
    json = searcher.search(term)
  end

  def search_params
    params.permit(:term)
  end
end
