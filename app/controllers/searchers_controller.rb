class SearchersController < ApplicationController

  def index
    @active_searcher = SEARCHERS.keys.first
    return unless search_params[:tab]

    return unless SEARCHERS.key?(search_params[:tab].to_sym)

    @active_searcher = search_params[:tab].to_sym
  end

  def show
    id = params[:id].to_sym

    raise ActionController::RoutingError unless SEARCHERS.key?(id)

    @config = SEARCHERS[id]
    respond_to do |format|
      json = send("search_#{@config[:type]}")
      format.json { render json: json }
    end
  end

  private

  def search_slack
    @searcher = SlackMessageSearcher.new(@config)
                 .term(search_params[:term])
                 .page(page)
    @searcher.all
    { html: render_to_string(partial: 'slack_results.html.erb') }
  end

  def search_mediawiki
    @searcher = MediawikiSearcher.new(@config)
                 .term(search_params[:term])
                 .page(page)
    @searcher.all
    { html: render_to_string(partial: 'mediawiki_results.html.erb') }
  end

  def search_params
    params.permit(:term, :tab, :page, :per_page, :sort, :direction)
  end

  def page
    search_params[:page] || 1
  end
end
