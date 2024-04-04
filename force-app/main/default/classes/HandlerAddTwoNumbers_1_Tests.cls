
@isTest
private class HandlerAddTwoNumbers_1_Tests {

    @isTest
    static void testInitialSessionNull() {
        // Given
        String utterance = null;
        String[] params = new String[] {};
        Map<String, String> session = null;
        String fileName = null;
        String fileContent = null;

        // When
        BotResponse response = new HandlerAddTwoNumbers().handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertEquals('What\'s the first number?', response.botMessage.text, 'The bot should ask for the first number');
        System.assertEquals('HandlerAddTwoNumbers', response.session.get('nextCommand'), 'The next command should be set correctly');
    }

    @isTest
    static void testAskSecondNumber() {
        // Given
        String utterance = '5';
        String[] params = new String[] {};
        Map<String, String> session = new Map<String, String>{
            'nextCommand' => 'HandlerAddTwoNumbers',
            'step' => 'askFirstNumber'
        };
        String fileName = null;
        String fileContent = null;

        // When
        BotResponse response = new HandlerAddTwoNumbers().handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertEquals('What\'s the second number?', response.botMessage.text, 'The bot should ask for the second number');
        System.assertEquals('5', session.get('firstNumber'), 'First number should be stored in the session');
    }

    @isTest
    static void testCalculateTotal() {
        // Given
        String utterance = '8';
        String[] params = new String[] {};
        Map<String, String> session = new Map<String, String>{
            'nextCommand' => 'HandlerAddTwoNumbers',
            'step' => 'askSecondNumber',
            'firstNumber' => '5'
        };
        String fileName = null;
        String fileContent = null;

        // When
        BotResponse response = new HandlerAddTwoNumbers().handle(utterance, params, session, fileName, fileContent);

        // Then
        System.assertEquals('5 + 8 = 13', response.botMessage.text, 'The bot should display the addition result');
    }

    // As the original target source code does not provide error handling for invalid steps or invalid number input,
    // the testInvalidStep and testInvalidNumberInput methods are not applicable here.
}
