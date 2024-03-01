
public class HandlerMapping {
    public String handlerClassName;
    public Pattern utterancePattern;

    public HandlerMapping(String handlerClassName, String patternStr) {
        this.handlerClassName = handlerClassName;
        this.utterancePattern = Pattern.compile(patternStr);
    }
}


@isTest
private class BotController_1_Tests {
    // Assuming HandlerMapping is publicly accessible
    // Happy Path Test
    @isTest
    static void testValidHandlerMapping() {
        String validClassName = 'MyValidHandlerClass';
        String validPattern = '^hello.*$';
        
        BotController.HandlerMapping mapping = new BotController.HandlerMapping(validClassName, validPattern);
        
        System.assertEquals(validClassName, mapping.handlerClassName, 'HandlerClassName should be set correctly');
        System.assertNotNull(mapping.utterancePattern, 'utterancePattern should not be null');
    }
    
    // Exceptional Scenario Test - Null Parameter
    @isTest
    static void testNullHandlerMapping() {
        String nullClassName = null;
        String nullPattern = null;
        
        BotController.HandlerMapping mapping;
        Boolean isExceptionThrown = false;
        try {
            mapping = new BotController.HandlerMapping(nullClassName, nullPattern);
        } catch(NullPointerException e) {
            isExceptionThrown = true;
        }
        
        System.assertTrue(isExceptionThrown, 'Null parameter should throw NullPointerException');
    }
    
    // Exceptional Scenario Test - Empty Pattern
    @isTest
    static void testEmptyHandlerMapping() {
        String emptyClassName = '';
        String emptyPattern = '';
        
        BotController.HandlerMapping mapping = new BotController.HandlerMapping(emptyClassName, emptyPattern);
        
        System.assertEquals(emptyClassName, mapping.handlerClassName, 'HandlerClassName should be an empty string');
        System.assertNotNull(mapping.utterancePattern, 'utterancePattern should not be null for an empty pattern');
    }
    
    // Exceptional Scenario Test - Invalid Regex Pattern
    @isTest
    static void testInvalidRegexHandlerMapping() {
        String validClassName = 'MyValidHandlerClass';
        String invalidPattern = '\\xyz'; // This is an invalid regex pattern
        
        BotController.HandlerMapping mapping;
        Boolean isExceptionThrown = false;
        try {
            mapping = new BotController.HandlerMapping(validClassName, invalidPattern);
        } catch(PatternSyntaxException e) {
            isExceptionThrown = true;
        }
        
        System.assertTrue(isExceptionThrown, 'Invalid regex pattern should throw PatternSyntaxException');
    }
}
