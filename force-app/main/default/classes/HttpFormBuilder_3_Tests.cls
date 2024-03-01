
@isTest
private class HttpFormBuilder_3_Tests {

    @isTest
    static void testWriteBoundaryWithCr() {
        // Execute
        String boundaryEncoded = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.Cr);

        // Verify that the encoded boundary starts with the expected base64 prefix for a line feed
        System.assert(boundaryEncoded.startsWith('Cg'), 'Boundary should start with base64 encoded line feed for CR ending type.');
    }

    @isTest
    static void testWriteBoundaryWithNone() {
        // Execute
        String boundaryEncoded = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.None);

        // Verify that the encoded boundary starts with the expected base64 prefix for a carriage return and line feed
        System.assert(boundaryEncoded.startsWith('DQo'), 'Boundary should start with base64 encoded carriage return and line feed for None ending type.');
    }

    @isTest
    static void testWriteBoundaryWithCrLf() {
        // Execute
        String boundaryEncoded = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);

        // Verify that the encoded boundary is a valid base64 string by attempting to decode it
        Blob decodedBlob;
        Boolean isValidBase64 = true;
        try {
            decodedBlob = EncodingUtil.base64Decode(boundaryEncoded);
        } catch (Exception e) {
            isValidBase64 = false;
        }
        System.assert(isValidBase64, 'Encoded boundary should be a valid base64 string for CRLF ending type.');
    }
}
