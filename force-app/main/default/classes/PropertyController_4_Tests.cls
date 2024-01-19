
@isTest
private class PropertyController_4_Tests {

    @testSetup
    static void setup() {
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        Date today = Date.today();
        Date ninetyDaysAgo = today.addDays(-90);
        
        // Create a property that should be available
        testProperties.add(new Property__c(
            Date_Listed__c = today,
            Date_Agreement__c = null
        ));
        
        // Create a property that is outside the availability window
        testProperties.add(new Property__c(
            Date_Listed__c = today.addDays(-100),
            Date_Agreement__c = today.addDays(-95)
        ));
        
        // Create a property that is exactly on the 90 days mark
        testProperties.add(new Property__c(
            Date_Listed__c = ninetyDaysAgo,
            Date_Agreement__c = today
        ));
        
        // Insert the test data
        insert testProperties;
        
        // Bypass triggers during test
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testGetAvailableProperties_HappyPath() {
        // Perform the test
        Test.startTest();
        Property__c[] availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(2, availableProperties.size(), 'There should be 2 available properties.');
    }

    @isTest
    static void testGetAvailableProperties_NoPropertiesAvailable() {
        // Update test data to make properties unavailable
        List<Property__c> allProperties = [SELECT Id, Date_Agreement__c FROM Property__c];
        for (Property__c prop : allProperties) {
            prop.Date_Agreement__c = Date.today().addDays(-95); // Set all agreements to be outside the 90 days window
        }
        update allProperties;
        
        // Perform the test
        Test.startTest();
        Property__c[] availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(0, availableProperties.size(), 'There should be no available properties.');
    }
    
    @isTest
    static void testGetAvailableProperties_MixedAvailability() {
        // No additional setup required as test setup already creates a mixed scenario
        
        // Perform the test
        Test.startTest();
        Property__c[] availableProperties = PropertyController.getAvailableProperties();
        Test.stopTest();
        
        // Verify results
        System.assertEquals(2, availableProperties.size(), 'There should be 2 available properties based on mixed test data.');
    }
}
