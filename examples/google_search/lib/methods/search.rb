module GoogleSearch
  module Methods
    
    def search(query)
      current_page.search_textbox = query
      current_page.google_search_button.click
      sleep 1 # hack to help firewatir wait for new page. :(
      fail "Search action did not navigate to :results_page" unless on_page? :results_page
    end
    
    # hash of results {text => href}
    def results
      result_links = browser.links.select{ |link| link.class_name == 'l' }
      ret = {}
      result_links.each do |link|
        ret[link.text] = link.href
      end
      ret
    end
    
    # true if term in results
    def results_include(term)
      found = false 
      results.each do |text, href|
        found = true if text.match(/#{term}/i)
      end
      return found
    end
    
  end
end