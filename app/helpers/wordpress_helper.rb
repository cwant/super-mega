module WordpressHelper
  def wordpress_age(hit)
    content_tag(:span,
                t('views.otrs.age',
                  age: time_ago_in_words(Time.parse(hit['date']))))
  end

  def wordpress_excerpt(hit)
    strip_tags(hit['excerpt']['rendered']).html_safe
  end
end
