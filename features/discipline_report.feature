@discipline_report
Feature: Generating CSV report for discipline forms

  Scenario: Downloading discipline CSV report
    Given I am logged in as an administrator
    And I have a form for a discipline
    And I am on the evaluations page
    When I click "Baixar Resultados" link
    Then I should download a CSV file for that discipline