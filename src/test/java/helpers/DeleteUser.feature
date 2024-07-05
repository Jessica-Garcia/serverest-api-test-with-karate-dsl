Feature: Delete User

   Background: preconditions
      Given url baseUrl

   Scenario: Delete User
      Given path 'usuarios', userId
      When method Delete
      Then status 200