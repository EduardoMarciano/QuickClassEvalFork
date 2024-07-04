class MakeTemplateOptionalToForm < ActiveRecord::Migration[7.1]
  def change
    change_column_null :forms, :template_id, true
  end
end
