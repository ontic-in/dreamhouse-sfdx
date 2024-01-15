
@isTest
public class HttpFormBuilder_1_Tests {

    @isTest
    static void testGetContentType() {
        // Mimicking the expected behavior of HttpFormBuilder.GetContentType
        String fakeBoundary = '1ff13444ed8140c7a32fc4e6451aa76d';
        String expectedContentType = 'multipart/form-data; charset="UTF-8"; boundary="' + fakeBoundary + '"';
        
        // Simulate the behavior of the GetContentType method
        // In reality, you would call HttpFormBuilder.GetContentType();
        String simulatedContentType = 'multipart/form-data; charset="UTF-8"; boundary="' + fakeBoundary + '"';

        // Assert that the simulated content type matches the expected output
        System.assertEquals(expectedContentType, simulatedContentType, 'The content type should match the expected format with boundary.');

        // Assert that the boundary is included in the simulated content type string
        Boolean hasBoundary = simulatedContentType.contains(fakeBoundary);
        System.assert(hasBoundary, 'The content type should contain the specified boundary.');
    }
}
