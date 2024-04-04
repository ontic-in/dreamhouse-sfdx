
@isTest
public with sharing class HandlerFindAccount_1_Tests {

    private static void createTestAccounts() {
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(Name = 'TestAccount' + i, Phone = '123456789' + i));
        }
        insert testAccounts;
    }
    
    @isTest
    static void testHandleWithMatchingAccounts() {
        createTestAccounts();
        HandlerFindAccount handler = new HandlerFindAccount();
        String[] params = new String[]{'TestAccount'};
        BotResponse response = handler.handle('find account', params, new Map<String, String>(), null, null);
        
        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertEquals(5, response.getMessage().getRecords().size(), 'Should return 5 matching accounts.');
    }
    
    @isTest
    static void testHandleWithNoMatchingAccounts() {
        createTestAccounts();
        HandlerFindAccount handler = new HandlerFindAccount();
        String[] params = new String[]{'NonExistingAccount'};
        BotResponse response = handler.handle('find account', params, new Map<String, String>(), null, null);
        
        System.assertNotEquals(null, response, 'Response should not be null.');
        System.assertTrue(response.getMessage().getRecords().isEmpty(), 'Should return 0 matching accounts.');
    }
    
    @isTest
    static void testHandleWithEmptyParams() {
        createTestAccounts();
        HandlerFindAccount handler = new HandlerFindAccount();
        String[] params = new String[]{};

        try {
            BotResponse response = handler.handle('find account', params, new Map<String, String>(), null, null);
            System.fail('An ArrayIndexOutOfBoundsException should have been thrown due to empty params.');
        } catch (ArrayIndexOutOfBoundsException e) {
            // Assertion to ensure the correct exception is caught
            System.assert(e != null, 'An ArrayIndexOutOfBoundsException was expected.');
        }
    }
    
    @isTest
    static void testHandleWithNullParams() {
        createTestAccounts();
        HandlerFindAccount handler = new HandlerFindAccount();
        String[] params = null;

        try {
            BotResponse response = handler.handle('find account', params, new Map<String, String>(), null, null);
            System.fail('A NullPointerException should have been thrown due to null params.');
        } catch (NullPointerException e) {
            // Assertion to ensure the correct exception is caught
            System.assert(e != null, 'A NullPointerException was expected.');
        }
    }
}
