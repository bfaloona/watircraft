module Search
  module Methods
    
    def search(query)
      home_page.search_textbox = query
      home_page.google_search_button.click
      sleep 0.5
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

  end
end