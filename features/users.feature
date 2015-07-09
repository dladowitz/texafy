Feature: Users features
  Users can create accounts and log in

  Scenario: Users can create an account
    Given Guest visits the landing_path
    Then  they visit the new user page
    Then  they fill out the new user form
    And   they see the user homepage
