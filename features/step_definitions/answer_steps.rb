Given('A manager send a evaluation') do
  step('I imported data from SIGAA')
  step('the importation should be successful')

  Rails.application.load_seed
  step('I am on the Send page')

  checkboxes_exist = false
  checkboxes_to_select = []

  (1..10).each do |id|
    if page.has_css?("#discipline_ids_#{id}")
      checkboxes_exist = true
      checkboxes_to_select << id
    end
  end

  raise 'No checkboxes found' unless checkboxes_exist

  # Check all
  checkboxes_to_select.each do |id|
    check("discipline_ids_#{id}")
  end
  puts Template.all.inspect

  click_button(:commit)
end

When('I press "Avaliar Disciplina"') do
  click_link('Avaliar Disciplina', match: :first)
end

When('I press "Salvar"') do
  click_button('Salvar')
end

Given('No manager send a evaluation') do
  step('I send forms wihout checking any classes')
end

Then('I should see a button "Salvar"') do
  expect(page).to have_button 'Salvar'
end

Then('I should not see {string}') do |string|
  expect(page).not_to have_text(string)
end

Given('I answer all the questions') do
  choose 'questions_16_nem_clara_nem_confusa'
  choose 'questions_17_não_fizeram_diferença'
  fill_in('Resposta:', with: 'Lorem ipsum')
end
