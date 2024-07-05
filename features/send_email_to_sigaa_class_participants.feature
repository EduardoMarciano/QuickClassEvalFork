Feature: Sending Email to SIGAA Class Participants

  Scenario: Sending email upon importing new users
    Given I am logged in as an administrator
    And I am on the management page
    And I have access to the functionality of importing new users

    When I press "Importar Dados e Iniciar um Novo Semestre"
    And I press "Enviar Email de Cadastro para Alunos"

    Then I should see "Chave de acesso enviada para todos os Alunos Importados do SIGAA."
