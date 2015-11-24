class RenameCharacterToTree < ActiveRecord::Migration
  def change
    rename_table :characters, :trees
  end
end
