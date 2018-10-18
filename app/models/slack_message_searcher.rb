class SlackMessageSearcher
  SLACK_SEARCH_URL = 'https://slack.com/api/search.messages'

  def initialize
    @api_token = Rails.application.credentials.slack[:api_key]
  end

  def search(term)
    url = "#{SLACK_SEARCH_URL}?token=#{@api_token}&query=#{term}"
    response = RestClient.get(url)
    JSON.parse(response)
  end
end
