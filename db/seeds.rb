users = [
  ["hoge", 20, "hoge@user.com"], 
  ["fuga", 23, "fuga@user.com"], 
  ["piyo", 22, "piyo@user.com"]
]

users.each do |name, age, email| 
  User.create(name: name, age: age, email: email)
end