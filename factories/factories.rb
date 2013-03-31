# -*- encoding: utf-8 -*-
FactoryGirl.define do

  factory :user do
    email
    password 'please'
    password_confirmation 'please'
  end

  factory :social_user do
    uid "123"
    provider "test_provider"
    access_token "access_token"
    secret_token "secret_token"
    nickname "nickname"
    user
    email
  end

  sequence :email do |n|
    "example_#{n}@example.com"
  end
end
