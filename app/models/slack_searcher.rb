class SlackSearcher < Searcher

  SLACK_SEARCH_URL = 'https://slack.com/api/search.messages'.freeze

  def initialize(config)
    @api_token = config[:api_token]
  end

  def reify
    return results if results.any?

    return results unless criteria[:term]

    url = "#{SLACK_SEARCH_URL}?token=#{@api_token}&query=#{criteria[:term]}&"\
          "count=#{max_per_page}&page=#{page_value}"

    response = RestClient.get(url)
    @results = JSON.parse(response)
  end

  def iteratable_results
    results['messages']['matches']
  end

  def total_count
    reify
    results['messages']['paging']['total']
  end

  def count
    reify
    results['paging']['count']
  end

end
