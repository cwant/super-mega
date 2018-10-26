class SearchersController < ApplicationController

  def index
    @active_searcher = SEARCHERS.keys.first
  end

  def show
    id = params[:id].to_sym

    raise ActionController::RoutingError unless SEARCHERS.key?(id)

    config = SEARCHERS[id]
    respond_to do |format|
      json = send("search_#{config[:type]}", config, search_params[:term])
      format.json { render json: json }
    end
  end

  private

  def search_slack(config, term)
    searcher = SlackMessageSearcher.new(config)
    json = searcher.search(term)
    out = { hits: [] }
    json['messages']['matches'].each do |hit|
      if hit['type'] == 'message'
        text = "@#{hit['username']}: <a href='#{hit['permalink']}'>#{hit['text']}</a>"
        out[:hits] << { text: text }
      end
    end
    out
  end

  def search_mediawiki(config, term)
    searcher = MediawikiSearcher.new(config)
    json = searcher.search(term)
    out = { hits: [] }
    json['query']['search'].each do |hit|
      text = render_to_string partial: 'mediawiki_hit.html.erb',
                              locals: { hit: hit, base_wiki_url: searcher.base_wiki_url }
      out[:hits] << { text: text }
    end
    out
  end

  def search_params
    params.permit(:term)
  end

end
