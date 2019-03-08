Then(/^I can open rubica website$/) do
  Rubica::Rubicatests.open_website
end

When(/^I launch firefox browser$/) do
  Rubica::Rubicatests.launch_browser
end

And(/^I close the browsing session$/) do
  Rubica::Rubicatests.close_browser_session
end

Then(/^I verify all the hyperlinks present in the UI$/) do
  Rubica::Rubicatests.verify_hyperlinks
end

Then(/^I verify the following fields are filled in '(.*)' plan$/) do |category, table|
  Rubica::Rubicatests.select_category(category)
  options = table.rows_hash
  Rubica::Rubicatests.enrollment_options(options)
end

Then(/^I place order for the selected plan with '(.*)'$/) do |type|
  Rubica::Rubicatests.place_order(type)
end

Then(/^I verify the '(.*)' price plan$/) do |category|
  Rubica::Rubicatests.select_category(category)
end

Then(/^I enter invalid email credentials and verify error message on the UI$/) do
  Rubica::Rubicatests.verify_email_error_message
end

Then(/^I verify contact page present in the UI$/) do
  Rubica::Rubicatests.validate_contact_page
end

Then(/^I verify the following contents in the webpage$/) do |table|
  options = table.rows_hash
  Rubica::Rubicatests.content_validation(options)
end

And(/^I generate (.*) credit card numbers and validate whether the page is locked with '(.*)'$/) do |option, type|
  case option.downcase
    when 'valid'
      Rubica::Rubicatests.valid_creds_page_lock(option, type)
    when 'invalid'
      Rubica::Rubicatests.invalid_creds_page_lock(option, type)
  end

end

Then(/^I validate login page with the following '(.*)' credentials$/) do |type, table|
  options = table.rows_hash
  Rubica::Rubicatests.validate_login(type, options)
end

And(/^I validate the error messages for password mismatch$/) do
  Rubica::Rubicatests.validate_error_msgs
end