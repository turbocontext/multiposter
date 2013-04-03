Given(/^there are some social users$/) do
  3.times do |i|
    FactoryGirl.create(:social_user, nickname: "user_#{i}", user_id: @user.id)
  end
end

Given(/^I create message$/) do
  SocialUser.scoped.each do |suser|
    within("#social_user_#{suser.id}") do
      check("model_ids_")
    end
  end
  within "#create_message_button" do
    click_on "Create message"
  end

  # page.driver.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
  fill_in "Content for all Test provider profiles", with: "Test provider profile message"
  all('.test_provider_message textarea').each do |input|
    fill_in(input[:id], with: "Test provider profile message")
  end

  click_on "Post message"
end

Then(/^messages should be created$/) do
  click_on "Messages"
  page.should have_content("Test provider profile message")
end
