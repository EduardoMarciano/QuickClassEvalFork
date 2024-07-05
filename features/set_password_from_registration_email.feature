Feature: Create account

  Scenario: Create account with correct code
    Given I have received a password reset email with a code
    And I am on the create page
    When I enter the correct reset code
    And I enter an email that has been notified
    And I enter matching password and confirmation password
    And I click on Sign Up
    Then I should be redirected to the login page

  Scenario: Create account with Incorrect reset code
    Given I have received a password reset email with a code
    And I am on the create page
    When I enter an incorrect reset code
    And I enter an email that has not been notified
    And I enter matching password and confirmation password
    And I click on Sign Up
    Then I should see an error message "Email ou chave de cadastro inválidos, entre em contato com seu coordenador."

  Scenario: Create account with not notified email
    Given I have received a password reset email with a code
    And I am on the create page
    When I enter the correct reset code
    And I enter an email that has not been notified
    And I enter matching password and confirmation password
    And I click on Sign Up
    Then I should see an error message "Email ou chave de cadastro inválidos, entre em contato com seu coordenador."

  Scenario: Create account with already registered email
    Given I have received a password reset email with a code
    And I am on the create page
    When I enter the correct reset code
    And I enter an email that has been notified
    And the email has already been registered
    And I enter matching password and confirmation password
    And I click on Sign Up
    Then I should see an error message "Email já cadastrado, entre em contato com o administrador."

  Scenario: Create account with mismatching passwords
    Given I have received a password reset email with a code
    And I am on the create page
    When I enter the correct reset code
    And I enter an email that has been notified
    And I enter a password
    And I enter a different confirmation password
    And I click on Sign Up
    Then I should see an error message "As senhas devem coincidir."