Feature: Viewing Templates
    Scenario: There are templates to be seen
        Given there are templates for the current semester

        When I move to the Management page
        And I click the templates button

        Then I should see at least one template card

    Scenario: There are no templates to be seen
        Given I am an administrator

        When I move to the management page
        And I click the templates button

        Then I should not see any template cards
