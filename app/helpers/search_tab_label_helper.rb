module SearchTabLabelHelper
  def search_tab_label(searcher, count: nil)
    label = t("searchers.names.#{searcher}")
    label += " (#{count})" if count
    label
  end
end
