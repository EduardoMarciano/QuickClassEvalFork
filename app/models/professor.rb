# Represents a professor in the application.
#
# Professors are individuals who teach courses or classes within the educational institution.
#
# @!attribute name
#   @return [String] the name of the professor
# @!attribute department_code
#   @return [String] the code of the department to which the professor belongs
# @!attribute registration_number
#   @return [String] the unique registration number of the professor
#
class Professor < ApplicationRecord

  # Creates a professor record from a JSON data hash.
  #
  # This method checks if a professor with the given registration number already exists.
  # If not, it creates a new record with the provided data.
  #
  # @param docente_data [Hash] a hash containing the professor's data
  # @option docente_data [String] :name the name of the professor
  # @option docente_data [String] :department_code the department code of the professor
  # @option docente_data [String] :registration the registration number of the professor
  # @return [Professor, nil] the created professor record, or nil if it already exists
  def self.create_by_json(docente_data)
    registration_number = docente_data["registration"]

    unless Professor.exists?(registration_number: registration_number)
      create!(
        name: docente_data["name"],
        department_code: docente_data["department_code"],
        registration_number: registration_number
      )
    end
  end

  # Finds a professor by their registration number.
  #
  # @param registration_number [String] the unique registration number of the professor
  # @return [Professor, nil] the professor record, or nil if not found
  def self.find_by_registration(registration_number)
    find_by(registration_number: registration_number)
  end

end
