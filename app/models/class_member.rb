class ClassMember < ApplicationRecord
  def self.create_by_json(discente_data)

    unless ClassMember.exists?()
      create!(
        email: discente_data["email"],
        discipline_code: discente_data["discipline_code"]
      )
    end
  end
end
