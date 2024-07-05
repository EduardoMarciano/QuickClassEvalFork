# Represents a template used for forms or questionnaires in the application.
#
# Templates can be associated with multiple forms and questions through has_many associations.
#
class Template < ApplicationRecord
  has_many :form, dependent: :nullify
  has_many :questions, as: :formlike

  def to_s
    "Modelo \##{self[:id]}"
  end
end
