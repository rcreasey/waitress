Feature: Handle Orders
  In order facilitate the automation of freshly spawned nodes
  I want to be able to take a baseline node and provide a proper node JSON
  
  Scenario: Default usage banner
    Given I request GET "/usage"
    Then I should see "Welcome to Waitress"
  
  Scenario: List orders
    Given the following order
    | mac_address       | node                                            |
    | B2-E7-D1-A7-61-9D | {"scaffold": {"hostname": "some-node-name"}}    |
    | B2-E7-D1-A7-61-3E | {"scaffold": {"hostname": "another-node-name"}} |
    | B2-E7-D1-A7-61-5B | {"scaffold": {"hostname": "that-node-name"}}    |
    And I request GET "/"
    Then I should see "Waitress Current Orders"
    And I should see "B2-E7-D1-A7-61-9D"
    And I should see "B2-E7-D1-A7-61-3E"
    And I should see "B2-E7-D1-A7-61-5B"
  
  Scenario: Fetch a node from a MAC Address
    Given the following order
    | mac_address       | node                                         |
    | B2-E7-D1-A7-61-9D | {"scaffold": {"hostname": "some-node-name"}} |
    When I request GET "/B2-E7-D1-A7-61-9D"
    Then I should see JSON: {"scaffold": {"hostname": "some-node-name"}}
    And the database should not have a key for "B2-E7-D1-A7-61-9D"
  
  Scenario: Fetch a node where that doesn't exist
    Given the database is empty
    When I request GET "/B2-E7-D1-A7-61-9D"
    Then I should see JSON: {"Status": "Are you sure you have an order up?  I can't seem to find it."}

  Scenario: Create an order from a MAC Address and node JSON
    Given the database is empty
    When I POST the following order
    | mac_address       | node                                            |
    | B2-E7-D1-A7-61-F1 | {"scaffold": {"hostname": "another-node-name"}} |
    Then I should see JSON: {"Status": "Order up for B2-E7-D1-A7-61-F1."}
    And the database should have a key for "B2-E7-D1-A7-61-F1"
  
  Scenario: Create an order without a MAC Address
    Given the database is empty
    When I POST the following order
    | node                                            |
    | {"scaffold": {"hostname": "another-node-name"}} |
    Then I should see JSON: {"Status": "Malformed order. I need a mac_address and a node JSON to take your order."}
  
  Scenario: Create an order without a node
    Given the database is empty
    When I POST the following order
    | mac_address       |
    | B2-E7-D1-A7-61-F1 |
    Then I should see JSON: {"Status": "Malformed order. I need a mac_address and a node JSON to take your order."}
  
