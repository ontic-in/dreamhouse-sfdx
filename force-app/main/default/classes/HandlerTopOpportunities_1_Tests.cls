
@isTest
private class HandlerTopOpportunities_1_Tests {

    // Test for the Happy Path scenario
    @isTest
    static void shouldHandleValidInput() {
        // Arrange
        createOpportunityTestData(5); // Create 5 opportunities for testing
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String[] params = new String[]{ '3' }; // We want the top 3 opportunities

        // Act
        BotResponse response = handler.handle('top opportunities', params, new Map<String, String>(), null, null);

        // Assert
        System.assertNotEquals(null, response, 'The bot response should not be null.');
    }

    // Test when params array doesn't contain any data
    @isTest
    static void shouldHandleEmptyParams() {
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String[] params = new String[]{};
        Boolean didThrowException = false;

        try {
            handler.handle('top opportunities', params, new Map<String, String>(), null, null);
        } catch (System.ListException e) {
            didThrowException = true;
        }

        // Assert
        System.assert(didThrowException, 'An exception should have been thrown due to empty params.');
    }

    // Test when there are no open opportunities available
    @isTest
    static void shouldHandleNoOpportunities() {
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String[] params = new String[]{ '3' };

        BotResponse response = handler.handle('top opportunities', params, new Map<String, String>(), null, null);
        System.assertNotEquals(null, response, 'The bot response should not be null even with no opportunities.');
    }

    // Test for handling invalid number format in params
    @isTest
    static void shouldHandleInvalidNumberFormat() {
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String[] params = new String[]{ 'invalid_number' };
        Boolean didThrowException = false;

        try {
            handler.handle('top opportunities', params, new Map<String, String>(), null, null);
        } catch (System.TypeException e) {
            didThrowException = true;
        }

        // Assert
        System.assert(didThrowException, 'A TypeException should have been thrown due to invalid number format in params.');
    }

    // Helper method to create Opportunity test data
    private static void createOpportunityTestData(Integer count) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < count; i++) {
            opportunities.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                CloseDate = System.today().addDays(10),
                StageName = 'Prospecting',
                Amount = 10000 + (i * 1000),
                IsClosed = false
            ));
        }
        insert opportunities;
    }
}
