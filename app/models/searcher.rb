class Searcher

  include Enumerable
  include Kaminari::PageScopeMethods  

  MAX_PER_PAGE = 10
  LIMIT_VALUE = 500
  MAX_PAGES = 50

  def criteria
    @criteria ||= {}
  end

  def update_criteria(key, value)
    @results = []
    criteria[key] = value
    self
  end

  def results
    @results ||= []
  end

  def term(term)
    update_criteria(:term, term)
  end

  def page(page)
    update_criteria(:page, page.to_i)
  end

  def limit(per_page)
    update_criteria(:limit, offset)
  end

  def max_per_page
    MAX_PER_PAGE
  end

  def max_pages
    MAX_PAGES
  end

  
  #def offset(offset)
  #  update_criteria(:offset, offset)
  #end

  def offset_value
    (page_value - 1) * max_per_page
  end

  def page_value
    criteria[:page] || 1
  end

  def limit_value
    criteria[:limit] ||= MAX_PER_PAGE
  end

  def all
    reify
  end

  def each(&block)
    reify
    iteratable_results.each(&block)
  end

end
