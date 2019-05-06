class MediawikiSearcher < Searcher

  attr_reader :base_wiki_url

  def initialize(config)
    @base_api_url = config[:base_api_url]
    @base_wiki_url = config[:base_wiki_url]
    auth = config.slice(:username, :password)
    @auth = if auth.count == 2
              auth
            else # rubocop:disable Style/EmptyElse
              nil
            end
    @token = nil
    @cookies = nil
  end

  def mediawiki_fetch_token
    url = "#{@base_api_url}?action=query&format=json&meta=tokens&type=login"
    response = RestClient.get(url)
    return false unless response.code == 200

    @token = JSON.parse(response.body)['query']['tokens']['logintoken']
    @cookies = response.cookies
    true
  end

  def mediawiki_login
    login_params = {
      'action' => 'login',
      'lgname' => @auth[:username],
      'lgpassword' => @auth[:password],
      'lgtoken' => @token,
      'format' => 'json'
    }
    response = RestClient.post(@base_api_url, login_params, cookies: @cookies)

    # Gotta swap out those cookies
    @cookies = response.cookies

    (response.code == 200)
  end

  def reify # rubocop:disable Metrics/AbcSize
    return results if results.any?

    return results unless criteria[:term]

    url = "#{@base_api_url}?action=query&list=search&srsearch=#{criteria[:term]}"\
          "&srwhat=text&srlimit=#{max_per_page}&sroffset=#{offset_value}&format=json"

    if @auth
      # I hate you mediawiki
      # TODO: persist the cookies in session?
      mediawiki_fetch_token
      mediawiki_login
      response = RestClient.get(url, cookies: @cookies)
    else
      response = RestClient.get(url)
    end

    @results = JSON.parse(response)
  end

  def iteratable_results
    results['query']['search']
  end

  def total_count
    reify
    results['query']['searchinfo']['totalhits']
  end

  def count
    reify
    results['query']['search']&.count || 0
  end

  def hit_url(hit)
    "#{@base_wiki_url}?title=#{hit['title']}"
  end

end
