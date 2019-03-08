@RubicaWebApplication @P0
Feature: Rubica Web Application P0 Test Cases

  @ValidatingHyperLinks @RubicaWebApplication @P0
  Scenario: Validate all rubica hyperlinks present on the UI
    When I launch firefox browser
    And I can open rubica website
    Then I verify all the hyperlinks present in the UI
    And I close the browsing session

  @PurchaseRubicaPlan @EnrollNow @RubicaWebApplication @P0
  Scenario: Verify whether user will be able to purchase the plan after all the details are filled
    When I launch firefox browser
    And I can open rubica website
    Then I verify the following fields are filled in 'individual' plan
      | First_Name             | Ini               |
      | Last_Name              | Ramesh            |
      | Email                  | ir@gmail.com      |
      | Password               | Redmond@98007     |
      | Confirm_Password       | Redmond@98007     |
      | Recovery_Email         | ir@hotmail.com    |
      | Recovery_Secret_Phrase | I live in redmond |
      | Zip_Code               | 98007             |
      | Credit_Card_Number     | 1234567823456789  |
      | Expiration_Month       | 10                |
      | Expiration_Year        | 2021              |
      | Security_Code          | 123               |
      | Phone_Country_Code     | USA               |
      | Phone_Number           | 4251231234        |
      | Terms_And_Conditions   | True              |
    And I place order for the selected plan with 'all_fields'
    And I close the browsing session

  @MandatoryFields @EnrollNow @RubicaWebApplication @P0
  Scenario: Verify whether user will not be able to purchase the plan if mandatory fields are not filled
    When I launch firefox browser
    And I can open rubica website
    Then I verify the following fields are filled in 'family' plan
      | Email                  | ir@gmail.com        |
      | Password               | Redmond@98007       |
      | Confirm_Password       | Redmond@98007       |
      | Recovery_Email         | ir@hotmail.com      |
      | Recovery_Secret_Phrase | I live in redmond   |
      | Zip_Code               | 98007               |
      | Card_Number            | 1234 5678 2345 6789 |
      | Expiration_Month       | 10                  |
      | Expiration_Year        | 2021                |
      | Security_Code          | 123                 |
      | Phone_Country_Code     | USA                 |
      | Phone_Number           | 4251231234          |
    Then I place order for the selected plan with 'invalid_fields'
    And I close the browsing session

  @ValidatePricePlan @EnrollNow @RubicaWebApplication @P0
  Scenario: Verify whether user will be able to see same price plan in the main page and enrollment page
    When I launch firefox browser
    And I can open rubica website
    Then I verify the 'individual' price plan
    And I close the browsing session

  @InvalidEmailId @RubicaWebApplication @P0
  Scenario: Verify whether invalid email id or no email id throws an error on the UI
    When I launch firefox browser
    And I can open rubica website
    Then I enter invalid email credentials and verify error message on the UI
    And I close the browsing session

  @ValidatePageContent @RubicaWebApplication @P0
  Scenario: Validate Page contents present in the webpage
    When I launch firefox browser
    And I can open rubica website
    Then I verify the following contents in the webpage
      | Plan_Start_Rate          | Monthly plans start at $39.99 |
      | Installation_Windows     | Download Now                  |
      | Installation_Mac         | Download Now                  |
      | Installation_Iphone_Ipad | Download Now                  |
      | Installation_Android     | Download Now                  |
      | Contact_Phone            | 866.278.2422                  |
      | Contact_Email            | hello@rubica.com              |
      | Media_Inquiries          | press@rubica.com              |
    And I close the browsing session

  @ValidateCreditCardDetails @EnrollNow @RubicaWebApplication @P0
  Scenario: Validte credit card details
    When I launch firefox browser
    And I can open rubica website
    Then I verify the following fields are filled in 'individual' plan
      | First_Name             | Ini               |
      | Last_Name              | Ramesh            |
      | Email                  | ir@gmail.com      |
      | Password               | Redmond@98007     |
      | Confirm_Password       | Redmond@98007     |
      | Recovery_Email         | ir@hotmail.com    |
      | Recovery_Secret_Phrase | I live in redmond |
      | Zip_Code               | 98007             |
      | Expiration_Month       | 10                |
      | Expiration_Year        | 2021              |
      | Security_Code          | 123               |
      | Phone_Country_Code     | USA               |
      | Phone_Number           | 4251231234        |
      | Terms_And_Conditions   | True              |
    And I generate valid credit card numbers and validate whether the page is locked with 'all_fields'
    And I generate invalid credit card numbers and validate whether the page is locked with 'invalid_fields'
    And I close the browsing session

  @ValidLoginCredentials @RubicaWebApplication @P0
  Scenario: Validate Login page with valid credentials
    When I launch firefox browser
    And I can open rubica website
    Then I validate login page with the following 'valid' credentials
      | Login_Email    | rubica@gmail.com |
      | Login_Password | rubica           |
    And I close the browsing session

  @InvalidLoginCredentials @RubicaWebApplication @P0
  Scenario: Validate Login page with invalid credentials
    When I launch firefox browser
    And I can open rubica website
    Then I validate login page with the following 'invalid' credentials
      | Login_Email    | rubica@i.com |
      | Login_Password | rubica       |
    And I close the browsing session

  @ValidatePasswordMismatch @EnrollNow @RubicaWebApplication @P0
  Scenario: Validte error messages for password mismatch in the enrollment page
    When I launch firefox browser
    And I can open rubica website
    Then I verify the following fields are filled in 'individual' plan
      | First_Name       | Ini           |
      | Last_Name        | Ramesh        |
      | Email            | i@i.com       |
      | Password         | Redmond@98007 |
      | Confirm_Password | Redmond       |
    And I validate the error messages for password mismatch