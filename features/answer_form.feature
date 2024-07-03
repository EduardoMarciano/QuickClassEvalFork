Feature: Reply form
    Scenario: Successfully selecting e viewing the form
        Given A manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I should see at least one evaluation card

            When I press "Avaliar Disciplina"
            Then I should see a button "Salvar"
            
   Scenario: No form to answer
        Given No manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I should not see any evaluation cards

    Scenario: Successfully filling out and submitting the form
        Given A manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I press "Avaliar Disciplina"
            
            When I answer all the questions
            And I press "Salvar"
        
            Then I should see "Formulário respondido com sucesso"
            
    Scenario: Submitting the form without answer
        Given A manager send a evaluation
            And I am a student
            And I am on the evaluations page
            And I press "Avaliar Disciplina"

            When I press "Salvar"
        
            Then I should not see "formulario enviado com sucesso"