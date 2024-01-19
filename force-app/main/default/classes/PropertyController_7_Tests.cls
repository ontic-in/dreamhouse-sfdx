
@isTest
private class PropertyController_7_Tests {

    @testSetup
    static void setup() {
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 0; i < 5; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                Beds__c = i,
                Baths__c = i,
                Price__c = 100000 + (i * 100000)
            ));
        }
        insert testProperties;
    }
    
    // Happy Path - Search by 'Bedrooms'
    @isTest
    static void testGetSimilarPropertiesByBedrooms() {
        // Disable the trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Arrange
        Property__c testProperty = [SELECT Id, Beds__c FROM Property__c LIMIT 1];
        Decimal bedrooms = testProperty.Beds__c;
        
        // Act
        List<Property__c> results = PropertyController.getSimilarProperties(testProperty.Id, bedrooms, null, 'Bedrooms');
        
        // Assert
        System.assertNotEquals(null, results, 'The results should not be null');
        System.assertEquals(bedrooms, results[0].Beds__c, 'The bedrooms should match the search criteria');
    }
    
    // Happy Path - Search by Price Range
    @isTest
    static void testGetSimilarPropertiesByPriceRange() {
        // Disable the trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Arrange
        Property__c testProperty = [SELECT Id, Price__c FROM Property__c LIMIT 1];
        Decimal price = testProperty.Price__c;
        
        // Act
        List<Property__c> results = PropertyController.getSimilarProperties(testProperty.Id, null, price, 'PriceRange');
        
        // Assert
        System.assertNotEquals(null, results, 'The results should not be null');
        System.assert(results[0].Price__c > price - 100000 && results[0].Price__c < price + 100000, 'The price should be within the specified range');
    }

    // Sad Path - No Properties Found
    @isTest
    static void testGetSimilarPropertiesNoResults() {
        // Disable the trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Arrange
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        Decimal bedrooms = 999; // Unlikely to match any test data
        
        // Act
        List<Property__c> results = PropertyController.getSimilarProperties(testProperty.Id, bedrooms, null, 'Bedrooms');
        
        // Assert
        System.assertEquals(0, results.size(), 'There should be no results');
    }
    
    // Exceptional Scenario - Invalid Search Criteria
    @isTest
    static void testGetSimilarPropertiesInvalidCriteria() {
        // Disable the trigger handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Arrange
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        Decimal bedrooms = 2; // Arbitrary value
        
        // Act
        List<Property__c> results = PropertyController.getSimilarProperties(testProperty.Id, bedrooms, null, 'InvalidCriteria');
        
        // Assert
        System.assertEquals(0, results.size(), 'There should be no results for an invalid search criteria');
    }
}
