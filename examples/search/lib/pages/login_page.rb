require 'rubygems'
require 'taza/page'

module Search
  class LoginPage < ::Taza::Page

    url 'accounts/Login'
    
    field(:email_textbox){            browser.text_field(   :id, 'Email')}
    field(:password_textbox){         browser.text_field(   :id, 'Passwd')}
    
    element(:sign_in_button){         browser.button(       :name, 'signIn')}
    element(:privacy_link){           browser.link(         :href, /\/intl\/.+?\/privacy.html$/)}
    
    # appears only when password error is displayed
    element(:password_error_message){    browser.div(          :id, 'errormsg_0_Passwd')}

  end
end
