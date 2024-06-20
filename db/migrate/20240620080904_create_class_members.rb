class CreateClassMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :class_members do |t|
      t.string :email, null: false
      t.string :discipline_codes, null: false

      t.timestamps
    end
    add_index :class_members, :email, unique: true
  end
end
