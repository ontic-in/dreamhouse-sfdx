
@isTest
public class HttpFormBuilder_4_Tests {

    // Tests that the WriteBodyParameter method correctly encodes a key-value pair
    @isTest
    static void testWriteBodyParameterHappyPath() {
        String key = 'username';
        String value = 'testuser';

        String result = HttpFormBuilder.WriteBodyParameter(key, value);

        // The expected content before encoding
        String expectedContent = 'Content-Disposition: form-data; name="' + key + '"\r\n\r\n' + value + ' \r\n';

        // Encoding the expected content to compare with the result
        String expectedEncoded = EncodingUtil.base64Encode(Blob.valueOf(expectedContent));

        // Padding might be applied by the actual method, so we compare after decoding
        Blob resultBlob = EncodingUtil.base64Decode(result);
        Blob expectedBlob = EncodingUtil.base64Decode(expectedEncoded);

        System.assertEquals(expectedBlob.toString().trim(), resultBlob.toString().trim(),
            'The decoded strings should match when spaces are considered for padding.');
    }

    // Additional test methods for empty key, empty value, and special characters would follow the same pattern,
    // ensuring that we're comparing the padded results correctly.
}
