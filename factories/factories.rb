# -*- encoding: utf-8 -*-
FactoryGirl.define do

  factory :user do
    email
    password 'please'
    password_confirmation 'please'
  end

  factory :social_user do
    uid
    provider "test_provider"
    access_token "access_token"
    secret_token "secret_token"
    nickname "nickname"
    url
    user
    checked true
    email
  end

  factory :message_set do
    user
  end

  factory :message do
    text "message text"
    url
    uid "123"
    access_token "access token"
    message_set
    social_user
  end

  sequence :url do |n|
    "url#{n}.example.com"
  end

  sequence :email do |n|
    "example_#{n}@example.com"
  end
  sequence :uid do |n|
    "uid_#{n}"
  end
end
