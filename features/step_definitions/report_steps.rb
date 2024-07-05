Given('I have a form for a discipline') do
  Semester.destroy_all
  Template.destroy_all
  Discipline.destroy_all
  Form.destroy_all

  Semester.create(id: 1, half: false, year: 2020)
  Template.create(id: 1)
  Discipline.create(id: 1, semester_id: 1)
  Form.create(template_id: 1, discipline_id: 1)
end

Given('I have no semesters registered') do
  Semester.destroy_all
end

Then('I should download a CSV file for that discipline') do
  expect(CSV.parse(page.body).transpose).to eq([["Template"]])
end

Then('I should download a CSV file for the disciplines of that semester') do
  expect(CSV.parse(page.body).transpose).to eq([["Disciplina; Template"]])
end

Then('I should download a CSV file for all available semesters') do
  expect(CSV.parse(page.body).transpose).to eq([["Semestre; Disciplina; Template"]])
end
