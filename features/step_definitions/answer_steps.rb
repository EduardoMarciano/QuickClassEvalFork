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

Given('No manager send a evaluation') do
  step('I send forms wihout checking any classes')
end

Then('I should see a button "enviar"') do
  expect(page).to have_button 'Salvar'
end
