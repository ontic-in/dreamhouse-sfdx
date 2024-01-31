
@isTest
public class HttpFormBuilder_1_Tests {

    @isTest
    static void testGetContentType() {
        // Call the method to test
        String result = HttpFormBuilder.GetContentType();

        // Perform assertions
        String expectedContentType = 'multipart/form-data; charset="UTF-8"; boundary="1ff13444ed8140c7a32fc4e6451aa76d"';
        System.assertEquals(expectedContentType, result, 'The content type should be correctly formed with boundary and charset');

        // Additionally, verify that the boundary is present in the result
        Boolean hasBoundary = result.contains('1ff13444ed8140c7a32fc4e6451aa76d');
        System.assert(hasBoundary, 'The boundary string should be present in the content type');
    }
}
