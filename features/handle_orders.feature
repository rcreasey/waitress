Feature: Handle Orders
  In order facilitate the automation of freshly spawned nodes
  I want to be able to take a baseline node and provide a proper node json
  
  Scenario: Default usage banner
    Given I am viewing "/"
    Then I should see "Welcome to Waitress"
        
  Scenario: Fetch a node from a MAC Address
    Given the following paring
    | mac_address       | node                                         |
    | B2-E7-D1-A7-61-9D | {"scaffold": {"hostname": "some-node-name"}} |
    When I am viewing "/B2-E7-D1-A7-61-9D"
    Then I should see JSON: {"scaffold": {"hostname": "some-node-name"}}
    