@parallel=false
Feature: Delete User

   Background: preconditions
      Given url baseUrl
      * def createdUser = callonce read('classpath:helpers/RegisterUser.feature')
      * def userId = createdUser.userId
      * configure afterFeature = function(){ karate.call('classpath:helpers/DeleteUser.feature'), { userId: userId } }

   Scenario: Delete User
      Given path 'usuarios', userId
      When method Delete
      Then status 200
      And match response.message == "Registro excluído com sucesso"  
   
   #This scenario depends on the previous scenario for the test to pass
   #Question: When one scenario depends on another, is it enough to use parallel=false?
   Scenario: Try to delete user with non-existent id
      Given path 'usuarios', userId
      When method Delete
      Then status 200
      And match response.message == "Nenhum registro excluído"

      