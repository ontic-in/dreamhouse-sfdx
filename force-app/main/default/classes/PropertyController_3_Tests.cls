
@isTest
public class PropertyController_3_Tests {

    @testSetup
    static void setup() {
        // Disable the triggers
        AccountTriggerHandler.bypass('AccountTriggerHandler');
        MDTAccountTriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test data
        Property__c property = new Property__c(Name='TestProperty', Beds__c=3, Baths__c=2, Address__c='123 Street', City__c='City', State__c='State', Assessed_value__c=100000, Price__c=200000, Date_Listed__c=Date.today());
        insert property;
    }
    
    @isTest
    static void testFindById_HappyPath() {
        // Get the test property
        Property__c property = [SELECT Id FROM Property__c WHERE Name = 'TestProperty' LIMIT 1];
        
        // Execute the method
        Property__c result = PropertyController.findById(property.Id);
        
        // Assertions
        System.assertNotEquals(null, result, 'Property should be found');
        System.assertEquals(property.Id, result.Id, 'Property Id should match');
    }
    
    @isTest
    static void testFindById_SadPath() {
        // Generate a fake Id
        Id fakeId = Schema.SObjectType.Property__c.getKeyPrefix() + '123456789012';
        
        // Execute the method and catch exception
        Exception thrownException;
        try {
            PropertyController.findById(fakeId);
        } catch (Exception e) {
            thrownException = e;
        }
        
        // Assertions
        System.assertNotEquals(null, thrownException, 'Exception should be thrown');
        System.assert(thrownException instanceof QueryException, 'Exception should be of type QueryException');
    }
    
    @isTest
    static void testFindById_ExceptionalPath() {
        // Execute the method and catch exception
        Exception thrownException;
        try {
            PropertyController.findById(null);
        } catch (Exception e) {
            thrownException = e;
        }
        
        // Assertions
        System.assertNotEquals(null, thrownException, 'Exception should be thrown');
        System.assert(thrownException instanceof QueryException, 'Exception should be of type QueryException');
    }
}
