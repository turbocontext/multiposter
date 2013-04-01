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
end

Then(/^messages should be created$/) do
  pending # express the regexp above with the code you wish you had
end
