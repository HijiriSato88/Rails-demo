class ChangeLikesCountDefaultOnPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :posts, :likes_count, from: nil, to: 0
  end
end