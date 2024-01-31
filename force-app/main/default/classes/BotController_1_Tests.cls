
@isTest
private class BotController_1_Tests {
    
    @testSetup
    static void makeTestData() {
        // Since no actual DML operation is performed, no test data setup is required.
        // Bypass Account triggers as they are not relevant for the tests.
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }
    
    @isTest
    static void testHandlerMappingWithValidInput() {
        String testClassName = 'TestHandler';
        String testPattern = 'Hello.*';

        Test.startTest();
        BotController.HandlerMapping hm = new BotController.HandlerMapping(testClassName, testPattern);
        Test.stopTest();

        System.assertEquals(testClassName, hm.handlerClassName, 'Handler class name should match input value');
        System.assertNotEquals(null, hm.utterancePattern, 'Utterance pattern should not be null');
    }

    @isTest
    static void testHandlerMappingWithNullClassName() {
        String testPattern = 'Hello.*';

        Test.startTest();
        BotController.HandlerMapping hm = new BotController.HandlerMapping(null, testPattern);
        Test.stopTest();

        System.assertEquals(null, hm.handlerClassName, 'Handler class name should be null');
        System.assertNotEquals(null, hm.utterancePattern, 'Utterance pattern should not be null');
    }

    @isTest
    static void testHandlerMappingWithInvalidRegex() {
        String testClassName = 'TestHandler';
        String invalidPattern = 'Hello(**'; // This is an invalid regex pattern
        
        Boolean isExceptionThrown = false;
        
        try {
            Test.startTest();
            BotController.HandlerMapping hm = new BotController.HandlerMapping(testClassName, invalidPattern);
            Test.stopTest();
        } catch (PatternSyntaxException e) {
            isExceptionThrown = true;
            // Assertion to ensure a PatternSyntaxException is thrown
            System.assertTrue(isExceptionThrown, 'A PatternSyntaxException should have been thrown for the invalid regex pattern');
        }
        
        // Additional assertion to ensure that the exception was indeed thrown
        System.assertTrue(isExceptionThrown, 'A PatternSyntaxException should have been thrown for the invalid regex pattern');
    }
}
