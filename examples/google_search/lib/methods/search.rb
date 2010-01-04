module GoogleSearch
  module Methods
    
    def search(query)
      begin
        home_page.search_textbox = query
        home_page.google_search_button.click
      rescue
        results_page.search_textbox = query
        results_page.google_search_button.click
      end
      sleep 1
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