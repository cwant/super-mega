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
    searcher = SlackMessageSearcher.new(@config)
    json = searcher.search(search_params[:term])
    out = { hits: [] }
    json['messages']['matches'].each do |hit|
      if hit['type'] == 'message'
        text = "@#{hit['username']}: <a href='#{hit['permalink']}'>#{hit['text']}</a>"
        out[:hits] << { text: text }
      end
    end
    out
  end

  def search_mediawiki
    searcher = MediawikiSearcher.new(@config)
    json = searcher.search(search_params[:term])
    out = { hits: [] }
    json['query']['search'].each do |hit|
      text = render_to_string partial: 'mediawiki_hit.html.erb',
                              locals: { hit: hit }
      out[:hits] << { text: text }
    end
    out
  end

  def search_params
    params.permit(:term, :tab, :page, :per_page, :sort, :direction)
  end

end
