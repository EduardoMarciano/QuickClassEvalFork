@report
Feature: Generating CSV report

  @discipline
  Scenario: Downloading discipline CSV report
    Given I am logged in as an administrator
    And I have a form for a discipline
    And I am on the evaluations page
    When I click "Baixar Resultados" link
    Then I should download a CSV file for that discipline

  @semester
  Scenario: Downloading semester CSV report
    Given I am logged in as an administrator
    And I have a form for a discipline
    And I am on the management page
    When I click "Gerar CSV de Resultados deste Semestre" button
    Then I should download a CSV file for the disciplines of that semester

  @all
  Scenario: Downloading all semesters CSV report
    Given I am logged in as an administrator
    And I have a form for a discipline
    And I am on the management page
    When I click "Gerar CSV de Resultados de todos os Semestres" button
    Then I should download a CSV file for all available semesters

  @semester_nil
  Scenario: No semesters registered for semester report
    Given I am logged in as an administrator
    And I am on the management page
    And I have no semesters registered
    When I click "Gerar CSV de Resultados deste Semestre" button
    Then I should see "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."

  @all_nil
  Scenario: No semesters registered for all semesters report
    Given I am logged in as an administrator
    And I am on the management page
    And I have no semesters registered
    When I click "Gerar CSV de Resultados de todos os Semestres" button
    Then I should see "Não é possível exportar resultados sem um semestre cadastrado, importe os dados do sistema."
