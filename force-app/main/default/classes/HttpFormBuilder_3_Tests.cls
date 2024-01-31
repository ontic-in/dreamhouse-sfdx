
@isTest
private class HttpFormBuilder_3_Tests {

    // Since Boundary is a private constant in HttpFormBuilder, we need to hardcode it for the tests
    private static final String BOUNDARY = '1ff13444ed8140c7a32fc4e6451aa76d';

    @isTest
    static void testWriteBoundaryWithCrEnding() {
        // Expected value is boundary with '\n' prepended and encoded in base64
        String expected = EncodingUtil.base64Encode(Blob.valueOf('\n--' + BOUNDARY + '--'));
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.Cr);

        System.assertEquals(expected, result, 'The boundary should be correctly prefixed with \\n and encoded.');
    }

    @isTest
    static void testWriteBoundaryWithNoneEnding() {
        // Expected value is boundary with '\r\n' prepended and encoded in base64
        String expected = EncodingUtil.base64Encode(Blob.valueOf('\r\n--' + BOUNDARY + '--'));
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.None);

        System.assertEquals(expected, result, 'The boundary should be correctly prefixed with \\r\\n and encoded.');
    }

    @isTest
    static void testWriteBoundaryWithCrLfEnding() {
        // Expected value is boundary without any prepended characters and encoded in base64
        String expected = EncodingUtil.base64Encode(Blob.valueOf('--' + BOUNDARY + '--'));
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);

        System.assertEquals(expected, result, 'The boundary should be correctly encoded without any additional prefix.');
    }
}
