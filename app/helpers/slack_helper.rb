module SlackHelper
  def slack_age(hit)
    content_tag(:span,
                t('views.slack.age',
                  age: time_ago_in_words(Time.at(hit['ts'].to_i))))
  end
end
