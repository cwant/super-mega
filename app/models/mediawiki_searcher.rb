class MediawikiSearcher < Searcher

  attr_reader :base_wiki_url

  def initialize(config)
    @base_api_url = config[:base_api_url]
    @base_wiki_url = config[:base_wiki_url]
  end

  def reify
    return results if results.any?

    return results unless criteria[:term]

    url = "#{@base_api_url}?action=query&list=search&srsearch=#{criteria[:term]}"\
          "&srlimit=#{max_per_page}&sroffset=#{offset_value}&format=json"

    response = RestClient.get(url)
    @results = JSON.parse(response)
  end

  def total_count
    reify
    results['query']['searchinfo']['totalhits']
  end

  def count
    reify
    results['query']['search']&.count || 0
  end
end
