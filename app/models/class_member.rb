class ClassMember < ApplicationRecord
  has_many :disciplines

  def self.create_by_json(discente_data)
    return if ClassMember.exists?

    create!(
      email: discente_data['email'],
      discipline_codes: discente_data['discipline_codes']
    )
  end
end
