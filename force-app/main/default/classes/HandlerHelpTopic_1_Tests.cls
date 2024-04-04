
@isTest
private class HandlerHelpTopic_1_Tests {
    
    @isTest
    static void testHandleFirstTimeSessionNull() {
        // Given
        HandlerHelpTopic handler = new HandlerHelpTopic();

        // When
        BotResponse response = handler.handle(null, new String[]{}, null, null, null);

        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('What best describes your role?', response.messageText, 'The response message text should ask for the user role');
    }

    @isTest
    static void testHandleUserRole() {
        // Given
        HandlerHelpTopic handler = new HandlerHelpTopic();
        Map<String, String> sessionMap = new Map<String, String>{'nextCommand' => 'HandlerHelpTopic'};

        // When
        BotResponse response = handler.handle('User', new String[]{}, sessionMap, null, null);

        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('I recommend the following Trailhead Modules:', response.messageText, 'The response message text should provide recommendations for User');
        System.assertEquals(3, response.messageItems.size(), 'There should be 3 items for the User role');
    }

    @isTest
    static void testHandleAdminRole() {
        // Given
        HandlerHelpTopic handler = new HandlerHelpTopic();
        Map<String, String> sessionMap = new Map<String, String>{'nextCommand' => 'HandlerHelpTopic'};

        // When
        BotResponse response = handler.handle('Admin', new String[]{}, sessionMap, null, null);

        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(4, response.messageItems.size(), 'There should be 4 items for the Admin role');
    }

    @isTest
    static void testHandleDeveloperRole() {
        // Given
        HandlerHelpTopic handler = new HandlerHelpTopic();
        Map<String, String> sessionMap = new Map<String, String>{'nextCommand' => 'HandlerHelpTopic'};

        // When
        BotResponse response = handler.handle('Developer', new String[]{}, sessionMap, null, null);

        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(3, response.messageItems.size(), 'There should be 3 items for the Developer role');
    }

    @isTest
    static void testHandleUnknownRole() {
        // Given
        HandlerHelpTopic handler = new HandlerHelpTopic();
        Map<String, String> sessionMap = new Map<String, String>{'nextCommand' => 'HandlerHelpTopic'};

        // When
        BotResponse response = handler.handle('NonExistentRole', new String[]{}, sessionMap, null, null);

        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(0, response.messageItems.size(), 'There should be no items for an unknown role');
    }
}
