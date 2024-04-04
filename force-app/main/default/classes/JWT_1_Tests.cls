
@isTest
private class JWT_1_Tests {
    
    @isTest
    static void testIssueWithHS256() {
        JWT tokenGenerator = new JWT(JWT.HS256);
        tokenGenerator.privateKey = 'MockPrivateKey'; // Mock private key
        tokenGenerator.iss = 'testIssuer';
        tokenGenerator.sub = 'testSubject';
        tokenGenerator.aud = 'testAudience';
        
        String jwt = tokenGenerator.issue();
        
        System.assertNotEquals(null, jwt, 'JWT should not be null');
        System.assert(jwt.contains('.'), 'JWT should have parts separated by periods');
    }
    
    @isTest
    static void testIssueWithNone() {
        JWT tokenGenerator = new JWT(JWT.NONE);
        tokenGenerator.iss = 'testIssuer';
        tokenGenerator.sub = 'testSubject';
        tokenGenerator.aud = 'testAudience';
        
        String jwt = tokenGenerator.issue();
        
        System.assertNotEquals(null, jwt, 'JWT should not be null');
        System.assert(jwt.endsWith('.'), 'JWT with "none" alg should end with a period');
    }
    
    @isTest
    static void testIssueWithHS256NoPrivateKey() {
        JWT tokenGenerator = new JWT(JWT.HS256);
        tokenGenerator.iss = 'testIssuer';
        tokenGenerator.sub = 'testSubject';
        tokenGenerator.aud = 'testAudience';
        
        Boolean exceptionThrown = false;
        try {
            // This should throw an exception due to missing private key
            String jwt = tokenGenerator.issue();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should be thrown due to missing private key');
    }
    
    @isTest
    static void testIssueWithRS256NoCertNoPrivateKey() {
        JWT tokenGenerator = new JWT(JWT.RS256);
        tokenGenerator.iss = 'testIssuer';
        tokenGenerator.sub = 'testSubject';
        tokenGenerator.aud = 'testAudience';
        
        Boolean exceptionThrown = false;
        try {
            // This should throw an exception due to missing certificate and private key
            String jwt = tokenGenerator.issue();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should be thrown due to missing certificate and private key');
    }
    
    @isTest
    static void testIssueWithUnsupportedAlg() {
        JWT tokenGenerator = new JWT('unsupportedAlg');
        tokenGenerator.iss = 'testIssuer';
        tokenGenerator.sub = 'testSubject';
        tokenGenerator.aud = 'testAudience';
        
        Boolean exceptionThrown = false;
        try {
            // This should throw an exception due to unsupported algorithm
            String jwt = tokenGenerator.issue();
        } catch (Exception e) {
            exceptionThrown = true;
        }
        
        System.assert(exceptionThrown, 'An exception should be thrown due to unsupported algorithm');
    }
}
