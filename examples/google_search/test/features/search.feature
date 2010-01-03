Feature: Search google

  Scenario: Search for watircraft
    When I search for 'watircraft'
    Then I should find 'bret'