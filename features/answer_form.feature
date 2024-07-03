Feature: Reply form
    Scenario: Successfully selecting e viewing the form
        Given A manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I should see at least one evaluation card

            When I press "Avaliar Disciplina"
            Then I should see a button "enviar"
            
   Scenario: No form to answer
        Given No manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I should not see any evaluation cards

    Scenario: Successfully filling out and submitting the form
        Given I am a student
            And I already selected form
            And I already answered all the questions

            When I press "enviar"
        
            Then I should see a success message "formulario enviado com sucesso"
            
    Scenario: Partialy filling out and submitting the form
        Given I am a student
            And I already selected form
            And I have answered some or none of the questions

            When I press "enviar"
        
            Then I should see a error message "não é possivel enviar formulario incompleto"