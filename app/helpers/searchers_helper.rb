module SearchersHelper
  def search_tab_html(searcher, active_searcher: nil, count: nil)
    klass = 'nav-link'
    is_active = (searcher == active_searcher)
    klass += ' active' if is_active
    content_tag(:li, class: 'nav-item') do
      content_tag(:a, search_tab_label(searcher, count: count),
                  href: "##{searcher}",
                  id: "#{searcher}-tab",
                  'data-toggle': 'tab',
                  'data-tab': searcher.to_s,
                  'data-waiting': search_tab_label(searcher, count: '*'),
                  'data-error': search_tab_label(searcher, count: '!'),
                  class: klass,
                  'aria-controls': searcher,
                  'aria-selected': is_active.to_s)
    end
  end

  def search_results_html(searcher, active_searcher: nil)
    klass = 'tab-pane fade search-results'
    is_active = (searcher == active_searcher)
    klass += ' show active' if is_active
    content_tag(:div, '',
                id: searcher.to_s,
                role: 'tabpanel',
                class: klass,
                'aria-labelledby': "#{searcher}-tab",
                'data-tab-id': "#{searcher}-tab",
                'data-base-url': searcher_path(searcher, format: :json))
  end
end
