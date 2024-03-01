
@isTest
private class EinsteinVisionController_3_Tests {
    
    // Test setup to create test data
    @testSetup
    static void setup() {
        // No setup data required for the predictDemo method
    }
    
    // Test the happy path scenario
    @isTest
    static void testPredictDemoWithUnderscore() {
        // Call the method with a filename that contains an underscore
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictDemo('victorian_01.jpg', 'content');
        
        // Assert that the predictions size is 1
        System.assertEquals(1, predictions.size(), 'There should be 1 prediction');
        
        // Assert that the label is 'victorian'
        System.assertEquals('victorian', predictions[0].label, 'The label should be victorian');
    }
    
    // Test the sad path scenario
    @isTest
    static void testPredictDemoWithoutUnderscore() {
        // Call the method with a filename that does not contain an underscore
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictDemo('somefile.jpg', 'content');
        
        // Assert that the predictions size is 1
        System.assertEquals(1, predictions.size(), 'There should be 1 prediction');
        
        // Assert that the label is not empty
        System.assertNotEquals(null, predictions[0].label, 'The label should not be null');
    }
}
