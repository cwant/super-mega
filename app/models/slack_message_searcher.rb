class SlackMessageSearcher

  SLACK_SEARCH_URL = 'https://slack.com/api/search.messages'.freeze

  def initialize(api_token)
    @api_token = api_token
  end

  def search(term)
    url = "#{SLACK_SEARCH_URL}?token=#{@api_token}&query=#{term}"
    response = RestClient.get(url)
    JSON.parse(response)
  end

end
