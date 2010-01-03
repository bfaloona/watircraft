module GoogleSearch
  module Methods
    
    def login(email, password)
      login_page.email_textbox = email
      login_page.password_textbox = password
      login_page.sign_in_button.click
    end

    def logged_in?
      true if browser.text.match(/sign out/i)
    end
  end
end