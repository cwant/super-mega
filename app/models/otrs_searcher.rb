class OtrsSearcher < Searcher

  def initialize(config)
    @base_url = config[:base_url]
    @username = config[:username]
    @password = config[:password]
  end

  def reify
    return results if results.any?

    return results unless criteria[:term]

    response = RestClient::Request.execute(method: :get,
                                           url: search_endpoint,
                                           payload: search_payload,
                                           headers: {content_type: :json,
                                                     accept: :json})
    @results = JSON.parse(response)
    fetch_tickets
  end

  def iteratable_results
    results['tickets']
  end

  def total_count
    reify
    results['TicketID']&.count || 0
  end

  def count
    reify
    results['tickets']&.count || 0
  end

  def hit_url(hit)
    url = "#{@base_url}/otrs/index.pl?Action=AgentTicketZoom;TicketID=#{hit['TicketID']}"

    # Try to go to first article in ticket
    article = hit['Article']&.first
    url += "#" + article['ArticleID'] if article
    url
  end

  private

  def search_endpoint
    "#{@base_url}/otrs/nph-genericinterface.pl/Webservice/"\
    'GenericTicketConnectorREST/Ticket'
  end

  def search_payload
    {'UserLogin' => @username,
     'Password' => @password,
     'Fulltext' => criteria[:term]
    }.to_json
  end

  def ticket_list_endpoint
    "#{@base_url}/otrs/nph-genericinterface.pl/Webservice/"\
    'GenericTicketConnectorREST/TicketList'
  end

  def ticket_list_payload(tickets)
    {'UserLogin' => @username,
     'Password' => @password,
     'TicketID' => tickets,
     'AllArticles': 1,
     'ArticleLimit': 1 
    }.to_json
  end

  def fetch_tickets
    ticket_ids = (@results['TicketID'] ||
                  [])[offset_value..(offset_value + max_per_page - 1)] || []
    if ticket_ids.count == 0
      @results['tickets'] = []
      return
    end
    response = RestClient::Request
                 .execute(method: :get,
                          url: ticket_list_endpoint,
                          payload: ticket_list_payload(ticket_ids),
                          headers: {content_type: :json,
                                    accept: :json})
    @results['tickets'] = JSON.parse(response).fetch('Ticket', [])
  end

end
