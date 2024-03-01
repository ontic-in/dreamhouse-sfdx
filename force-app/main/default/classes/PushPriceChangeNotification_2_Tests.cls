
@isTest
private class PushPriceChangeNotification_2_Tests {

    @testSetup
    static void makeTestData() {
        Property__c testProperty = new Property__c(Name = 'Test Property', Price__c = 1000000);
        insert testProperty;

        Property_Favorite__c testFavorite = new Property_Favorite__c(
            Property__c = testProperty.Id, 
            User__c = UserInfo.getUserId()
        );
        insert testFavorite;
    }
    
    @isTest
    static void testHappyPath_QueueablePushCallInitialization() {
        Test.startTest();
        List<Property__c> properties = [SELECT Id FROM Property__c];
        PushPriceChangeNotification.pushNotification(new List<Id>{ properties[0].Id });
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob], 'One job should have been enqueued');
    }

    // Exceptional Scenario: Mock Callout and Assert Execution
    @isTest
    static void testQueueableExecuteMethodCallout() {
        // Setting up the mock callout response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Using a boolean flag to capture whether an exception was thrown
        Boolean noExceptionThrown = true;
        
        try {
            Test.startTest();
            List<Property__c> properties = [SELECT Id FROM Property__c];
            PushPriceChangeNotification.pushNotification(new List<Id>{ properties[0].Id });
            Test.stopTest();
        } catch (Exception e) {
            noExceptionThrown = false;
        }
        
        // Assertions to ensure that no uncaught exceptions were thrown during the callout operation
        System.assert(noExceptionThrown, 'An exception should not have been thrown during the callout operation in the Queueable execute method.');
    }

    // Mock class implementation for HTTP callout
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            // Creating a fake HTTP response
            HttpResponse res = new HttpResponse();
            res.setBody('Mocked response');
            res.setStatusCode(200);
            return res;
        }
    }
}
