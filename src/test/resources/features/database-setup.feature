Feature: Database Setup
  # DATABASE SQL SCRIPT
  Scenario: Retrieve users list preparing db with script
    Given I have the following sql script "sample-data.sql"
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response json path list "$.*" should be of length 2
    And response json path list "$.*" should be at least of length 1
    And response json path list "$.*" should be at least of length 2
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":101,
        "modified":"${json-unit.ignore}",
        "password":"passWorD"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":102,
        "modified":"${json-unit.ignore}",
        "password":"passWorD2"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password  |
      | 1  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin@superbiz.org  | Carlos   | passw0rd  |
      | 2  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd2 |
      | 3  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd3 |
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":1,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":2,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd2"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin3@superbiz.org",
        "fullname":"Carlos3",
        "id":3,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd3"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list cleaning db
    Given I have the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
    When I make a GET call to "/test-app/users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":1,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":2,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd2"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin3@superbiz.org",
        "fullname":"Carlos3",
        "id":3,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd3"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":4,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      }
    ]
    """
    And response json path list "$..fullname" should be:
      | Carlos  |
      | Carlos2 |
      | Carlos3 |
      | Carlos2 |
    And response json path element "$[0].id" should be "1"
