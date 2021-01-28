class CreateBanks < ActiveRecord::Migration[5.2]
  def change
    create_table :banks do |t|
      t.string :name
      t.string :username
      t.string :password
      t.string :city
      t.string :phone_number
      t.string :website_url
      t.timestamps
    end
  end
end
