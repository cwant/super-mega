module MediawikiHelper
  def mediawiki_age(hit)
    content_tag(:span,
                t('views.otrs.age',
                  age: time_ago_in_words(Time.parse(hit['timestamp']))))
  end
end
