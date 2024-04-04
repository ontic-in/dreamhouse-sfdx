
@isTest
private class HttpFormBuilder_4_Tests {

    // Happy Path Scenario: Write a body parameter with a key and a non-empty value
    @isTest
    static void shouldWriteBodyParameterWithKeyAndValue() {
        // Arrange
        String testKey = 'name';
        String testValue = 'John Doe';
        
        // Act
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.contains(testKey), 'The result should contain the key.');
    }

    // Happy Path Scenario: Write a body parameter with a key and an empty value
    @isTest
    static void shouldWriteBodyParameterWithKeyAndEmptyValue() {
        // Arrange
        String testKey = 'name';
        String testValue = '';
        
        // Act
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.contains(testKey), 'The result should contain the key.');
    }

    // Sad Path Scenario: Write a body parameter with an empty key and a non-empty value
    @isTest
    static void shouldHandleEmptyKey() {
        // Arrange
        String testKey = '';
        String testValue = 'John Doe';
        
        // Act
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.contains('name=""'), 'The result should reflect the empty key.');
    }

    // Sad Path Scenario: Write a body parameter with a null key and a non-empty value
    @isTest
    static void shouldHandleNullKey() {
        // Arrange
        String testKey = null;
        String testValue = 'John Doe';
        
        // Act
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.contains('name="null"'), 'The result should reflect the null key.');
    }

    // Sad Path Scenario: Write a body parameter with a key and a null value
    @isTest
    static void shouldHandleNullValue() {
        // Arrange
        String testKey = 'name';
        String testValue = null;
        
        // Act
        String result = HttpFormBuilder.WriteBodyParameter(testKey, testValue);
        
        // Assert
        System.assertNotEquals(null, result, 'The result should not be null.');
        System.assert(result.contains(testKey), 'The result should contain the key.');
    }
}
