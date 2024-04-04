
@isTest
private class HttpFormBuilder_2_Tests {

    @isTest
    static void testWriteBoundaryHappyPath() {
        // Act
        String boundaryBase64 = HttpFormBuilder.WriteBoundary();

        // Assert
        System.assertNotEquals(null, boundaryBase64, 'Boundary should not be null');
        System.assertNotEquals('', boundaryBase64, 'Boundary should not be an empty string');
    }
}
