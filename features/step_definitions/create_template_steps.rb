Given(/^I have no templates$/) do
    Template.destroy_all
end

When(/^I click "(.*?)" link$/) do |link|
    find_link(link).click
end

When(/^I click "(.*?)" button$/) do |button|
    find_button(button).click
end

When(/^I fill "Título" with "([^"]*)"$/) do |content|
    find_by_id("question_label").set(content)
end

When(/^I fill "Descrição" with "([^"]*)"$/) do |content|
    find_by_id("question_description").set(content)
end

Then(/^I should see "(.*?)"$/) do |content|
    expect(page).to have_text(content)
end