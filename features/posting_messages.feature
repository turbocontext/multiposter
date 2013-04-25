Feature: posting messages from social users
  In order to promote myself in social networks
  As a user
  I want to post some messages

  Background:
    Given I am successfully signed in
    And there are some social users

  @javascript
  Scenario: creating message
    Given I am on the social users page
    And I create message
    Then messages should be created
