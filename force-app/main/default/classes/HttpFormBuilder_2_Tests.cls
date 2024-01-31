
@isTest
private class HttpFormBuilder_2_Tests {

    // Since the HttpFormBuilder.Boundary is private, we need to define
    // an expected format for the boundary that matches the one being used
    // in the WriteBoundary method.
    private static final String expectedBoundaryFormat = '--1ff13444ed8140c7a32fc4e6451aa76d\r\n';

    @isTest
    static void testWriteBoundaryReturnsEncodedString() {
        // Test that WriteBoundary returns a non-null, non-empty base64 string
        String boundaryEncoded = HttpFormBuilder.WriteBoundary();
        System.assertNotEquals(null, boundaryEncoded, 'The encoded boundary should not be null.');
        System.assertNotEquals('', boundaryEncoded, 'The encoded boundary should not be empty.');
    }

    @isTest
    static void testWriteBoundaryContainsBoundary() {
        // Test that when the WriteBoundary base64 string is decoded it contains the expected boundary format
        String boundaryEncoded = HttpFormBuilder.WriteBoundary();
        Blob boundaryDecodedBlob = EncodingUtil.base64Decode(boundaryEncoded);
        String boundaryDecoded = boundaryDecodedBlob.toString();
        System.assertEquals(expectedBoundaryFormat, boundaryDecoded, 'The decoded boundary should match the expected format.');
    }

    @isTest
    static void testWriteBoundaryConsistentResult() {
        // Test that WriteBoundary always returns the same string for consistency
        String boundaryEncodedFirstCall = HttpFormBuilder.WriteBoundary();
        String boundaryEncodedSecondCall = HttpFormBuilder.WriteBoundary();
        System.assertEquals(boundaryEncodedFirstCall, boundaryEncodedSecondCall, 'The encoded boundary should be consistent across calls.');
    }
}
