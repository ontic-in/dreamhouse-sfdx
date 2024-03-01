
@isTest
private class HandlerSOQL_1_Tests {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
    }

    @isTest
    static void testHandleWithValidQuery() {
        String validQuery = 'SELECT Id, Name FROM Account LIMIT 1';
        HandlerSOQL handler = new HandlerSOQL();

        Test.startTest();
        BotResponse response = handler.handle(validQuery, new String[]{}, new Map<String, String>(), '', '');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, response, 'The response should not be null.');
        // Additional assertions can be made if we know the structure of BotResponse.
    }

    @isTest
    static void testHandleWithInvalidQuery() {
        String invalidQuery = 'SELECT FROM Account'; // Missing fields in SELECT
        HandlerSOQL handler = new HandlerSOQL();

        Exception caughtException = null;
        try {
            Test.startTest();
            handler.handle(invalidQuery, new String[]{}, new Map<String, String>(), '', '');
            Test.stopTest();
        } catch (Exception e) {
            caughtException = e;
        }

        // Assertions
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to the invalid query.');
        // Verify that the exception message contains an expected phrase
        System.assert(caughtException.getMessage().contains('unexpected token'), 'The exception message should indicate an unexpected token due to an invalid query.');
    }

    @isTest
    static void testHandleWithNoResults() {
        String noResultsQuery = 'SELECT Id, Name FROM Account WHERE Name = \'Nonexistent\'';
        HandlerSOQL handler = new HandlerSOQL();

        Test.startTest();
        BotResponse response = handler.handle(noResultsQuery, new String[]{}, new Map<String, String>(), '', '');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, response, 'The response should not be null even if no records are found.');
        // Additional assertions can be made if we know the structure of BotResponse.
    }
}
