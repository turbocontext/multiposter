# -*- encoding: utf-8 -*-
Given(/^I create message$/) do
  SocialUser.scoped.each do |suser|
    within("#social_user_#{suser.id}") do
      check("model_ids_")
    end
  end
  within "#create_message_button" do
    click_on "Create message"
  end

  fill_in "Content for all Test provider profiles", with: "Test provider profile message"
  all('.test_provider_message textarea').each do |input|
    fill_in(input[:id], with: "Test provider profile message")
  end
  within "#post_message_button" do
    click_on "Post message"
  end
end

Then(/^messages should be created$/) do
  click_on "Messages"
  page.should have_content("Test provider profile message")
end
Given(/^there are some messages$/) do
  @message_set = FactoryGirl.create(:message_set, user: @user)
  3.times do |i|
    @message = FactoryGirl.create(:message, text: "message_text_#{i}", message_set: @message_set)
  end
end

Given(/^I delete message$/) do
  within("#message_#{@message.id}") do
    click_on "Delete"
  end
end

Then(/^messages should be deleted$/) do
  page.should_not have_content(@message.text)
end
