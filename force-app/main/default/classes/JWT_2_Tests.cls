
@isTest
private class JWT_2_Tests {
    
    @isTest
    static void testBase64URLencodeHappyPath() {
        String testString = 'Test String for Encoding';
        Blob testBlob = Blob.valueOf(testString);
        JWT jwtInstance = new JWT(JWT.NONE);
        
        Test.startTest();
        String result = jwtInstance.base64URLencode(testBlob);
        Test.stopTest();
        
        // Check if '+' was replaced with '-'
        System.assert(result.indexOf('+') == -1, 'Plus signs should be replaced by hyphens.');
        // Check if '/' was replaced with '_'
        System.assert(result.indexOf('/') == -1, 'Forward slashes should be replaced by underscores.');
        // Check if the output does not end with '='
        System.assert(!result.endsWith('='), 'Output should not end with equals sign.');
    }

    @isTest
    static void testBase64URLencodeEmptyBlob() {
        Blob testBlob = Blob.valueOf('');
        JWT jwtInstance = new JWT(JWT.NONE);
        
        Test.startTest();
        String result = jwtInstance.base64URLencode(testBlob);
        Test.stopTest();
        
        // Check if the result is an empty string
        System.assertEquals('', result, 'The encoded string of an empty blob should be empty.');
    }

    @isTest
    static void testBase64URLencodeWithNull() {
        JWT jwtInstance = new JWT(JWT.NONE);
        Boolean exceptionThrown = false;
        
        try {
            Test.startTest();
            String result = jwtInstance.base64URLencode(null);
            Test.stopTest();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        // Check if an exception was thrown
        System.assert(exceptionThrown, 'Passing null to base64URLencode should throw an exception.');
    }
}
