
@isTest
public with sharing class LIFXController_2_Tests {
    @testSetup static void testSetup() {
        Dreamhouse_Settings__c settings = new Dreamhouse_Settings__c();
        settings.Name = 'Org Defaults';
        settings.LIFX_TOKEN__C = 'dummy_token';
        settings.LIFX_URL__C = 'http://dummy.light.api';
        insert settings;

        // Disable triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest static void testSetPowerOnValidLightId() {
        String lightId = 'valid_light_id';
        Boolean isOn = true;
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock());

        String response = LIFXController.setPower(lightId, isOn);

        System.assert(response.contains('"power": "on"'));
        System.assert(!response.contains('error'));
    }

    @isTest static void testSetPowerOffValidLightId() {
        String lightId = 'valid_light_id';
        Boolean isOn = false;
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock());

        String response = LIFXController.setPower(lightId, isOn);

        System.assert(response.contains('"power": "off"'));
        System.assert(!response.contains('error'));
    }

    @isTest static void testSetPowerOnInvalidLightId() {
        String lightId = 'invalid_light_id';
        Boolean isOn = true;
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock());

        String response = LIFXController.setPower(lightId, isOn);

        System.assert(response.contains('error'));
    }

    @isTest static void testSetPowerOffInvalidLightId() {
        String lightId = 'invalid_light_id';
        Boolean isOn = false;
        Test.setMock(HttpCalloutMock.class, new LIFXControllerMock());

        String response = LIFXController.setPower(lightId, isOn);

        System.assert(response.contains('error'));
    }
}
