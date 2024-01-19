
@isTest
public class PropertyController_1_Tests {
    // Test setup
    @testSetup
    static void setup() {
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 20; i++) {
            properties.add(new Property__c(
                Title__c = 'Property ' + i,
                Price__c = 1000 * i,
                Beds__c = i,
                Baths__c = i,
                City__c = 'City ' + i,
                Tags__c = 'Tag ' + i
            ));
        }
        insert properties;
    }

    @isTest
    static void getPropertyList_HappyPath() {
        List<Property__c> properties = PropertyController.getPropertyList(
            'Property', 1000, 5000, 2, 2, 'Tag'
        );
        System.assertEquals(4, properties.size(), 'Should return 4 properties within search parameters');
    }

    @isTest
    static void getPropertyList_NoResults() {
        List<Property__c> properties = PropertyController.getPropertyList(
            'Nonexistent', 10000, 20000, 50, 40, 'NoTag'
        );
        System.assertEquals(0, properties.size(), 'Should return an empty list as no property matches the search parameters');
    }

    @isTest
    static void getPropertyList_MinMaxPriceOutOfRange() {
        List<Property__c> properties = PropertyController.getPropertyList(
            'Property', 30000, 40000, 2, 2, 'Tag'
        );
        System.assertEquals(0, properties.size(), 'Should return an empty list as no property matches the price range');
    }
}
