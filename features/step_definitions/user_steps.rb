#-*- encoding: utf-8 -*-
# page.driver.render Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
def delete_users
  User.delete_all
end

def create_visitor
  @visitor ||= {}
  @visitor[:email] = FactoryGirl.generate(:email)
  @visitor[:password] = "password"
  @visitor[:password_confirmation] = "password"
end

def create_and_confirm_user
  create_visitor
  @user = FactoryGirl.create(:user, email: @visitor[:email], password: @visitor[:password], password_confirmation: @visitor[:password_confirmation])
end

def sign_in
  visit new_user_session_path
  fill_in "Email", with: @visitor[:email]

  fill_in "Password", with: @visitor[:password]
  click_button "Sign in"
end

def find_user
  @user = User.find_by_email(@visitor[:email])
end

def sign_up
  delete_users
  visit new_user_registration_path
  fill_in "Email",                 with: @visitor[:email]
  fill_in "Password",              with: @visitor[:password]
  fill_in "Password confirmation", with: @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_up_with_confirm
  create_visitor
  sign_up
  open_last_email
  visit_in_email("Confirm my account")
  find_user
end

When /^I sign up with valid credentials$/ do
  create_visitor
  sign_up
end

Then /^I should see confirmation message$/ do
  page.should have_content('confirmation link')
end

Then /^I should be confirmed$/ do
  find_user.should be_confirmed
end

Then /^I should have message on given email$/ do
  unread_emails_for(@user.email).size.should == parse_email_count(1)
end

When /^I open confirmation link in email$/ do
  open_last_email
  visit_in_email("Confirm my account")
end

When /^I sign up without email$/ do
  create_visitor
  @visitor.merge!(email: "")
  sign_up
end

Then /^I should see invalid email message$/ do
  page.should have_content("не может быть пустым")
end

When /^I sign up without password$/ do
  create_visitor
  @visitor.merge!(password: "")
  sign_up
end

Then /^I should see invalid password message$/ do
  page.should have_content("не может быть пустым")
end

Given /^I am successfully signed up$/ do
  create_and_confirm_user
end

Then /take a snapshot/ do
  page.driver.render Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
end

Given /^I am registered user$/ do
  create_and_confirm_user
end

When /^I enter valid sign in credentials$/ do
  sign_in
end

When /^I enter invalid sign in credentials$/ do
  @visitor[:password] = 'wrong_password'
  sign_in
end

Then /^I should be in my account$/ do
  page.should have_content("Выйти")
  page.should have_content(@visitor[:name])
end

Then /^I should see invalid login password warning$/ do
  page.should have_content("Неверный логин или пароль.")
end

Then /^I should see missing name message$/ do
  page.should have_content("не может быть пустым")
end

Then /^I should see welcome message$/ do
  page.should have_content("Добро пожаловать")
end

Given /^I am successfully signed in$/ do
  create_and_confirm_user
  sign_in
end

When /^I try to sign out$/ do
  visit destroy_user_session_path
end

Then /^I should be on main page$/ do
  current_path.should == root_path
end

Given /^I have successfully signed in as administrator$/ do
  create_and_confirm_user
  admin = User.first
  admin.update_column(:role, "administrator")
  admin.save
  sign_in
end

When /^I sign up without name$/ do
  create_visitor
  @visitor.merge!(name: "")
  sign_up
end

Then /^there are some users$/ do
  3.times do |i|
    FactoryGirl.create(:user, name: "test_user_#{i}")
  end
end

Then /^I should see them on users list$/ do
  visit admin_users_path
end

When /^I delete user$/ do
  click_on "Удалить"
end

Then /^I should not see him on users list$/ do
  page.should have_content("Пользователь успешно удален")
end

Given /^there is user online$/ do
  u = User.first
  u.update_column(:updated_at, Date.today)
end

Then /^I should see online mark$/ do
  page.should have_content("online")
end

Then /^I should see number of online users$/ do
  page.should have_content("Онлайн:")
end

Then /^he should have another role$/ do
  visit admin_users_path
  page.should have_content("Администратор")
end

When /^I edit user's role$/ do
  visit edit_admin_user_path(User.first)
  select "Администратор", from: "Роль"
  click_on "Изменить"
end
