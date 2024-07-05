Given('the evaluations page is empty') do
  step 'move to the evaluations page'
  expect(page).not_to have_text 'Professor:'
  expect(page).not_to have_text 'Semestre:'
end
