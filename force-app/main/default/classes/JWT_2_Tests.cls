
@isTest
private class JWT_2_Tests {

    @isTest
    static void testBase64URLEncodeHappyPath() {
        // Create an instance of JWT
        JWT jwtInstance = new JWT('none');
        
        // Given a sample Blob
        Blob sampleBlob = Blob.valueOf('Unit test for base64URLencode');
        
        // When base64URLencode is called on an instance
        String result = jwtInstance.base64URLencode(sampleBlob);
        
        // Then we expect a URL-safe Base64-encoded string
        System.assertNotEquals(null, result, 'The result should not be null');
        System.assertEquals(false, result.contains('+'), 'The result should not contain + character');
        System.assertEquals(false, result.contains('/'), 'The result should not contain / character');
        System.assertEquals(false, result.endsWith('='), 'The result should not end with = character');
    }
}
