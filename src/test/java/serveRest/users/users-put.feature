Feature: Update User

   Background: preconditions
      Given url baseUrl
      * def result = callonce read('classpath:helpers/RegisterUser.feature')
      * def userId = result.userId

      * def userRequestBody = read('classpath:serveRest/json/newUserRequestBody.json')
      * def dataGenerator = Java.type('helpers.DataGenerator')

      * set userRequestBody.nome = dataGenerator.getRandomUsername()
      * set userRequestBody.email = dataGenerator.getRandomEmail()
      * set userRequestBody.password = dataGenerator.getRandomPassword()
      * set userRequestBody.administrador = dataGenerator.getRandomBooleaString()
      
      * configure afterFeature = function(){ karate.call('classpath:helpers/DeleteUser.feature'), { userId: userId } }

   Scenario: Update user successfully
      
      Given path 'usuarios', userId
      And request userRequestBody
      When method Put
      Then status 200
      And match response.message == "Registro alterado com sucesso"
      
      Given path 'usuarios', userId
      When method Get
      Then status 200

   Scenario: Try to update user with non-existent id

      Given path 'usuarios', '1-non-existent-id-1-2-3-4'
      And request userRequestBody
      When method Put
      Then status 201
      And match response.message == "Cadastro realizado com sucesso"
      And match response._id == "#string"
      And def newId = response._id

      Given path 'usuarios', newId
      When method Get
      Then status 200

      Given path 'usuarios', newId
      When method Delete
      Then status 200
      And match response.message == "Registro excluído com sucesso"
   
   Scenario Outline: Try update user with invalid data
      
      * def randomEmail = dataGenerator.getRandomEmail()
      * def randomName = dataGenerator.getRandomUsername()
      * def randomPassword = dataGenerator.getRandomPassword()

      Given path 'usuarios', userId
      And request
         """
            {
               "nome": "<nome>",
               "email": "<email>",
               "password": "<password>",
               "administrador": "false"
            }
         """
      When method Put
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