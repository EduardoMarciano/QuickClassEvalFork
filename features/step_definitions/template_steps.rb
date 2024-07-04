Given('there are templates for the current semester') do
  Rails.application.load_seed
  step 'I imported data from SIGAA'
end

When('I click the templates button') do
  click_button 'flow-templates-button'
end
