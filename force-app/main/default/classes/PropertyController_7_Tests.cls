
@isTest
public class PropertyController_7_Tests {
    @testSetup
    static void setupTestData() {
        List<Property__c> properties = new List<Property__c>();
        for(Integer i=0; i<10; i++) {
            properties.add(new Property__c(Name='Property '+i, Beds__c=i, Price__c=i*100000));
        }
        insert properties;
    }

    @isTest 
    static void testGetSimilarPropertiesByBedroom() {
        Test.startTest();
        // Bypassing triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        // Getting test data
        Property__c testProperty = [SELECT Id, Beds__c FROM Property__c WHERE Beds__c = 5 LIMIT 1];
        List<Property__c> result = PropertyController.getSimilarProperties(testProperty.Id, testProperty.Beds__c, testProperty.Price__c,'Bedrooms');
        Test.stopTest();

        // Assertions
        System.assertEquals(1, result.size());
        System.assertEquals(testProperty.Beds__c, result[0].Beds__c);

    }

    @isTest 
    static void testGetSimilarPropertiesByPrice() {
        Test.startTest();
        // Bypassing triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        // Getting test data
        Property__c testProperty = [SELECT Id, Beds__c, Price__c FROM Property__c WHERE Beds__c = 5 LIMIT 1];
        List<Property__c> result = PropertyController.getSimilarProperties(testProperty.Id, testProperty.Beds__c, testProperty.Price__c,'Price');
        Test.stopTest();

        // Assertions
        System.assertEquals(1, result.size());
        System.assert(result[0].Price__c >= testProperty.Price__c - 100000);
        System.assert(result[0].Price__c <= testProperty.Price__c + 100000);
    }
}
