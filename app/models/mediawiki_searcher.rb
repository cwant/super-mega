class MediawikiSearcher

  def initialize(base_api_url)
    @base_api_url = base_api_url
  end

  def search(term)
    url = "#{@base_api_url}?action=query&list=search&srsearch=#{term}&format=json"
    response = RestClient.get(url)
    JSON.parse(response)
  end

end
