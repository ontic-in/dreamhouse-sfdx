
@isTest
private class HandlerTopOpportunities_1_Tests {

    @testSetup
    static void makeData() {
        // Create open opportunities to test the handle method
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            oppsToInsert.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                CloseDate = System.today().addDays(10),
                StageName = 'Prospecting', // Assuming 'Prospecting' is a stage that implies the opp is open
                Amount = 10000 * (i + 1),
                Probability = 10 * (i + 1)
            ));
        }
        insert oppsToInsert;
    }

    private static void bypassTriggers() {
        // Replace these comments with the actual logic for your trigger framework, if necessary.
        // Example:
        // TriggerHandlers.bypass('AccountTriggerHandler');
        // TriggerHandlers.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testHandleWithValidParams() {
        bypassTriggers();
        
        Map<String, String> session = new Map<String, String>();
        String[] params = new String[]{'2'};
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        
        Test.startTest();
        BotResponse response = handler.handle('get top opportunities', params, session, '', '');
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null.');
    }
    
    @isTest
    static void testHandleWithEmptyParams() {
        bypassTriggers();
        
        Map<String, String> session = new Map<String, String>();
        String[] params = new String[]{};
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        Exception caughtException;
        
        Test.startTest();
        try {
            handler.handle('get top opportunities', params, session, '', '');
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An exception should be thrown when params are empty.');
        System.assertEquals(true, caughtException instanceof ListException, 'The exception should be an instance of ListException.');
    }
    
    @isTest
    static void testHandleWithInvalidParams() {
        bypassTriggers();
        
        Map<String, String> session = new Map<String, String>();
        String[] params = new String[]{'invalid'};
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        Exception caughtException;
        
        Test.startTest();
        try {
            handler.handle('get top opportunities', params, session, '', '');
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An exception should be thrown when params[0] is not an integer.');
        System.assertEquals(true, caughtException instanceof TypeException, 'The exception should be an instance of TypeException.');
    }
}
