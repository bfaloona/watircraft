require 'rubygems'
require 'taza/page'

module GoogleSearch
  class LoginPage < ::Taza::Page

    url 'accounts/Login'
    
    def url_regex
      /google/ # intentionally broad so we can trigger the *_page_identifier below
    end
    
    def result_links_page_identifier(browser)
      browser.html.match(/<id [^>]*?id=.Email/)
    end
    
    
    field(:email_textbox){            browser.text_field(   :id, 'Email')}
    field(:password_textbox){         browser.text_field(   :id, 'Passwd')}
    
    element(:sign_in_button){         browser.button(       :name, 'signIn')}
    element(:privacy_link){           browser.link(         :href, /\/intl\/.+?\/privacy.html$/)}
    
    # appears only when password error is displayed
    element(:password_error_message){    browser.div(          :id, 'errormsg_0_Passwd')}

  end
end
