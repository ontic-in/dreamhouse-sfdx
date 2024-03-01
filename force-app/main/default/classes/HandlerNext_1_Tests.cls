
@isTest
private class HandlerNext_1_Tests {

    @testSetup
    static void makeTestData() {
        // Bypass any triggers that might interfere with test data creation
        // Adjust these lines according to the actual implementation of your TriggerHandler framework
        // TriggerHandler.bypass('AccountTriggerHandler');
        // TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a test Opportunity
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            Amount = 50000,
            CloseDate = System.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert testOpportunity;

        // Create a test Case
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact'
        );
        insert testContact;

        Case testCase = new Case(
            ContactId = testContact.Id,
            Subject = 'High Priority Case',
            Status = 'New',
            Priority = 'High'
        );
        insert testCase;
    }

    @isTest
    static void testHandleWithOpportunityAndCase() {
        // Test the happy path scenario
        Test.startTest();
        HandlerNext handler = new HandlerNext();
        BotResponse response = handler.handle('Test', new String[]{}, new Map<String, String>(), '', '');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, response, 'The response should not be null.');
        System.assertEquals(2, response.messages.size(), 'The response should contain two messages.');
        System.assertNotEquals(0, response.messages[0].records.size(), 'The opportunity message should contain records.');
        System.assertNotEquals(0, response.messages[1].records.size(), 'The case message should contain records.');
    }

    @isTest
    static void testHandleWithoutOpportunityAndCase() {
        // Test the sad path scenario
        // Clean up test data to simulate a scenario without records
        delete [SELECT Id FROM Opportunity];
        delete [SELECT Id FROM Case];

        Test.startTest();
        HandlerNext handler = new HandlerNext();
        BotResponse response = handler.handle('Test', new String[]{}, new Map<String, String>(), '', '');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, response, 'The response should not be null.');
        System.assertEquals(2, response.messages.size(), 'The response should contain two messages.');
        // Since we deleted the opportunities and cases, we expect the related messages to have no records
        System.assertEquals(0, response.messages[0].records.size(), 'The opportunity message should have no records.');
        System.assertEquals(0, response.messages[1].records.size(), 'The case message should have no records.');
    }
}
