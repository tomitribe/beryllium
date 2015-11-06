Feature: Mock External Services

  # EXTERNAL SERVICE
  Scenario: Mock external API
    Given The call to external service should be:
      | method | url                | statusCode | filename      |
      | GET    | /user/71e7cb11?a=1 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=2 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=3 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=4 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=5 | 200        | 71e7cb11.json |
      | POST   | /user?b=b          | 201        |               |
      | PUT    | /user/71e7cb11     | 204        |               |
      | DELETE | /user/71e7cb11     | 204        |               |
    When I make a GET call to "/test-app/external/call/user/71e7cb11" endpoint
    Then response status code should be 200
    And response json path list "$.responses" should be of length 8
    And response should be json:
    """
    {
      "responses":[
        {
          "status":201
        },
        {
          "status":204
        },
        {
          "status":204
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        }
      ]
    }
    """

  # EXTERNAL SERVICE PROXY
  Scenario: Mock external API as Proxy
    Given The call to external service should be:
      | method | url                | statusCode | filename      |
      | GET    | /user/71e7cb11?a=a | 200        | 71e7cb11.json |
    When I make a GET call to "/test-app/external/proxy/user/71e7cb11" endpoint
    Then response status code should be 200
    And response should be json:
    """
    {
      "user": "sample"
    }
    """
