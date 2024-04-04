
@isTest
private class HttpFormBuilder_3_Tests {

    @isTest
    static void testWriteBoundaryWithCr() {
        // Arrange
        String boundaryValue = '--1ff13444ed8140c7a32fc4e6451aa76d--';
        String crEncoded = EncodingUtil.base64Encode(Blob.valueOf('\n' + boundaryValue));

        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.Cr);

        // Assert
        System.assertEquals(crEncoded, result, 'The encoded boundary with CR should match the expected value.');
    }

    @isTest
    static void testWriteBoundaryWithCrLf() {
        // Arrange
        String boundaryValue = '--1ff13444ed8140c7a32fc4e6451aa76d--';
        String crLfEncoded = EncodingUtil.base64Encode(Blob.valueOf(boundaryValue));

        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.CrLf);

        // Assert
        System.assertEquals(crLfEncoded, result, 'The encoded boundary with CRLF should match the expected value.');
    }

    @isTest
    static void testWriteBoundaryWithNone() {
        // Arrange
        String boundaryValue = '--1ff13444ed8140c7a32fc4e6451aa76d--';
        String noneEncoded = EncodingUtil.base64Encode(Blob.valueOf('\r\n' + boundaryValue));

        // Act
        String result = HttpFormBuilder.WriteBoundary(HttpFormBuilder.EndingType.None);

        // Assert
        System.assertEquals(noneEncoded, result, 'The encoded boundary with NONE should match the expected value.');
    }
}
