
@isTest
private class HttpFormBuilder_4_Tests {

    @isTest
    static void testWriteBodyParameterWithValidInputs() {
        String testKey = 'username';
        String testValue = 'testUser';
        
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assert(result.contains(testKey) && result.contains(testValue), 'The result should contain the key and value');
    }

    @isTest
    static void testWriteBodyParameterWithNullKey() {
        String testValue = 'testValue';
        
        String result = HttpFormBuilder.WriteBodyParameter(null, testValue);
        
        System.assertNotEquals(null, result, 'The result should not be null when key is null');
    }

    @isTest
    static void testWriteBodyParameterWithNullValue() {
        String testKey = 'testKey';
        
        String result = HttpFormBuilder.WriteBodyParameter(testKey, null);
        
        System.assertNotEquals(null, result, 'The result should not be null when value is null');
    }

    @isTest
    static void testWriteBodyParameterWithLongInputs() {
        String testKey = String.join(new List<String>(1000), 'longKey');
        String testValue = String.join(new List<String>(1000), 'longValue');
        
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        System.assertNotEquals(null, result, 'The result should not be null with long inputs');
        System.assert(result.length() > 0, 'The result should be a non-empty string');
    }
}
