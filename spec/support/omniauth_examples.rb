#-*- encoding: utf-8 -*-
require "ostruct"
module OmniauthExamples
  def self.facebook_oauth
    {
      provider: 'facebook',
      uid: '100003700047553',
      info: {
        nickname: 'official.kavigator',
        name: 'Official Kavigator',
        email: 'kavigator@gmail.com',
        first_name: 'Official',
        last_name: 'Kavigator',
        image: 'http://graph.facebook.com/100003700047553/picture?type=square',
        urls: {
          "Facebook" => 'http://www.facebook.com/official.kavigator'
        },
        location: 'Makhachkala',
        verified: true
      },
      credentials: {
        token: 'The secret token',
        expires_at: '1364215148',
        expires: true
      },
      extra: {
        raw_info: {
          id: '100003700047553',
          name: 'Official Kavigator',
          first_name: 'Official',
          last_name: 'Kavigator',
          link: 'http://www.facebook.com/official.kavigator',
          username: 'official.kavigator',
          location:{
            id: '108527135837627',
            name: 'Makhachkala'
          },
          gender: 'male',
          email: 'kavigator@gmail.com',
          timezone: '4',
          locale: 'en_US',
          verified: true,
          updated_time: '2013-01-15T12:11:25+0000'
        }
      }
    }
  end

  def self.twitter_oauth
    {
      provider: 'twitter',
      uid: '100003700047553',
      info: {
        nickname: 'official.kavigator',
        name: 'Official Kavigator',
        first_name: 'Official',
        last_name: 'Kavigator',
        image: 'http://graph.facebook.com/100003700047553/picture?type=square',
        urls: {
          "Facebook" => 'http://www.facebook.com/official.kavigator'
        },
        location: 'Makhachkala',
        verified: true
      },
      credentials: {
        token: 'The secret token',
        expires_at: '1364215148',
        expires: true
      },
      extra: {
        raw_info: {
          id: '100003700047553',
          name: 'Official Kavigator',
          first_name: 'Official',
          last_name: 'Kavigator',
          link: 'http://www.facebook.com/official.kavigator',
          username: 'official.kavigator',
          location:{
            id: '108527135837627',
            name: 'Makhachkala'
          },
          gender: 'male',
          email: 'kavigator@gmail.com',
          timezone: '4',
          locale: 'en_US',
          verified: true,
          updated_time: '2013-01-15T12:11:25+0000'
        }
      }
    }
  end

  def self.test_oauth
    {
      provider: 'test_provider',
      uid: '100003700047553',
      info: {
        nickname: 'official.kavigator',
        name: 'Official Kavigator',
        first_name: 'Official',
        last_name: 'Kavigator',
        image: 'http://graph.facebook.com/100003700047553/picture?type=square',
        urls: {
          "Facebook" => 'http://www.facebook.com/official.kavigator'
        },
        location: 'Makhachkala',
        verified: true
      },
      credentials: {
        token: 'The secret token',
        expires_at: '1364215148',
        expires: true
      },
      extra: {
        raw_info: {
          id: '100003700047553',
          name: 'Official Kavigator',
          first_name: 'Official',
          last_name: 'Kavigator',
          link: 'http://www.facebook.com/official.kavigator',
          username: 'official.kavigator',
          location:{
            id: '108527135837627',
            name: 'Makhachkala'
          },
          gender: 'male',
          email: 'kavigator@gmail.com',
          timezone: '4',
          locale: 'en_US',
          verified: true,
          updated_time: '2013-01-15T12:11:25+0000'
        }
      }
    }
  end
end
