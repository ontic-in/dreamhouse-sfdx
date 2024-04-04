
@isTest
private class PropertyController_6_Tests {

    private static void createTestData() {
        // Create test properties with different prices to ensure some are within the $100,000 range
        List<Property__c> testProperties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            testProperties.add(new Property__c(
                Name = 'Test Property ' + i,
                Price__c = 500000 + (i * 50000) // This creates a 50,000 increment in price for each property
            ));
        }
        insert testProperties;
    }
    
    @isTest
    static void testSadPathWithNullPropertyId() {
        try {
            List<Property__c> result = PropertyController.getComparableProperties(null);
            System.assert(false, 'Method did not throw an exception for null Id');
        } catch (Exception e) {
            System.assert(true, 'Exception should be thrown for null Id');
        }
    }
    
    @isTest
    static void testExceptionalScenarioWithNonexistentPropertyId() {
        Id fakeId = Schema.SObjectType.Property__c.getKeyPrefix() + '000000000000AAA'; // Assume fake ID
        
        // No need to create test data as we're testing a non-existent property
        List<Property__c> result;
        try {
            result = PropertyController.getComparableProperties(fakeId);
            System.assert(false, 'Method did not throw an exception for non-existent Id');
        } catch (QueryException e) {
            System.assert(true, 'QueryException should be thrown for non-existent Id');
        }
    }
}
