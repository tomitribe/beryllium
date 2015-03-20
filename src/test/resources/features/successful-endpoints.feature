Feature: Successful rest calls

  # DATABASE SQL SCRIPT
  Scenario: Retrieve users list preparing db with script
    Given I have the following sql script "sample-data.sql"
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be "200"
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
          "id": 101,
          "created": "${json-unit.ignore}",
          "modified": "${json-unit.ignore}",
          "email": "cchacin@superbiz.org",
          "fullname": "Carlos",
          "password": "passWorD"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                | fullname | password |
      | 1  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin@superbiz.org | Carlos   | passw0rd |
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be "200"
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
          "id": 1,
          "created": "${json-unit.ignore}",
          "modified": "${json-unit.ignore}",
          "email": "cchacin@superbiz.org",
          "fullname": "Carlos",
          "password": "passw0rd"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list cleaning db
    Given I have the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 2  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be "200"
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
          "id": 1,
          "created": "${json-unit.ignore}",
          "modified": "${json-unit.ignore}",
          "email": "cchacin@superbiz.org",
          "fullname": "Carlos",
          "password": "passw0rd"
      },
      {
          "id": 2,
          "created": "${json-unit.ignore}",
          "modified": "${json-unit.ignore}",
          "email": "cchacin2@superbiz.org",
          "fullname": "Carlos2",
          "password": "passw0rd"
      }
    ]
    """

  # EXTERNAL SERVICE
  Scenario: Mock external API
    Given The call to external service should be:
      | method | url                | statusCode | filename      |
      | GET    | /user/71e7cb11?a=a | 200        | 71e7cb11.json |
      | POST   | /user              | 201        |               |
      | PUT    | /user/71e7cb11     | 204        |               |
      | DELETE | /user/71e7cb11     | 204        |               |
    When I make a GET call to "/test-app/external/call/user/71e7cb11" endpoint
    Then response status code should be "200"
    And response should be json:
    """
    {
      "responses": [
        {
          "status": 200
        },
        {
          "status": 201
        },
        {
          "status": 204
        },
        {
          "status": 204
        }
      ]
    }
    """

  #######
  # GET
  #######
  Scenario:
    When I make a GET call to "https://api.github.com/zen?z=1" endpoint
    Then response status code should be "200"
    And response content type should be "text/plain;charset=utf-8"

  Scenario:
    When I make a GET call to "/test-app/successful/get" endpoint
    Then response status code should be "200"
    And response content type should be "application/json"
    And response header "a" should be "a";
    And response should be json in file "/responses/successful.json"

  Scenario:
    When I make a GET call to "/test-app/successful/get/csv" endpoint
    Then response status code should be "200"
    And response content type should be "text/csv"
    And response should be file "/responses/sample.csv"

  Scenario:
    When I make a GET call to "/test-app/successful/get" endpoint with headers:
      | Authorization | OAuth qwerqweqrqwerqwer |
    Then response status code should be "200"
    And response content type should be "application/json"
    And response header "a" should be "a";
    And response should be json in file "/responses/successful.json"

  Scenario:
    When I make a GET call to "/test-app/successful/get/params" endpoint with query params:
      | param1 | passwordParam |
      | param2 | nameParam     |
    Then response status code should be "200"
    And response content type should be "application/json"
    And response should be json:
    """
    {
      "id": "${json-unit.ignore}",
      "created": "${json-unit.ignore}",
      "modified": "${json-unit.ignore}",
      "password": "passwordParam",
      "fullname": "nameParam"
    }
    """

  Scenario:
    When I make a GET call to "/test-app/successful/get" endpoint
    Then response status code should be "200"
    And response content type should be "application/json"
    And response header "a" should be "a";
    And response should be json:
    """
    {
      "id": "${json-unit.ignore}",
      "created": "${json-unit.ignore}",
      "modified": "${json-unit.ignore}",
      "password": "",
      "fullname": ""
    }
    """

  #######
  # HEAD
  #######
  Scenario:
    When I make a HEAD call to "/test-app/successful/head" endpoint
    Then response status code should be "204"
    And response should be empty

  #######
  # PUT
  #######
  Scenario:
    When I make a PUT call to "/test-app/successful/put" endpoint with post body:
    """
    {
    }
    """
    Then response status code should be "204"
    And response should be empty

  #######
  # POST
  #######
  Scenario:
    When I make a POST call to "/test-app/successful/post" endpoint with post body:
    """
    {
    }
    """
    Then response status code should be "201"
    And response should be empty

  Scenario:
    When I make a POST call to "/test-app/successful/post" endpoint with post body in file "/requests/post_request.json"
    Then response status code should be "201"
    And response should be empty

  #######
  # DELETE
  #######
  Scenario:
    When I make a DELETE call to "/test-app/successful/delete" endpoint
    Then response status code should be "204"
    And response should be empty
