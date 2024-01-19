
@isTest
public class PropertyController_4_Tests {
    @testSetup
    static void setup() {
        // insert test data
        List<Property__c> properties = new List<Property__c>{
            new Property__c(Name='Test Property 1', Date_Listed__c=System.today(), Date_Agreement__c=null),
            new Property__c(Name='Test Property 2', Date_Listed__c=System.today()-91, Date_Agreement__c=System.today()-91),
            new Property__c(Name='Test Property 3', Date_Listed__c=System.today()-89, Date_Agreement__c=null)
        };
        insert properties;
    }

    @isTest static void testHappyPath() {
        Test.startTest();
        List<Property__c> result = PropertyController.getAvailableProperties();
        Test.stopTest();
        System.assertEquals(2, result.size(), 'Should return the properties that are listed and have either no agreement or the agreement date is within the last 90 days.');
    }

    @isTest static void testSadPath() {
        // Delete all properties to simulate the scenario where no properties meet the criteria
        delete [SELECT id FROM Property__c];

        Test.startTest();
        List<Property__c> result = PropertyController.getAvailableProperties();
        Test.stopTest();
        System.assertEquals(0, result.size(), 'Should return an empty list if no properties meet the criteria.');
    }
}
