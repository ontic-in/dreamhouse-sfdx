
@isTest
private class HandlerTravelApproval_1_Tests {
    // Create test data for the tests
    @testSetup
    static void setup() {
        // No specific setup is required since the class does not interact with the database
    }
    
    // Test when session is null and conversation is started
    @isTest
    static void testHandleNullSession() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        BotResponse response = handler.handle(null, null, null, null, null);
        System.assertEquals('Where are you going?', response.message.text, 'Message should prompt for destination');
        System.assertNotNull(response.session, 'Session should not be null');
        System.assertEquals('destination', response.session.get('step'), 'Session step should be set to destination');
    }

    // Test when step is 'destination'
    @isTest
    static void testHandleDestination() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'destination' };
        BotResponse response = handler.handle('New York', null, session, null, null);
        System.assertEquals('What\'s the reason for the trip?', response.message.text, 'Message should prompt for reason');
        System.assertEquals('reason', response.session.get('step'), 'Session step should be set to reason');
    }

    // Test when step is 'reason'
    @isTest
    static void testHandleReason() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'reason' };
        BotResponse response = handler.handle('Customer Facing', null, session, null, null);
        System.assertEquals('When are you leaving?', response.message.text, 'Message should prompt for travel date');
        System.assertEquals('travelDate', response.session.get('step'), 'Session step should be set to travelDate');
    }

    // Test when step is 'travelDate'
    @isTest
    static void testHandleTravelDate() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'travelDate' };
        BotResponse response = handler.handle('2023-05-15', null, session, null, null);
        System.assertEquals('What\'s the estimated airfare cost?', response.message.text, 'Message should prompt for airfare cost');
        System.assertEquals('airfare', response.session.get('step'), 'Session step should be set to airfare');
    }

    // Test when step is 'airfare'
    @isTest
    static void testHandleAirfare() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'airfare' };
        BotResponse response = handler.handle('500', null, session, null, null);
        System.assertEquals('What\'s the estimated hotel cost?', response.message.text, 'Message should prompt for hotel cost');
        System.assertEquals('hotel', response.session.get('step'), 'Session step should be set to hotel');
    }

    // Test when step is 'hotel' and conversation is completed
    @isTest
    static void testHandleHotel() {
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{
            'step' => 'hotel',
            'destination' => 'New York',
            'reason' => 'Customer Facing',
            'travelDate' => '2023-05-15',
            'airfare' => '500'
        };
        BotResponse response = handler.handle('300', null, session, null, null);
        System.assertEquals('OK, I submitted the following travel approval request on your behalf:', response.message.text, 'Message should confirm submission');
        // Verify that the session has the expected values
        System.assertEquals('New York', session.get('destination'), 'Destination should be New York');
        System.assertEquals('Customer Facing', session.get('reason'), 'Reason should be Customer Facing');
        System.assertEquals('2023-05-15', session.get('travelDate'), 'Travel Date should be 2023-05-15');
        System.assertEquals('500', session.get('airfare'), 'Airfare should be 500');
        System.assertEquals('300', session.get('hotel'), 'Hotel should be 300');
    }
}
