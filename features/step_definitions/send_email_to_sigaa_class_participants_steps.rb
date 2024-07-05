Given('I have access to the functionality of importing new users') do
  step('I should see "Importar Dados e Iniciar um Novo Semestre"')
end
When('I press "Importar Dados e Iniciar um Novo Semestre"') do
  click_button 'Importar Dados e Iniciar um Novo Semestre'
end
When('I press "Enviar Email de Cadastro para Alunos"') do
  click_button 'Enviar Email de Cadastro para Alunos'
end
