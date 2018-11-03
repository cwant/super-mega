class WordpressSearcher < Searcher

  def initialize(config)
    @api_url = config[:api_url]
  end

  def reify
    return results if results.any?

    return results unless criteria[:term]

    url = "#{@api_url}?search=#{criteria[:term]}"\
          "&per_page=#{max_per_page}&offset=#{offset_value}"

    response = RestClient.get(url)
    @headers = response.headers
    @results = JSON.parse(response)
  end

  def iteratable_results
    results
  end

  def total_count
    reify
    (@headers[:x_wp_total] || 0).to_i
  end

  def count
    reify
    results&.count || 0
  end

end
