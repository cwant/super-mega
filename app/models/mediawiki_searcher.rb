class MediawikiSearcher

  attr_reader :base_wiki_url

  def initialize(config)
    @base_api_url = config[:base_api_url]
    @base_wiki_url = config[:base_wiki_url]
  end

  def search(term)
    url = "#{@base_api_url}?action=query&list=search&srsearch=#{term}&format=json"
    response = RestClient.get(url)
    JSON.parse(response)
  end

end