Feature: Database assertions
  Scenario: Database check exists
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
      | 5  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd |
    Then I should have the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
      | 5  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd |
