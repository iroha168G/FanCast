require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーションチェック" do
    context "未入力チェック" do
      it "名前が未入力のとき、バリデーションチェックでエラーになること" do
        user = build(:user, name: "", email: "test100@test.com", password: "1234" )
        expect(user).to be_invalid
        expect(user.errors[:name]).to include("を入力してください。")
      end

      it "メールアドレスが未入力のとき、バリデーションチェックでエラーになること" do
        user = build(:user, name: "テスト", email: "", password: "1234" )
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("を入力してください。")
      end

      it "パスワードが未入力のとき、バリデーションチェックでエラーになること" do
        user = build(:user, name: "テスト", email: "test100@test.com", password: "" )
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("を入力してください。")
      end
    end

    context "超過チェック" do
      it "名前が33文字のとき、バリデーションチェックでエラーになること" do
        user = build(:user, name: "あいうえおかきくけこaaaaaiiiiiあいうえおかきくけこaiue", email: "test100@test.com", password: "1234" )
        expect(user).to be_invalid
        expect(user.errors[:name].first).to include("文字以内で入力してください。")
      end

      it "メールアドレスが256文字のとき、バリデーションチェックでエラーになること" do
        email = "#{"a" * 247}@test.com"
        user = build(:user, name: "テスト", email: email, password: "1234" )
        expect(user).to be_invalid
        expect(user.errors[:email].first).to include("文字以内で入力してください。")
      end

      it "パスワードが3文字のとき、バリデーションチェックでエラーになること" do
        user = build(:user, name: "テスト", email: "test100@test.com", password: "123" )
        expect(user).to be_invalid
        expect(user.errors[:password].first).to include("文字以上で入力してください。")
      end
    end

    context "正常系テスト" do
      it "全部正常のとき、バリデーションチェックでエラーにならないこと" do
        user = build(:user, name: "テスト", email: "test100@test.com", password: "1234" )
        expect(user).to be_valid
      end
    end
  end
end
