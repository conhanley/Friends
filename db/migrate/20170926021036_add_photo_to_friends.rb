class AddPhotoToFriends < ActiveRecord::Migration[5.1]
  def change
    add_column :friends, :photo, :string
  end
end
