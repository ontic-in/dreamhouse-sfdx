
@isTest
public with sharing class LIFXController_3_Tests {

    @isTest
    static void testSetBrightnessHappyPath() {
        // Setup
        String lightId = '1';
        Decimal brightness = 50;
        String expectedResponse = '{"id": "1", "brightness": 0.5}';

        Dreamhouse_Settings__c setting = new Dreamhouse_Settings__c();
        setting.LIFX_TOKEN__C = 'Token';
        setting.LIFX_URL__C = 'URL';
        insert setting;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock(expectedResponse, 200));

        // Execute
        String actualResponse = LIFXController.setBrightness(lightId, brightness);
        Test.stopTest();

        // Verify
        System.assertEquals(expectedResponse, actualResponse, 'Response does not match the expected response');
    }

    @isTest
    static void testSetBrightnessSadPath() {
        // Setup
        String lightId = '1';
        Decimal brightness = 50;
        String expectedErrorResponse = '{"error": "Unable to reach LIFX endpoint"}';

        Dreamhouse_Settings__c setting = new Dreamhouse_Settings__c();
        setting.LIFX_TOKEN__C = 'Token';
        setting.LIFX_URL__C = 'URL';
        insert setting;

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock(expectedErrorResponse, 400));

        // Execute
        String actualErrorResponse = LIFXController.setBrightness(lightId, brightness);
        Test.stopTest();

        // Verify
        System.assertEquals(expectedErrorResponse, actualErrorResponse, 'Error response does not match the expected error response');
    }

    public class LIFXControllerMock implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;

        public LIFXControllerMock(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }

        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.responseBody);
            res.setStatusCode(this.statusCode);
            return res;
        }
    }
}
