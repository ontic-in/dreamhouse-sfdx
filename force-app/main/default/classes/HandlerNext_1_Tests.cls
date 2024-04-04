
@isTest
private class HandlerNext_1_Tests {
    
    private static void createTestOpportunity() {
        // Insert test opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            CloseDate = Date.today().addDays(10),
            StageName = 'Prospecting', // Ensure this stage name aligns with an open opportunity stage
            Amount = 1000,
            Probability = 75
        );
        insert testOpportunity;
    }
    
    private static void createTestContactAndCase() {
        // Create and insert a contact to associate with the case
        Contact testContact = new Contact(
            LastName = 'Test Contact'
            // Set other fields if necessary
        );
        insert testContact;

        // Insert test case
        Case testCase = new Case(
            Subject = 'High Priority Case',
            Status = 'New',
            Priority = 'High',
            ContactId = testContact.Id
        );
        insert testCase;
    }

    @isTest
    static void testOpportunityAndCaseDataExists() {
        createTestOpportunity();
        createTestContactAndCase();
        Test.startTest();
        HandlerNext handler = new HandlerNext();
        BotResponse result = handler.handle(null, null, null, null, null);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(2, result.messages.size(), 'There should be two messages, one for opportunities and one for cases');
    }

    @isTest
    static void testNoOpportunityData() {
        createTestContactAndCase(); // Only create test data for cases
        Test.startTest();
        HandlerNext handler = new HandlerNext();
        BotResponse result = handler.handle(null, null, null, null, null);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(2, result.messages.size(), 'There should be two messages, one for cases when no opportunities exist');
    }

    @isTest
    static void testNoCaseData() {
        createTestOpportunity(); // Only create test data for opportunities
        Test.startTest();
        HandlerNext handler = new HandlerNext();
        BotResponse result = handler.handle(null, null, null, null, null);
        Test.stopTest();

        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(2, result.messages.size(), 'There should be two messages, one for opportunities even when no cases exist');
    }
}
