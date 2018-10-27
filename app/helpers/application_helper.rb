module ApplicationHelper
  def search_tab_label(searcher, active_searcher: nil, count: nil)
    label = t("searchers.names.#{searcher}")
    label += " (#{count})" if count
    klass = 'nav-link'
    is_active = (searcher == active_searcher)
    klass += ' active' if is_active
    content_tag(:li, class: 'nav-item') do
      content_tag(:a, label,
                  href: "##{searcher}",
                  id: "#{searcher}-tab",
                  'data-toggle': 'tab',
                  'data-tab': searcher.to_s,
                  class: klass,
                  'aria-controls': searcher,
                  'aria-selected': is_active.to_s)
    end
  end

  def search_tab_panel(searcher, active_searcher: nil)
    klass = 'tab-pane fade search-results'
    is_active = (searcher == active_searcher)
    klass += ' show active' if is_active
    content_tag(:div, '',
                id: searcher.to_s,
                role: 'tabpanel',
                class: klass,
                'aria-labelledby': "#{searcher}-tab",
                'data-tab-id': "#{searcher}-tab",
                'data-label': t(searcher),
                'data-base-url': searcher_path(searcher, format: :json))
  end
end
