
@isTest
static void testPredictDemoWithRandomCategory() {
    // Add logic to disable/bypass triggers if applicable
    
    List<EinsteinVisionController.Prediction> predictions = EinsteinVisionController.predict('random.jpg', 'testContent', null);
    System.assertEquals(1, predictions.size(), 'Should return exactly one prediction');

    // Get the label from the prediction
    String expectedLabel = predictions[0].label;

    // List of predefined categories
    List<String> categories = new List<String>{'Victorian', 'Colonial', 'Contemporary'};

    // Check if the label is one of the predefined categories
    Boolean labelMatches = categories.contains(expectedLabel);
    System.assert(labelMatches, 'The label should be one of the predefined categories: ' + String.join(categories, ', '));
}
