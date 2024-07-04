Feature: Tests for the users endpoint

    Background: Preconditions
        Given url baseUrl
        * def userRequestBody = read('classpath:serveRest/json/newUserRequestBody.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * set userRequestBody.nome = dataGenerator.getRandomUsername()
        * set userRequestBody.email = dataGenerator.getRandomEmail()
        * set userRequestBody.password = dataGenerator.getRandomPassword()
        * set userRequestBody.administrador = dataGenerator.getRandomBooleaString()
    Scenario: List users successfully 
        Given path 'usuarios'
        When method Get
        Then status 200
        And match response.usuarios == "#array"
        And match response.quantidade == "#number"
    
    Scenario: List user by id successfully
        #create - pre-requisite
        Given path 'usuarios'
        And request userRequestBody
        When method Post
        Then status 201
        And match response.message == "Cadastro realizado com sucesso"
        And def userId = response._id
        
        #get by id - test
        Given path 'usuarios', userId
        When method Get
        Then status 200
        And match response == 
        """
            {
                "nome": "#string",
                "email": "#string",
                "password": "#string",
                "administrador": "#string",
                "_id": "#string"
            }
        """
        #delete - clean up
        Given path 'usuarios', userId
        When method Delete
        Then status 200
        And match response.message == "Registro excluído com sucesso"
