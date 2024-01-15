
@isTest
private class PropertyController_7_Tests {

    static final String BY_BEDROOMS = 'Bedrooms';
    static final String BY_PRICE = 'Price';

    @testSetup
    static void setup() {
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 0; i < 5; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                Beds__c = Decimal.valueOf(i % 3 + 2), // Resulting in 2, 3, or 4 bedrooms
                Price__c = Decimal.valueOf(100000 + 100000 * i) // Resulting in 100000, 200000, ...
            ));
        }
        insert testProperties;
    }

    private static void disableTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testGetSimilarPropertiesByBedrooms() {
        disableTriggers();
        Property__c testProperty = [SELECT Id, Beds__c FROM Property__c WHERE Beds__c > 0 LIMIT 1];
        Decimal bedrooms = testProperty.Beds__c;

        Test.startTest();
        List<Property__c> propertiesByBedrooms = PropertyController.getSimilarProperties(testProperty.Id, bedrooms, null, BY_BEDROOMS);
        Test.stopTest();

        System.assertNotEquals(null, propertiesByBedrooms, 'The result should not be null.');
        System.assertTrue(propertiesByBedrooms.size() > 0, 'Should find properties with matching bedrooms.');
    }

    @isTest
    static void testGetSimilarPropertiesByPriceRange() {
        disableTriggers();
        Property__c testProperty = [SELECT Id, Price__c FROM Property__c WHERE Price__c > 0 LIMIT 1];
        Decimal price = testProperty.Price__c;

        Test.startTest();
        List<Property__c> propertiesByPrice = PropertyController.getSimilarProperties(testProperty.Id, null, price, BY_PRICE);
        Test.stopTest();

        System.assertNotEquals(null, propertiesByPrice, 'The result should not be null.');
        System.assertTrue(propertiesByPrice.size() > 0, 'Should find properties within the price range.');
    }

    @isTest
    static void testGetSimilarPropertiesWithInvalidPropertyId() {
        disableTriggers();
        Id invalidPropertyId = generateInvalidPropertyId();

        Test.startTest();
        List<Property__c> propertiesByInvalidId = PropertyController.getSimilarProperties(invalidPropertyId, null, null, BY_BEDROOMS);
        Test.stopTest();

        System.assertNotEquals(null, propertiesByInvalidId, 'The result should not be null.');
        System.assertEquals(0, propertiesByInvalidId.size(), 'No properties should be returned with invalid ID.');
    }

    private static Id generateInvalidPropertyId() {
        String suffix = '000000000000AAA'; // Invalid suffix for real Ids
        return Id.valueOf('a0N' + suffix);
    }
}
