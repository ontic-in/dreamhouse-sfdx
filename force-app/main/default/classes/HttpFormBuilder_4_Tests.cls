
@isTest
private class HttpFormBuilder_4_Tests {

    @isTest
    static void testWriteBodyParameterHappyPath() {
        String key = 'username';
        String value = 'sfdc_user';
        String result = HttpFormBuilder.WriteBodyParameter(key, value);
        
        // Expected output base64 string should not be empty
        System.assertNotEquals(null, result, 'Result should not be null');
        // Decoded result should contain the key and value pair
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(key), 'Decoded result should contain the key');
        System.assert(resultDecoded.contains(value), 'Decoded result should contain the value');
    }

    @isTest
    static void testWriteBodyParameterNullKey() {
        String value = 'sfdc_user';
        String result = HttpFormBuilder.WriteBodyParameter(null, value);
        
        // The method does not handle null key so the result should not be null
        System.assertNotEquals(null, result, 'Result should not be null for null key');
        // Decoded result should contain the value
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(value), 'Decoded result should contain the value');
    }

    @isTest
    static void testWriteBodyParameterNullValue() {
        String key = 'username';
        String result = HttpFormBuilder.WriteBodyParameter(key, null);
        
        System.assertNotEquals(null, result, 'Result should not be null for null value');
        // Decoded result should contain the key but not the value
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(key), 'Decoded result should contain the key');
        System.assert(!resultDecoded.contains('null'), 'Decoded result should not contain the string "null"');
    }

    @isTest
    static void testWriteBodyParameterEmptyKey() {
        String key = '';
        String value = 'sfdc_user';
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        System.assertNotEquals(null, result, 'Result should not be null for empty key');
        // Decoded result should contain the value since the key is empty
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(value), 'Decoded result should contain the value');
    }

    @isTest
    static void testWriteBodyParameterEmptyValue() {
        String key = 'username';
        String value = '';
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        System.assertNotEquals(null, result, 'Result should not be null for empty value');
        // Decoded result should contain the key
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(key), 'Decoded result should contain the key');
    }

    @isTest
    static void testWriteBodyParameterSpecialCharacters() {
        String key = 'user@name';
        String value = 'sfdc#user$';
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        System.assertNotEquals(null, result, 'Result should not be null');
        // Decoded result should contain the key and value with special characters
        String resultDecoded = EncodingUtil.base64Decode(result).toString();
        System.assert(resultDecoded.contains(key), 'Decoded result should contain the key with special characters');
        System.assert(resultDecoded.contains(value), 'Decoded result should contain the value with special characters');
    }
}
