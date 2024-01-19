
@isTest
private class PropertyController_5_Tests {

    @testSetup
    static void setup() {
        // Bypass triggers as per the project-specific framework
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test properties
        List<Property__c> testProperties = new List<Property__c>();
        testProperties.add(new Property__c(Predicted_Days_On_Market__c = 31));
        testProperties.add(new Property__c(Predicted_Days_On_Market__c = 15));
        testProperties.add(new Property__c(Predicted_Days_On_Market__c = 45));
        insert testProperties;
    }

    @isTest
    static void testAtRiskProperties_HappyPath() {
        Test.startTest();
        
        Property__c[] properties = PropertyController.getAtRiskProperties();
        
        Test.stopTest();
        
        System.assertEquals(2, properties.size(), 'There should be 2 at-risk properties');
        for (Property__c property : properties) {
            System.assert(property.Predicted_Days_On_Market__c > 30, 'Property should be at risk');
        }
    }

    @isTest
    static void testAtRiskProperties_SadPath() {
        // Modify existing properties to not be at risk
        List<Property__c> propertiesToUpdate = [SELECT Id, Predicted_Days_On_Market__c FROM Property__c];
        for (Property__c prop : propertiesToUpdate) {
            prop.Predicted_Days_On_Market__c = 15; // Not at risk
        }
        update propertiesToUpdate;
        
        Test.startTest();
        
        Property__c[] properties = PropertyController.getAtRiskProperties();
        
        Test.stopTest();
        
        System.assert(properties.isEmpty(), 'There should be no at-risk properties');
    }

    @isTest
    static void testAtRiskProperties_NoData() {
        // Delete all properties to simulate no data in the system
        delete [SELECT Id FROM Property__c];
        
        Test.startTest();
        
        Property__c[] properties = PropertyController.getAtRiskProperties();
        
        Test.stopTest();
        
        System.assert(properties.isEmpty(), 'There should be no properties when no data is present');
    }
}
