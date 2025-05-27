require 'faker'
require 'activerecord-import'

bulk_users = []
(1..10_000).each do
  bulk_users << User.new(
    name: Faker::Name.name,
    age: rand(18..65),
    email: Faker::Internet.unique.email
  )
end
User.import(bulk_users)
puts "10,000 random users imported"

all_user_ids = User.pluck(:id)
posts = []

all_user_ids.each_with_index do |user_id, i|
  rand(0..100).times do
    posts << Post.new(
      user_id: user_id,
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph
    )
  end

  # 1万件ずつバルクインサートしてメモリ節約
  if posts.size >= 10_000
    Post.import(posts)
    puts "✅ Inserted #{posts.size} posts (checkpoint at user ##{i})"
    posts.clear
  end
end

# 残りをインポート
Post.import(posts) unless posts.empty?

puts "#{User.count} users and #{Post.count} posts."