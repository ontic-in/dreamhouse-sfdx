
@isTest
private class HandlerTopOpportunities_1_Tests {
    // Use @testSetup to create test data for opportunities
    @testSetup
    static void setup() {
        // Bypassing triggers as required by project specifics
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test opportunities
        List<Opportunity> testOpportunities = new List<Opportunity>();
        for (Integer i = 1; i <= 5; i++) {
            testOpportunities.add(new Opportunity(
                Name = 'Test Opportunity ' + i,
                CloseDate = System.today().addDays(i),
                StageName = 'Prospecting',
                Amount = (10000 + i),
                Probability = (i * 10),
                IsClosed = false
            ));
        }
        insert testOpportunities;
    }

    // Happy Path Scenario Test
    @isTest
    static void testHandleHappyPath() {
        Test.startTest();
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String utterance = 'top opportunities';
        String[] params = new String[]{ '3' }; // Request for top 3 opportunities
        Map<String, String> session = new Map<String, String>();
        String fileName = null;
        String fileContent = null;

        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);
        Test.stopTest();

        // Assuming that BotResponse has a public 'message' property containing a 'records' list
        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertEquals(3, response.message.records.size(), 'Should return 3 records.');
    }

    // Sad Path Scenario Test: Invalid integer parameter in params array
    @isTest
    static void testHandleSadPath() {
        Test.startTest();
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String utterance = 'top opportunities';
        String[] params = new String[]{ 'invalid' };
        Map<String, String> session = new Map<String, String>();
        String fileName = null;
        String fileContent = null;

        Exception caughtException;
        try {
            handler.handle(utterance, params, session, fileName, fileContent);
        } catch(Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An exception should have been thrown due to invalid parameter.');
        System.assert(caughtException instanceof System.TypeException, 'The thrown exception should be a TypeException.');
    }

    // Exceptional Scenario Test: No opportunities available
    @isTest
    static void testHandleNoOpportunities() {
        // Deleting all opportunities to simulate no available opportunities
        delete [SELECT Id FROM Opportunity];

        Test.startTest();
        HandlerTopOpportunities handler = new HandlerTopOpportunities();
        String utterance = 'top opportunities';
        String[] params = new String[]{ '3' };
        Map<String, String> session = new Map<String, String>();
        String fileName = null;
        String fileContent = null;

        BotResponse response = handler.handle(utterance, params, session, fileName, fileContent);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null.');
        // Assuming that BotResponse has a public 'message' property containing a 'records' list
        System.assertEquals(0, response.message.records.size(), 'Should return 0 records.');
    }
}
