class SearchersController < ApplicationController

  include SearchTabLabelHelper

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
    search_class = "#{@config[:type]}_searcher".classify.constantize
    @searcher = search_class.new(@config)
                            .term(search_params[:term])
                            .page(page)
    respond_to do |format|
      if @searcher.errors?
        json = render_errors
      else
        json = render_results
      end
      format.json { render json: json }
    end
  end

  private

  def render_results # rubocop:disable Metrics/AbcSize
    template = "#{@config[:type]}_results.html.erb"

    json = @searcher.all
    out = { results_html: render_to_string(partial: template) }
    out[:tab_label_html] = search_tab_label(params[:id], count: @searcher.total_count)
    out[:raw] = json if Rails.env.development?
    out
  end

  def render_errors # rubocop:disable Metrics/AbcSize
    template = "errors.html.erb"
    { errors_html: render_to_string(partial: template) }
  end

  def search_params
    params.permit(:term, :tab, :page, :per_page, :sort, :direction)
  end

  def page
    search_params[:page] || 1
  end

end
