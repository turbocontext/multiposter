Feature: deleting messages
  In order to delete useless or just stupid messages
  As a user
  I want to delete them from site instead of directly from the social networks

  Background:
    Given I am successfully signed in
    And there are some messages

  @javascript
  Scenario: deleting message
    Given I am on messages page
    And I delete message
    Then messages should be deleted
