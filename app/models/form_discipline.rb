# Represents the association between a form and a discipline in the application.
#
# FormDiscipline establishes a many-to-many relationship between forms and disciplines.
# Each instance links a specific form to a specific discipline.
#
class FormDiscipline < ApplicationRecord
  belongs_to :form
  belongs_to :discipline
end
  