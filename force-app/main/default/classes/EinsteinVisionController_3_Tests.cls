
@isTest
private class EinsteinVisionController_3_Tests {

    @isTest
    static void testPredictDemoWithValidLabel() {
        String fileName = 'victorian_01.jpg';
        String content = ''; // This parameter is not used in method logic

        Test.startTest();
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictDemo(fileName, content);
        Test.stopTest();

        System.assertEquals(1, predictions.size(), 'There should be one prediction');
        System.assertEquals('victorian', predictions[0].label, 'The label should be extracted from the file name');
    }

    @isTest
    static void testPredictDemoWithRandomLabel() {
        String fileName = 'random_image.jpg';
        String content = ''; // This parameter is not used in method logic

        Test.startTest();
        List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predictDemo(fileName, content);
        Test.stopTest();

        System.assertEquals(1, predictions.size(), 'There should be one prediction');
        // As the label is randomly selected from a list of 3, we can only assert the label is not null
        System.assertNotEquals(null, predictions[0].label, 'The label should be randomly selected and not null');
    }
}
