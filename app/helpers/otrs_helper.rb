module OtrsHelper
  def otrs_age(hit)
    content_tag(:span,
                t('views.otrs.age',
                  age: time_ago_in_words(hit['Age'].seconds.ago)))
  end

  def otrs_queue(hit)
    content_tag(:span,
                t('views.otrs.queue', queue: hit['Queue']),
                class: 'badge badge-secondary')
  end

  def otrs_state(hit)
    content_tag(:span,
                t('views.otrs.state', state: hit['State']),
                class: 'badge badge-primary')
  end

  def otrs_owner(hit)
    content_tag(:span, t('views.otrs.owner', owner: hit['Owner']))
  end

  def otrs_customer(hit)
    content_tag(:span, t('views.otrs.customer',
                         customer: hit['CustomerID']))
  end

  def otrs_first_body(hit)
    body = hit['Article']&.first&.fetch('Body') || ''
    # Scrub email signature and beyond (common pattern)
    body = body.match(/(^.*)\s\s--\s/m).to_a.last || body
    # Scrub ticket link and beyond
    body = body.match(/(^.*)View this ticket here/m).to_a.last || body
    body = if body.length > 300
             body[0..249] + '...'
           else
             body
           end
  end

end
