
@isTest
private class HttpFormBuilder_4_Tests {
    @testSetup
    static void setupTestData() {
        // Create test data if needed
    }

    @isTest
    static void testWriteBodyParameter_HappyPath() {
        // Define test input
        String key = 'TestKey';
        String value = 'TestValue';

        // Call the method under test
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        // Perform assertions
        System.assertEquals('Content-Disposition: form-data; name="TestKey"\r\n\r\nTestValue\r\n', result);
    }

    @isTest
    static void testWriteBodyParameter_SadPath() {
        // Define test input
        String key = 'InvalidKey';
        String value = 'TestValue';

        // Call the method under test
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        // Perform assertions
        System.assertNotEquals('Content-Disposition: form-data; name="TestKey"\r\n\r\nTestValue\r\n', result);
    }

    @isTest
    static void testWriteBodyParameter_ExceptionalScenario() {
        // Define test input
        String key = 'TestKey';
        String value = null;

        // Call the method under test
        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        // Perform assertions
        System.assertNotEquals('Content-Disposition: form-data; name="TestKey"\r\n\r\nTestValue\r\n', result);
    }
}
