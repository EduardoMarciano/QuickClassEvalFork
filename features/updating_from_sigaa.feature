Feature: Updating data from SIGAA

  Scenario: Updating data
    Given I imported data from SIGAA
    And I am on the management page
    When When I click the "update from SIGAA" button
    Then I should see "Dados atualizados com sucesso!"
