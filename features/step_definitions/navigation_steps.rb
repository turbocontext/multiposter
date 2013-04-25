# -*- encoding: utf-8 -*-
Given(/^I am on the social users page$/) do
  visit social_users_path
end

Given(/^I am on messages page$/) do
  visit message_sets_path
end
