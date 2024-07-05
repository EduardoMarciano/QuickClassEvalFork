Feature: Removing Templates
    Scenario: Removing a template
        Given there are templates for the current semester

        When I move to the Templates page
        And I click the "remove templates" button

        Then I should be on the templates page
        And I should see 4 "remover" buttons

    Scenario: No templates to remove
        Given I am an administrator

        When I move to the Templates page

        Then I should not see "Remover"

