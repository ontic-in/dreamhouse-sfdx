
@isTest
public class LIFXController_1_Tests {

    @testSetup 
    static void setupTestData() {
        // Create a Dreamhouse_Settings__c record to be used in tests
        Dreamhouse_Settings__c testSettings = new Dreamhouse_Settings__c(
            Name = 'Test',
            LIFX_TOKEN__C = 'TestToken',
            LIFX_URL__C = 'http://test.url'
        );
        insert testSettings;
    }
    
    @isTest 
    static void testGetLightsSuccess() {
        // Assuming CalloutMock returns a successful response
        Test.setMock(HttpCalloutMock.class, new LIFXHttpCalloutMock(200, '{"status": "success"}'));

        Test.startTest();
        String result = LIFXController.getLights();
        Test.stopTest();
        
        // Verify that the response is a success
        System.assert(result.contains('\"status\": \"success\"'));
    }

    @isTest 
    static void testGetLightsError() {
        // Assuming CalloutMock returns an error response
        Test.setMock(HttpCalloutMock.class, new LIFXHttpCalloutMock(500, '{"error": "Test error"}'));

        Test.startTest();
        String result = LIFXController.getLights();
        Test.stopTest();
        
        // Verify that an error message is returned
        System.assert(result.contains('\"error\":'));
    }
}

// Mock Class for API responses
@isTest
global class LIFXHttpCalloutMock implements HttpCalloutMock {
    Integer statusCode;
    String responseBody;

    public LIFXHttpCalloutMock(Integer statusCode, String responseBody) {
        this.statusCode = statusCode;
        this.responseBody = responseBody;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setBody(responseBody);
        res.setStatusCode(statusCode);
        return res;
    }
}
