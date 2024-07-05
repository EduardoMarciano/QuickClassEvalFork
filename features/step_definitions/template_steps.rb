Given('there are templates for the current semester') do
  Rails.application.load_seed
  step 'I imported data from SIGAA'
end

When('I click the templates button') do
  click_button 'flow-templates-button'
end

When('I click the "remove templates" button') do
  first(:button, text: 'Remover').click
end

Then('I should see 4 "remover" buttons') do
  expect(all(:button, text: 'Remover').count).to eq 4
end
