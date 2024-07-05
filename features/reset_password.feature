Feature: Password Reset

Scenario: Request password reset
  Given I am logged in as a user
  And I am on the redefine_password page
  And I enter matching password and confirmation password
  When I click on Subimmit
  Then I should be redirected to the login page

Scenario: Request password reset with passwords not matching
  Given I am logged in as a user
  And I am on the redefine_password page
  And I enter a password
  And I enter a different confirmation password
  When I click on Subimmit
  Then I should see an error message "As senhas devem coincidir."