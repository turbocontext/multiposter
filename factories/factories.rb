# -*- encoding: utf-8 -*-
FactoryGirl.define do

  factory :user do
    email
    password 'please'
    password_confirmation 'please'
  end

  sequence :email do |n|
    "example_#{n}@example.com"
  end
end
