Feature: Try to register user

   Background: preconditions
      Given url baseUrl
      * def createdUser = callonce read('classpath:helpers/RegisterUser.feature')
      * def userId = createdUser.userId
      * def dataGenerator = Java.type('helpers.DataGenerator')
      * configure afterFeature = function(){ karate.call('classpath:helpers/DeleteUser.feature'), { userId: userId } }


   Scenario: Try to register a user with an already registered email
      
      Given path 'usuarios', userId
      When method Get
      Then status 200
      And def userEmailRegistered = response.email
      
      Given path 'usuarios'
      And request 
      """
         {
            "nome": #(dataGenerator.getRandomUsername()),
            "email": #(userEmailRegistered),       
            "password": #(dataGenerator.getRandomPassword()),
            "administrador": #(dataGenerator.getRandomBooleaString())
         }
      """
      When method POST
      Then status 400
      And match response.message == "Este email já está sendo usado"

   
   Scenario Outline: Try regiter user with invalid data
      
      * def randomEmail = dataGenerator.getRandomEmail()
      * def randomName = dataGenerator.getRandomUsername()
      * def randomPassword = dataGenerator.getRandomPassword()

      Given path 'usuarios'
      And request
         """
            {
               "nome": "<nome>",
               "email": "<email>",
               "password": "<password>",
               "administrador": "false"
            }
         """
      When method POST
      Then status 400
      And match response == <errorResponse>

      Examples:
         | nome                | email                | password           | errorResponse                                     | 
         | #(randomName)       | 'invalid-email.com'  | #(randomPassword)  | {"email": "email deve ser um email válido"}       | 
         | #(randomName)       |                      | #(randomPassword)  | {"email": "email não pode ficar em branco"}       | 
         |                     |  #(randomEmail)      | #(randomPassword)  | {"nome": "nome não pode ficar em branco"}         | 
         | #(1234)             |  #(randomEmail)      | #(randomPassword)  | {"nome": "nome deve ser uma string"}              | 
         | #(randomName)       |  #(randomEmail)      |                    | {"password": "password não pode ficar em branco"} | 
         | #(randomName)       |  #(randomEmail)      | #(12)              | {"password": "password deve ser uma string"}      | 
  