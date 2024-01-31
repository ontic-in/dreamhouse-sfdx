
@isTest
private class PropertyController_7_Tests {

    @testSetup
    static void setup() {
        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 5; i++) {
            properties.add(new Property__c(
                Name='TestProperty' + i,
                Beds__c=Decimal.valueOf(i),
                Price__c=500000 + (i * 100000)
            ));
        }
        insert properties;
    }

    @isTest
    static void testGetSimilarPropertiesByBedrooms() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assume first property has ID of interest and 0 bedrooms
        Property__c p = [SELECT Id, Beds__c FROM Property__c LIMIT 1];

        List<Property__c> results = PropertyController.getSimilarProperties(p.Id, p.Beds__c, 0, 'Bedrooms');
        
        // Assertions
        System.assertNotEquals(null, results, 'The result should not be null');
        System.assertEquals(0, results.size(), 'There should not be any properties with 0 bedrooms');
    }

    @isTest
    static void testGetSimilarPropertiesByPrice() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assume first property has ID of interest and a price of 500000
        Property__c p = [SELECT Id, Price__c FROM Property__c LIMIT 1];

        List<Property__c> results = PropertyController.getSimilarProperties(p.Id, 0, p.Price__c, 'Price');
        
        // Assertions
        System.assertNotEquals(null, results, 'The result should not be null');
        System.assertEquals(4, results.size(), 'There should be 4 properties within the price range');
    }

    @isTest
    static void testNoPropertiesWithGivenBedrooms() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assume first property has ID of interest
        Property__c p = [SELECT Id FROM Property__c LIMIT 1];

        List<Property__c> results = PropertyController.getSimilarProperties(p.Id, 10, 0, 'Bedrooms');
        
        // Assertions
        System.assert(results.isEmpty(), 'There should be no properties with 10 bedrooms');
    }

    @isTest
    static void testNoPropertiesWithinGivenPriceRange() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Assume first property has ID of interest
        Property__c p = [SELECT Id FROM Property__c LIMIT 1];

        List<Property__c> results = PropertyController.getSimilarProperties(p.Id, 0, 1000000, 'Price');
        
        // Assertions
        System.assert(results.isEmpty(), 'There should be no properties within price range of 1000000');
    }

    @isTest
    static void testInvalidPropertyId() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Id invalidPropertyId = 'a00000000000000';

        List<Property__c> results = PropertyController.getSimilarProperties(invalidPropertyId, 3, 600000, 'Bedrooms');
        
        // Assertions
        System.assert(results.isEmpty(), 'There should be no properties for an invalid property ID');
    }
}
