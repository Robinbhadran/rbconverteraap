class AddUserIdToPostAttachment < ActiveRecord::Migration
  def change
    add_column :post_attachments, :user_id, :integer
  end
end
