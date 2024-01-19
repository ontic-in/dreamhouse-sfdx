
@isTest
private class PropertyController_2_Tests {
    // ... (Other methods and test setup code)

    @isTest
    static void testGetPropertyListPageWithNegativePageNumber() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Boolean exceptionThrown = false;
        Test.startTest();
        try {
            PropertyListPage result = PropertyController.getPropertyListPage(
                'Test',
                400000,
                600000,
                2,
                2,
                '',
                2,
                -1
            );
        } catch (System.QueryException e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('SOQL offset must be a non-negative value'),
                'The exception message should indicate an issue with a negative offset.');
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'An exception should have been thrown due to a negative offset.');
    }

    // ... (Other methods)
}
