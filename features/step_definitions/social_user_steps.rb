# -*- encoding: utf-8 -*-
Given(/^there are some social users$/) do
  3.times do |i|
    FactoryGirl.create(:social_user, nickname: "user_#{i}", user_id: @user.id)
  end
end
