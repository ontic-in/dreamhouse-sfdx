
@isTest
private class PropertyController_4_Tests {

    @testSetup
    static void makeTestData() {
        // Create test data for available properties
        List<Property__c> testProperties = new List<Property__c>();
        Date today = Date.today();
        Date ninetyDaysAgo = today.addDays(-90);

        // Property with a listed date and no agreement date
        testProperties.add(new Property__c(
            Name = 'Test Property 1',
            Date_Listed__c = today
        ));

        // Property with a listed date and agreement date within the last 90 days
        testProperties.add(new Property__c(
            Name = 'Test Property 2',
            Date_Listed__c = today,
            Date_Agreement__c = ninetyDaysAgo
        ));

        // Save test data
        insert testProperties;
    }

    // Test method for happy path scenario
    @isTest
    static void testGetAvailableProperties_HappyPath() {
        Test.startTest();
        Property__c[] properties = PropertyController.getAvailableProperties();
        Test.stopTest();

        // Assertions
        System.assertEquals(2, properties.size(), 'Should return 2 available properties.');
        System.assertNotEquals(null, properties[0].Date_Listed__c, 'Date_Listed__c should not be null.');
    }

    // Test method for sad path scenario
    @isTest
    static void testGetAvailableProperties_SadPath() {
        // Create test property that will not meet the criteria
        Property__c unqualifiedProperty = new Property__c(
            Name = 'Unqualified Property',
            Date_Listed__c = Date.today(),
            Date_Agreement__c = Date.today().addDays(-91)
        );
        insert unqualifiedProperty;

        Test.startTest();
        Property__c[] properties = PropertyController.getAvailableProperties();
        Test.stopTest();

        // Assertions
        System.assertEquals(false, properties.isEmpty(), 'Should not return empty list.');
        System.assertNotEquals(1, properties.size(), 'Should not include unqualified properties.');
    }
}
