[
  { email: "sample1@fancast.jp", name: "sample1", mock_user: false },
  { email: "sample2@fancast.jp", name: "sample2", mock_user: true }
].each do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.password = "password123"
    u.password_confirmation = "password123"
    u.activated = true
    u.mock_user = user_data[:mock_user]
  end
end
