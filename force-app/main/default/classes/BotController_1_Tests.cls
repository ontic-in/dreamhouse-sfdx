
@isTest
private class BotController_1_Tests {

    // Happy Path Scenario 1: Valid class name and valid pattern string
    @isTest
    static void testHandlerMappingHappyPath() {
        String validClassName = 'TestHandlerClassName';
        String validPattern = 'hello.*';

        Test.startTest();
        BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(validClassName, validPattern);
        Test.stopTest();

        System.assertEquals(validClassName, handlerMapping.handlerClassName, 'The class name should be set correctly.');
        System.assertNotEquals(null, handlerMapping.utterancePattern, 'The pattern should be compiled and not null.');
    }
    
    // Happy Path Scenario 2: Valid class name with a complex regex pattern
    @isTest
    static void testHandlerMappingWithComplexPattern() {
        String validClassName = 'TestHandlerClassName';
        String complexPattern = '^\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}$';

        Test.startTest();
        BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(validClassName, complexPattern);
        Test.stopTest();

        System.assertEquals(validClassName, handlerMapping.handlerClassName, 'The class name should be set correctly.');
        System.assertNotEquals(null, handlerMapping.utterancePattern, 'The pattern should be compiled and not null.');
    }
    
    // Sad Path Scenario 1: Null or empty class name
    @isTest
    static void testHandlerMappingWithEmptyClassName() {
        String invalidClassName = '';
        String validPattern = 'hello.*';

        Test.startTest();
        BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(invalidClassName, validPattern);
        Test.stopTest();

        System.assertEquals(invalidClassName, handlerMapping.handlerClassName, 'The class name should be set correctly even if it is empty.');
    }
    
    // Sad Path Scenario 2: Null or empty pattern string
    @isTest
    static void testHandlerMappingWithEmptyPattern() {
        String validClassName = 'TestHandlerClassName';
        String invalidPattern = '';

        Exception caughtException = null;
        Test.startTest();
        try {
            BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(validClassName, invalidPattern);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An empty pattern string should cause an exception.');
        System.assertTrue(caughtException instanceof PatternSyntaxException, 'The thrown exception should be a PatternSyntaxException.');
    }
    
    // Exception Scenario: Pattern.compile throws PatternSyntaxException
    @isTest
    static void testHandlerMappingWithInvalidPattern() {
        String validClassName = 'TestHandlerClassName';
        String invalidPattern = '\\K';  // Invalid regex pattern

        Exception caughtException = null;
        Test.startTest();
        try {
            BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(validClassName, invalidPattern);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An invalid regex pattern should cause an exception.');
        System.assertTrue(caughtException instanceof PatternSyntaxException, 'The thrown exception should be a PatternSyntaxException.');
    }
}
