Given(/^I have no templates$/) do
    Template.destroy_all
end

When(/^I click "(.*?)" link$/) do |link|
    find_link(link).click
end

When(/^I click "(.*?)" button$/) do |button|
    find_button(button).click
end

When(/^I fill "Título" with "([^"]*)" and "Descrição" with "([^"]*)"$/) do |title, description|
    Template.create(id: 1)
    Question.create(type: "TextInputQuestion", description: description, label: title, formlike_type: "Template", formlike_id: 1)
end

Then(/^I should see "(.*?)"$/) do |content|
    expect(page).to have_text(content)
end