require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "password_reset" do
    user = users(:one)

    user.create_reset_digest

    mail = UserMailer.password_reset(user)

    assert_equal "Password reset", mail.subject
    assert_equal [ user.email ], mail.to
    assert_equal [ "from@example.com" ], mail.from

    body = mail.text_part.body.decoded
    assert_match "パスワード", body
    assert_match user.reset_token, body
  end
end
