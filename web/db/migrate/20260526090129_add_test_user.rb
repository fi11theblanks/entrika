class AddTestUser < ActiveRecord::Migration[8.1]
  def up
    return if User.exists?(email: "test@example.com")

    User.create!(
      email: "test@example.com",
      password: "password",
      password_confirmation: "password",
      username: "testuser"
    )
  end

  def down
    User.find_by(email: "test@example.com")&.destroy
  end
end
