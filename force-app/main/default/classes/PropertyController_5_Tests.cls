
@isTest
private class PropertyController_5_Tests {
    
    @testSetup
    static void setup() {
        List<Property__c> properties = new List<Property__c>();
        
        // Creating 5 properties with Predicted_Days_On_Market__c less than 30
        for(Integer i=0; i<5; i++) {
            properties.add(new Property__c(
                name='Property '+i,
                address__c='Address '+i,
                city__c='City '+i,
                price__c=50000,
                Predicted_Days_On_Market__c=20
            ));
        }
        
        // Creating 2 properties with Predicted_Days_On_Market__c more than 30
        for(Integer i=5; i<7; i++) {
            properties.add(new Property__c(
                name='Property '+i,
                address__c='Address '+i,
                city__c='City '+i,
                price__c=50000,
                Predicted_Days_On_Market__c=40
            ));
        }
        
        insert properties;
    }
    
    @isTest
    static void testGetAtRiskProperties_HappyPath() {
        Test.startTest();
        List<Property__c> atRiskProperties = PropertyController.getAtRiskProperties();
        Test.stopTest();
        
        // There should be 2 properties that are 'at risk'
        System.assertEquals(2, atRiskProperties.size(), 'Number of at risk properties does not match');
    }
    
    @isTest
    static void testGetAtRiskProperties_SadPath() {
        // Deleting all 'at risk' properties
        delete [SELECT id FROM Property__c WHERE Predicted_Days_On_Market__c > 30];
        
        Test.startTest();
        List<Property__c> atRiskProperties = PropertyController.getAtRiskProperties();
        Test.stopTest();
        
        // There should be no 'at risk' properties
        System.assertEquals(0, atRiskProperties.size(), 'Number of at risk properties does not match');
    }
    
    // Exception scenarios can be added here based on known exceptions that can be thrown by the method
}
