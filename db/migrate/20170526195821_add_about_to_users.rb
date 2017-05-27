class AddAboutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :date_of_birth, :datetime
    add_column :users, :is_female, :boolean,default: false
    add_column :users, :about, :text
  end

end
