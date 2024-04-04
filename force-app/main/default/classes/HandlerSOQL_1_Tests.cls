
@isTest
private class HandlerSOQL_1_Tests {
    // Helper method to bypass triggers if required (implementation depends on the org's trigger management solution)
    private static void bypassTriggers() {
        // Example: TriggerHandler.bypass('AccountTrigger');
    }

    @isTest
    static void testHandle_ValidQuery_WithResults() {
        // Arrange
        bypassTriggers();
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        String soqlQuery = 'SELECT Id, Name FROM Account';

        // Act
        HandlerSOQL handler = new HandlerSOQL();
        BotResponse response = handler.handle(soqlQuery, new String[]{}, new Map<String, String>(), null, null);

        // Assert
        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertNotEquals(null, response.getMessage(), 'The message in the response should not be null.');
        System.assertNotEquals(null, response.getMessage().records, 'The records in the message should not be null.');
        System.assertNotEquals(0, response.getMessage().records.size(), 'There should be at least one record.');
    }

    @isTest
    static void testHandle_ValidQuery_NoResults() {
        // Arrange
        bypassTriggers();
        String soqlQuery = 'SELECT Id, Name FROM Account WHERE Name = \'Nonexistent Account\'';

        // Act
        HandlerSOQL handler = new HandlerSOQL();
        BotResponse response = handler.handle(soqlQuery, new String[]{}, new Map<String, String>(), null, null);

        // Assert
        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertNotEquals(null, response.getMessage(), 'The message in the response should not be null.');
        System.assertNotEquals(null, response.getMessage().records, 'The records in the message should not be null.');
        System.assertEquals(0, response.getMessage().records.size(), 'Records list should be empty.');
    }

    @isTest
    static void testHandle_InvalidQuery() {
        // Arrange
        bypassTriggers();
        String soqlQuery = 'SELECT FROM Account'; // Invalid SOQL query

        // Act & Assert
        Exception caughtException = null;
        try {
            HandlerSOQL handler = new HandlerSOQL();
            handler.handle(soqlQuery, new String[]{}, new Map<String, String>(), null, null);
        } catch (Exception e) {
            caughtException = e;
        }
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown for the invalid query.');
    }

    @isTest
    static void testHandle_NullOrEmptyQuery() {
        // Arrange
        bypassTriggers();
        String soqlQuery = ''; // Empty SOQL query

        // Act & Assert
        Exception caughtException = null;
        try {
            HandlerSOQL handler = new HandlerSOQL();
            handler.handle(soqlQuery, new String[]{}, new Map<String, String>(), null, null);
        } catch (Exception e) {
            caughtException = e;
        }
        System.assertNotEquals(null, caughtException, 'An exception should have been thrown for the null or empty query.');
    }
}
