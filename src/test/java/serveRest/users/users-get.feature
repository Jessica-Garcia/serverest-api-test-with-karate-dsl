Feature: Get Users

    Background: Preconditions
        Given url baseUrl
        * def result = callonce read('classpath:helpers/RegisterUser.feature')
        * def userId = result.userId
        * configure afterFeature = function(){ karate.call('classpath:helpers/DeleteUser.feature'), { userId: userId } }
        

   
    Scenario: List users successfully 
        Given path 'usuarios'
        When method Get
        Then status 200
        And match response.usuarios == "#array"
        And match response.quantidade == "#number"
    
    Scenario: List user by id successfully
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
    
    Scenario: Try to list user with non-existent id
        Given path 'usuarios', 'non-existent-id-1-2-3-4'
        When method Get
        Then status 400
        And match response == 
        """
            {
                "message": "Usuário não encontrado"
            }
        """
    
    Scenario: Try to list a user with a non-existent name
        Given path 'usuarios'
        And param nome = 'non-existent-name-1-2-3-4'
        When method Get
        Then status 200
        And match response.usuarios == "#array"
        And match response.quantidade == 0

    