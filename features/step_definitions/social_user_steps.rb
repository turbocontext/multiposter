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
  fill_in "All facebook profiles", with: "Facebook profile message"
  fill_in "All facebook pages", with: "Facebook pages message"
  fill_in "All twitter profiles", with: "Twitter profile message"
  click_on "Create"
  # page.driver.save_screenshot Rails.root.join("tmp/capybara/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.png")
end

Then(/^messages should be created$/) do
  click_on "Messages"
  page.should have_content("Facebook profile message")
  page.should have_content("Facebook page message")
  page.should have_content("Twitter profile message")

end
