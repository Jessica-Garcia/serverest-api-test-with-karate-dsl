Feature: Create User
    
   Background: preconditions
      * def userRequestBody = read('classpath:serveRest/json/newUserRequestBody.json')
      * def dataGenerator = Java.type('helpers.DataGenerator')
      * set userRequestBody.nome = dataGenerator.getRandomUsername()
      * set userRequestBody.email = dataGenerator.getRandomEmail()
      * set userRequestBody.password = dataGenerator.getRandomPassword()
      * set userRequestBody.administrador = dataGenerator.getRandomBooleaString()
   
   Scenario: Register new User
      Given url baseUrl
      Given path 'usuarios'
      And request userRequestBody
      When method POST
      Then status 201
      And def userId = response._id