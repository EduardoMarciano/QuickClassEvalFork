@create_template
Feature: Create Template 

    As an admin,
    I want to create a new template,
    So that I can manage my forms.

    Background:
        Given I am logged in as an administrator
        And I am on the templates page

    @valid_template
    Scenario: Create a valid template
        Given I have no templates
        When I click "Novo modelo" link
      	And I click "+ Texto" button
        And I fill "Título" with "1+1?" and "Descrição" with "Quanto é?"
      	And I click "Salvar modelo" button
        Then I should be on the templates page
      	And I should see "Modelo #1"	

    @invalid_template
    Scenario: Create an invalid template	
      	Given I have no templates
        When I click "Novo modelo" link
      	And I click "Salvar modelo" button
      	Then I should see "Crie pelo menos uma questão."