
@isTest
public class PropertyController_6_Tests {
    @testSetup
    static void setup() {
        // Disable triggers
        TriggerHandler.bypass('PropertyTriggerHandler');

        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            properties.add(new Property__c(
                Price__c = (i + 1) * 100000,
                Name = 'Test Property ' + i
            ));
        }
        insert properties;
    }

    @isTest
    static void testHappyPath() {
        // Query for a property
        Property__c property = [SELECT Id FROM Property__c LIMIT 1];

        // Test getComparableProperties method
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(property.Id);

        // Assert that comparable properties are returned
        System.assert(comparableProperties.size() > 0, 'No comparable properties found');
        System.assertNotEquals(property.Id, comparableProperties[0].Id, 'Returned property is the same as input property');
    }

    @isTest
    static void testSadPath() {
        // Query for a property
        Property__c property = [SELECT Id, Price__c FROM Property__c ORDER BY Price__c DESC LIMIT 1];

        // Test getComparableProperties method
        List<Property__c> comparableProperties = PropertyController.getComparableProperties(property.Id);

        // Assert that no comparable properties are returned
        System.assertEquals(0, comparableProperties.size(), 'Comparable properties found');
    }

    @isTest
    static void testExceptionalScenario() {
        // Test getComparableProperties method with invalid propertyId
        try {
            List<Property__c> comparableProperties = PropertyController.getComparableProperties('invalidId');
            System.assert(false, 'Exception expected but not thrown');
        } catch(Exception e) {
            System.assert(e instanceof System.StringException, 'Expected System.StringException but got ' + e);
        }
    }
}
