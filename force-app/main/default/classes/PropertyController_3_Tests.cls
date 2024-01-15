
@isTest
private class PropertyController_3_Tests {

    @testSetup
    static void makeData() {
        // Prepare test data for Property__c object
        // Assuming 'Property__c' is a valid SObject type in the Salesforce org and the fields are correctly set up.
        // You need to replace 'Field__c' with actual API names of the fields in 'Property__c' object.
        Property__c testProperty = new Property__c(/* Field__c = 'Value', ... */);
        
        // Insert the test Property record
        insert testProperty;
    }
    
    @isTest
    static void testFindByIdHappyPath() {
        // Bypass triggers to avoid side effects
        // Assuming 'TriggerHandler' is a valid utility class available in the Salesforce org.
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Retrieve the test data
        // Assuming 'Property__c' is a valid SObject type in the Salesforce org.
        Property__c testProperty = [SELECT Id FROM Property__c LIMIT 1];
        
        // Test the findById method with a valid Id
        Test.startTest();
        Property__c result = PropertyController.findById(testProperty.Id);
        Test.stopTest();
        
        // Assertions to confirm that the method returned the correct record
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assertEquals(testProperty.Id, result.Id, 'The Id of the returned property should match the test property Id.');
    }
    
    @isTest
    static void testFindByIdSadPath() {
        // Bypass triggers to avoid side effects
        // Assuming 'TriggerHandler' is a valid utility class available in the Salesforce org.
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create a dummy Id that does not exist in test context
        // Assuming 'Property__c' is a valid SObject type in the Salesforce org.
        Id nonExistentId = TestUtil.getNonExistentId();
        
        // Test the findById method with a non-existent Id
        Test.startTest();
        Property__c result = PropertyController.findById(nonExistentId);
        Test.stopTest();
        
        // Assertions to confirm that the method returned null for non-existent Id
        System.assertEquals(null, result, 'The result should be null for a non-existent property Id.');
    }
    
    // Utility inner class to handle creating non-existent Ids for test purposes
    private class TestUtil {
        static Id getNonExistentId() {
            // Generate a dummy Id that would be considered invalid
            // Assuming 'Property__c' has a key prefix in the Salesforce org.
            String keyPrefix = 'a0N'; // Replace with actual key prefix for 'Property__c'
            String suffix = '000000000XXXXXX'; // Replace with non-existent record Id suffix
            return Id.valueOf(keyPrefix + suffix);
        }
    }
}
