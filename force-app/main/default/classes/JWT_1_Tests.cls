
@isTest
public class JWT_1_Tests {

    private static JWT createJWTInstance(String alg) {
        JWT jwtInstance = new JWT(alg);
        jwtInstance.iss = 'issuer';
        jwtInstance.sub = 'subject';
        jwtInstance.aud = 'audience';
        jwtInstance.validFor = 300; // Set a validFor time frame
        return jwtInstance;
    }
    
    @isTest
    private static void testIssueWithNoneAlgorithm() {
        JWT jwtInstance = createJWTInstance(JWT.NONE);
        
        Test.startTest();
        String token = jwtInstance.issue();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, token, 'Token should not be null');
        List<String> tokenParts = token.split('\\.');
        System.assertEquals(2, tokenParts.size(), 'Token should have two parts when using "none" algorithm');
    }
    
    @isTest
    private static void testIssueWithHS256Algorithm() {
        JWT jwtInstance = createJWTInstance(JWT.HS256);
        jwtInstance.privateKey = 'privateKey'; // This should be a base64 encoded string in real scenarios
        
        Test.startTest();
        String token = jwtInstance.issue();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, token, 'Token should not be null');
        List<String> tokenParts = token.split('\\.');
        System.assertEquals(3, tokenParts.size(), 'Token should have three parts when using "HS256" algorithm');
    }

    @isTest
    private static void testIssueWithRS256AlgorithmUsingCert() {
        JWT jwtInstance = createJWTInstance(JWT.RS256);
        jwtInstance.cert = 'cert'; // This should be the name of a certificate in real scenarios
        
        Test.startTest();
        String token = jwtInstance.issue();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, token, 'Token should not be null');
        List<String> tokenParts = token.split('\\.');
        System.assertEquals(3, tokenParts.size(), 'Token should have three parts when using "RS256" algorithm with cert');
    }
    
    @isTest
    private static void testIssueWithRS256AlgorithmUsingPkcs8() {
        JWT jwtInstance = createJWTInstance(JWT.RS256);
        jwtInstance.pkcs8 = 'pkcs8'; // This should be a base64 encoded private key in real scenarios
        
        Test.startTest();
        String token = jwtInstance.issue();
        Test.stopTest();
        
        // Assertions
        System.assertNotEquals(null, token, 'Token should not be null');
        List<String> tokenParts = token.split('\\.');
        System.assertEquals(3, tokenParts.size(), 'Token should have three parts when using "RS256" algorithm with pkcs8');
    }

    @isTest
    private static void testIssueWithInvalidAlgorithm() {
        JWT jwtInstance = createJWTInstance('invalidAlg');
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
            String token = jwtInstance.issue();
        } catch (Exception e) {
            exceptionThrown = true;
            // Assertion within the catch block
            System.assert(true, 'An exception should be thrown for invalid algorithm');
        }
        Test.stopTest();
        
        // Additional assertion to ensure the test fails if no exception is thrown
        System.assertTrue(exceptionThrown, 'An exception should have been thrown for an invalid algorithm');
    }
}
