
@isTest
public class PropertyController_2_Tests {
    @testSetup
    static void setup() {
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            properties.add(new Property__c(
                Name = 'Test Property ' + i,
                Price__c = i * 100000,
                Beds__c = i,
                Baths__c = i
            ));
        }
        insert properties;
    }

    @isTest
    static void testGetPropertyListPage_HappyPath() {
        String searchKey = 'Test';
        Decimal minPrice = 200000;
        Decimal maxPrice = 800000;
        Integer numberBedrooms = 3;
        Integer numberBathrooms = 3;
        String visualSearchKey = 'Test';
        Decimal pageSize = 5;
        Decimal pageNumber = 1;

        Test.startTest();
        Object result = PropertyController.getPropertyListPage(searchKey, minPrice, maxPrice, numberBedrooms, numberBathrooms, visualSearchKey, pageSize, pageNumber);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    static void testGetPropertyListPage_SadPath() {
        String searchKey = 'No Matching Properties';
        Decimal minPrice = 200000;
        Decimal maxPrice = 800000;
        Integer numberBedrooms = 3;
        Integer numberBathrooms = 3;
        String visualSearchKey = 'Test';
        Decimal pageSize = 5;
        Decimal pageNumber = 1;

        Test.startTest();
        Object result = PropertyController.getPropertyListPage(searchKey, minPrice, maxPrice, numberBedrooms, numberBathrooms, visualSearchKey, pageSize, pageNumber);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    static void testGetPropertyListPage_ExceptionScenario() {
        String searchKey = null;
        Decimal minPrice = null;
        Decimal maxPrice = null;
        Integer numberBedrooms = null;
        Integer numberBathrooms = null;
        String visualSearchKey = null;
        Decimal pageSize = null;
        Decimal pageNumber = null;

        Test.startTest();
        Object result = PropertyController.getPropertyListPage(searchKey, minPrice, maxPrice, numberBedrooms, numberBathrooms, visualSearchKey, pageSize, pageNumber);
        Test.stopTest();

        System.assertNotEquals(null, result, 'Result should not be null');
    }
}
