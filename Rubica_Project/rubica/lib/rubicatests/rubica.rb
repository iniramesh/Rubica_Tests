module Rubica
  module Rubicatests
    require 'selenium-webdriver'
    require 'cucumber'
    require 'net/http'
    require 'httparty'
    require 'luhnacy'

    def self.launch_browser
      @driver = Selenium::WebDriver.for :firefox
    end

    def self.open_website
      @driver.navigate.to "https://www.rubica.com/"
      sleep(3)
    end

    def self.close_browser_session()
      @driver.close()
    end

    def self.verify_hyperlinks
      @url = URI.parse('https://rubica.com')
      # Due to SSL Cert connection error we are not verifying the cert inorder to proceed with the testing.
      # The SSL Cert validation is one more test we can validate here by validating the error message
      @response = HTTParty.get(@url, :verify => false)
      # This regular expression matches all the Hyperlinks present in the webpage.
      # We are validating the response of all the Hyperlinks present in the web page
      url_finder_exp = /a.*\s+href=["](https:\/\/[my.]*rubica[.]com[a-zA-Z0-9-\/]*).*/
      rubica = @response.to_s.scan(url_finder_exp)
      rubica.uniq.each do |item|
        # We are navigating to each and every hyperlink to verify whether all the links are valid and working
        @driver.navigate.to(item[0].to_s)
        # Validating the response HTTP Code
        fail('error while loading page') unless (@response.code>199) && (@response.code<300)
      end
    end

    def self.select_category(category)
      case category.downcase.gsub(' ', '_')
        #select plan and compare the rates in the main web page and Enroll now page
        when 'individual'
          price_plan = @driver.find_element(:xpath => "//div[@class='price-wrap']").text.match(/\d+/).to_s
          @link = 'https://my.rubica.com/checkout/p/320a17e8-7917-4fa5-8729-d962424cb9fb'
          @driver.navigate.to(@link)
          enrollment_price = @driver.find_element(:xpath => "//label[@for='price']").text.match(/\d+/).to_s
          fail('price plans are not matching') unless price_plan.eql? enrollment_price
        when 'family'
          price_plan = @driver.find_element(:xpath => "//div[@class='price-wrap' and contains(text(),'59.99/mo']").text
          @link = 'https://my.rubica.com/checkout/p/669b5ffa-da98-49b5-a48e-c811fae6d119'
          @driver.navigate.to(@link)
          enrollment_price = @driver.find_element(:xpath => "//label[@for='price']).text]").text
          fail('price plans are not matching') unless price_plan.eql? enrollment_price
        when 'team'
          price_plan = @driver.find_element(:xpath => "//div[@class='price-wrap' and contains(text(),'249.99/mo']").text
          @link = 'https://my.rubica.com/checkout/p/1afd2897-c7c3-4ec8-a6f0-2d06cc48bfbe'
          @driver.navigate.to(@link)
          enrollment_price = @driver.find_element(:xpath => "//label[@for='price']).text]").text
          fail('price plans are not matching') unless price_plan.eql? enrollment_price
        when 'rubica_private_client'
          @driver..navigate.to('https://my.rubica.com/rubica-private-client').click
        else
          fail('unknown option provided!')
      end
    end

    def self.enrollment_options(options)
      #Filling in all the fields with respective selectors
      options.each do |opt, value|
        case opt.downcase.gsub(' ', '_')
          when 'first_name'
            @driver.find_element(:xpath => "//input[@name='first_name']").send_keys(value)
          when 'last_name'
            @driver.find_element(:xpath => "//input[@name='last_name']").send_keys(value)
          when 'email'
            @driver.find_element(:xpath => "//input[@name='email']").send_keys(value)
          when 'password'
            @driver.find_element(:xpath => "//input[@name='password']").send_keys(value)
          when 'confirm_password'
            @confirm_password = @driver.find_element(:xpath => "//input[@name='password_confirmation']")
            @confirm_password.send_keys(value)
          when 'recovery_email'
            @driver.find_element(:xpath => "//input[@name='recovery_email']").send_keys(value)
          when 'recovery_secret_phrase'
            @driver.find_element(:xpath => "//input[@name='secret_phrase']").send_keys(value)
          when 'zip_code'
            @driver.find_element(:xpath => "//input[@name='zip']").send_keys(value)
          when 'credit_card_number'
            @driver.find_element(:xpath => "//input[@name='number']").send_keys(value)
          when 'expiration_month'
            @driver.find_element(:xpath => "//input[@name='month']").send_keys(value)
          when 'expiration_year'
            @driver.find_element(:xpath => "//input[@name='year']").send_keys(value)
          when 'security_code'
            @driver.find_element(:xpath => "//input[@name='cvc']").send_keys(value)
          when 'phone_country_code'
            @driver.find_element(:xpath => "//input[@name='country_code_US']").click
          when 'phone_number'
            @driver.find_element(:xpath => "//input[@name='phone']").send_keys(value)
          when 'terms_and_conditions'
            @driver.find_element(:xpath => "//label[@for='terms']").click
            sleep(3)
        end
      end
    end

    def self.place_order(type)
      @driver.find_element(:css => ".btn-primary-text").click
      case type.downcase.gsub(' ', '_')
        when 'all_fields'
          #Validate whether the plan is succesfully purchased when the current page navigates to Submitted page
          #This condition always fails with RunTime error since the credit card details are not valid thought for testing it is assumed valid
          fail('plan cannot be purchased') if @driver.current_url.eql? @link
        when 'invalid_fields'
          ##Validate whether the plan can not be purchased when the current page stays in the same page with same url
          fail('purchased the plan with invalid details!') unless @driver.current_url.eql? @link
      end
    end

    def self.verify_email_error_message
      #Verifies whether the error message is displayed when an empty or an invalid email is given on the UI
      submit_button = @driver.find_element(:xpath => "//button[@name='SIGNUP_SUBMIT_BUTTON']")
      email_field = @driver.find_element(:xpath => "//input[@name='CONTACT_EMAIL']")
      submit_button.click
      error_msg = @driver.find_element(:xpath => "//div[@id='errorMsgDiv']").text
      fail("email field accepts empty credentials!") if error_msg.nil?
      email_field.send_keys('1.2.com')
      submit_button.click
      fail("email field accepts invalid credentials!") if error_msg.nil?
    end

    def self.content_validation(options)
      #Validates all the important contents in the web page like installation and contact details
      options.each do |opt, value|
        case opt.downcase.gsub(' ', '_')
          when 'plan_start_rate'
            @driver.find_element(:xpath => "//div[@class='cta']").text.downcase.include? value.downcase
          when 'installation_windows'
            installation_page = @driver.navigate.to('https://rubica.com/installation/')
            @driver.find_element(:xpath => "//a[@href='https://rubica.com/wp-content/uploads/2018/03/rubica-installer.zip']").text.downcase.eql? value.downcase
          when 'installation_mac'
            @driver.find_element(:xpath => "//a[@href='https://itunes.apple.com/us/app/rubica/id1215086502?mt=12']").text.downcase.eql? value.downcase
          when 'installation_iphone_ipad'
            @driver.find_element(:xpath => "//a[@href='https://itunes.apple.com/us/app/rubica/id1211487451?mt=8']").text.downcase.eql? value.downcase
          when 'installation_android'
            @driver.find_element(:xpath => "//a[@href='https://play.google.com/store/apps/details?id=com.rubica.Rubica']").text.downcase.eql? value.downcase
          when 'contact_phone'
            @driver.navigate.to('https://rubica.com/contact/')
            @driver.find_element(:xpath => "//a[@href='tel:8662782422']").text.downcase.eql? value
          when 'contact_email'
            @driver.find_element(:xpath => "//a[@href='mailto:hello@rubica.com']").text.downcase.eql? value
          when 'media_inquiries'
            @driver.find_element(:xpath => "//a[@href='mailto:press@rubica.com']").text.downcase.eql? value
          else
            fail('invalid option')
        end
      end
    end

    def self.generate_card_number(option)
      #This function generates random credit card number both valid and invalid
      case option.downcase
        when 'valid'
          valid_card_number = Luhnacy.generate(16)
          @driver.find_element(:xpath => "//input[@name='number']").send_keys(valid_card_number)
        when 'invalid'
          invalid_card_number = Luhnacy.generate(16, :invalid => true)
          @driver.find_element(:xpath => "//input[@name='number']").send_keys(invalid_card_number)
      end
    end

    def self.valid_creds_page_lock(option, type)
      #Verifies whether valid credit card details locks the page(which is assumed to be on the same page)
      #If the page navigates to submitted page it is assumed that the credit card details are valid.
      5.times do
        generate_card_number(option)
        place_order(type)
        #If successfully purcased with valid credit card number then the loop breaks
        break if @driver.current_url!= @link
      end
    end

    def self.invalid_creds_page_lock(option, type)
      5.times do
        generate_card_number(option)
        place_order(type)
      end
    end

    def self.validate_login(type, options)
      url = 'https://my.rubica.com/login'
      @driver.navigate.to(url)
      options.each do |opt, value|
        case opt.downcase.gsub(' ', '_')
          when 'login_email'
            @driver.find_element(:xpath => "//input[@name='email']").send_keys(value)
          when 'login_password'
            @driver.find_element(:xpath => "//input[@name='password']").send_keys(value)
        end
      end
      @driver.find_element(:css => 'button.btn').click
      if type.downcase.eql?('valid')
        fail('credentials are not valid') unless @driver.current_url.eql? url
      else
        error_msg = @driver.find_elements(:xpath => "//div[@class='alert alert-danger'")
        fail('login page accepts invalid credentials') unless error_msg.size()!=0
      end
    end

    def self.validate_error_msgs
      @confirm_password.click
      error_msg = 'The password confirmation does not match'
      fail('error message is not displayed') unless @driver.find_element(:xpath => "//div[@class='alert alert-danger'").text.include?(error_msg)
    end
  end
end



