
@isTest
private class PushPriceChangeNotification_1_Tests {
    
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private final Integer statusCode;
        private final String body;
        
        MockHttpResponseGenerator(Integer statusCode, String body) {
            this.statusCode = statusCode;
            this.body = body;
        }
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setBody(body);
            res.setStatusCode(statusCode);
            return res;
        }
    }
    
    private static void prepareMockSetting(String pushServerUrl) {
        Dreamhouse_Settings__c setting = new Dreamhouse_Settings__c();
        setting.Push_Server_URL__c = pushServerUrl;
        // Assuming that the trigger or automated process is disabled or bypassed here
        insert setting;
    }
    
    private static Id createTestProperty() {
        Property__c property = new Property__c(Name = 'Test Property', Price__c = 1000000);
        insert property;
        return property.Id;
    }
    
    private static void createTestFavorite(Id propertyId, String userId) {
        Property_Favorite__c favorite = new Property_Favorite__c(Property__c = propertyId, User__c = userId);
        insert favorite;
    }

    @isTest
    static void testPushNotificationWithValidData() {
        prepareMockSetting('http://mockserver.com');
        Id propertyId = createTestProperty();
        createTestFavorite(propertyId, UserInfo.getUserId());
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"success":true}'));

        Test.startTest();
        PushPriceChangeNotification.pushNotification(new List<Id>{ propertyId });
        Test.stopTest();
        
        // Assert that an HTTP callout was made, implying the queueable job was enqueued
        System.assertEquals(1, Limits.getCallouts(), 'Expected one HTTP callout to be made');
    }

    @isTest
    static void testPushNotificationWithoutFavorites() {
        prepareMockSetting('http://mockserver.com');
        Id propertyId = createTestProperty();
        // No favorites are created for this property

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"success":true}'));

        Test.startTest();
        PushPriceChangeNotification.pushNotification(new List<Id>{ propertyId });
        Test.stopTest();
        
        // Assert that no HTTP callout was made since there are no favorites
        System.assertEquals(0, Limits.getCallouts(), 'Expected no HTTP callouts to be made');
    }

    @isTest
    static void testPushNotificationWithInvalidSettings() {
        prepareMockSetting(null); // Invalid push server URL
        Id propertyId = createTestProperty();
        createTestFavorite(propertyId, UserInfo.getUserId());

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(200, '{"success":true}'));

        Test.startTest();
        PushPriceChangeNotification.pushNotification(new List<Id>{ propertyId });
        Test.stopTest();
        
        // Assert that no HTTP callout was made due to invalid setting
        System.assertEquals(0, Limits.getCallouts(), 'Expected no HTTP callouts to be made due to invalid settings');
    }
}
