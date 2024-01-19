
@isTest
public class LIFXController_4_Tests {
    @testSetup
    static void setup() {
        // Create test settings data
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c(
            LIFX_TOKEN__C = 'test_token',
            LIFX_URL__C = 'https://api.test.com'
        );
        insert settings;
    }

    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"result": "success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testSetStateHappyPath() {
        // Bypass all triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
            String result = LIFXController.setState('test_lightId', '{"brightness": 0.5}');
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'State setting should return a non-null result.');
        System.assert(result.contains('success'), 'State setting should be successful.');
    }

    // ... rest of the test methods ...
}
