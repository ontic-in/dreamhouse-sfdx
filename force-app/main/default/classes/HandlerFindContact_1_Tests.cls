
@isTest
private class HandlerFindContact_1_Tests {
    
    @testSetup
    static void setup() {
        // Bypass Contact trigger handlers since we are dealing with Contacts
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Create test contacts
        List<Contact> contactsToInsert = new List<Contact>{
            new Contact(Name='John Doe', MobilePhone='1234567890'),
            new Contact(Name='Jane Doe', MobilePhone='0987654321')
        };
        insert contactsToInsert;
    }
    
    @isTest
    static void testHandleWithMatchingContacts() {
        // Set up test data
        Map<String, String> sessionMap = new Map<String, String>();
        String[] params = new String[]{ 'John' };
        
        // Test handle method
        HandlerFindContact handler = new HandlerFindContact();
        BotResponse response = handler.handle('Find John', params, sessionMap, null, null);
        
        // Assertions - Replace 'getBotRecords()' with the actual method name from the BotResponse class
        System.assertNotEquals(null, response, 'The response should not be null.');
        System.assertNotEquals(null, response.getBotRecords(), 'The records in the response should not be null.');
        System.assertTrue(response.getBotRecords().size() > 0, 'There should be at least one matching contact.');
    }
    
    @isTest
    static void testHandleWithNoMatchingContacts() {
        // Set up test data
        Map<String, String> sessionMap = new Map<String, String>();
        String[] params = new String[]{ 'Nonexistent' };
        
        // Test handle method
        HandlerFindContact handler = new HandlerFindContact();
        BotResponse response = handler.handle('Find Nonexistent', params, sessionMap, null, null);
        
        // Assertions - Replace 'getBotRecords()' with the actual method name from the BotResponse class
        System.assertNotEquals(null, response, 'The response should not be null.');
        System.assertEquals(0, response.getBotRecords().size(), 'There should be no matching contacts.');
    }
    
    @isTest
    static void testHandleWithNullParams() {
        // Set up test data
        Map<String, String> sessionMap = new Map<String, String>();
        String[] params = null;
        
        Boolean didThrowException = false;
        
        try {
            // Test handle method
            HandlerFindContact handler = new HandlerFindContact();
            BotResponse response = handler.handle('Find', params, sessionMap, null, null);
        } catch (Exception e) {
            didThrowException = e instanceof ListIndexOutOfBoundsException;
        }
        
        // Assertions
        System.assertTrue(didThrowException, 'Expected ListIndexOutOfBoundsException to be thrown due to null params.');
    }
}
