
@isTest
private class BotController_1_Tests {

    @isTest
    static void testValidHandlerMapping() {
        String handlerClassName = 'TestHandlerClass';
        String patternStr = '^test.*';
        
        Test.startTest();
        BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(handlerClassName, patternStr);
        Test.stopTest();

        System.assertEquals(handlerClassName, handlerMapping.handlerClassName, 'Handler class name should match.');
        System.assertNotNull(handlerMapping.utterancePattern, 'Utterance pattern should not be null.');
    }
    
    @isTest
    static void testInvalidPattern() {
        String handlerClassName = 'TestHandlerClass';
        String patternStr = '***'; // Invalid regex pattern
        try {
            Test.startTest();
            BotController.HandlerMapping handlerMapping = new BotController.HandlerMapping(handlerClassName, patternStr);
            Test.stopTest();
            System.fail('PatternSyntaxException expected but was not thrown.');
        } catch (PatternSyntaxException e) {
            // Expected exception, test passes
        }
    }
    
    @isTest
    static void testEmptyOrNullHandlerClassName() {
        String patternStr = '^test.*';

        BotController.HandlerMapping handlerMappingEmpty = new BotController.HandlerMapping('', patternStr);
        System.assertEquals('', handlerMappingEmpty.handlerClassName, 'Handler class name should be empty.');
        
        BotController.HandlerMapping handlerMappingNull = new BotController.HandlerMapping(null, patternStr);
        System.assertEquals(null, handlerMappingNull.handlerClassName, 'Handler class name should be null.');
    }
    
    @isTest
    static void testEmptyOrNullPatternStr() {
        String handlerClassName = 'TestHandlerClass';
        
        BotController.HandlerMapping handlerMappingEmpty = new BotController.HandlerMapping(handlerClassName, '');
        System.assertEquals('', handlerMappingEmpty.utterancePattern.pattern(), 'Pattern string should be empty.');

        try {
            BotController.HandlerMapping handlerMappingNull = new BotController.HandlerMapping(handlerClassName, null);
            System.fail('NullPointerException expected but was not thrown.');
        } catch (NullPointerException e) {
            // Expected exception, test passes
        }
    }
}
