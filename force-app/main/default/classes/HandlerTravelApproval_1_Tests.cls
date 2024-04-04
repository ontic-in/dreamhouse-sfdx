
@isTest
private class HandlerTravelApproval_1_Tests {

    @isTest
    static void testHandle_StartConversation() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        
        // When
        BotResponse response = handler.handle(null, null, null, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('destination', response.session.get('step'), 'The step should be set to destination');
    }
    
    @isTest
    static void testHandle_AskForDestination() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'destination' };
        
        // When
        BotResponse response = handler.handle('New York', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('reason', response.session.get('step'), 'The step should be set to reason');
    }
    
    @isTest
    static void testHandle_AskForReason() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'reason', 'destination' => 'New York' };
        
        // When
        BotResponse response = handler.handle('Customer Facing', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('travelDate', response.session.get('step'), 'The step should be set to travelDate');
    }
    
    @isTest
    static void testHandle_AskForTravelDate() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'travelDate', 'reason' => 'Customer Facing'};
        
        // When
        BotResponse response = handler.handle('2023-05-10', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('airfare', response.session.get('step'), 'The step should be set to airfare');
    }
    
    @isTest
    static void testHandle_AskForAirfare() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'airfare', 'travelDate' => '2023-05-10'};
        
        // When
        BotResponse response = handler.handle('500', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals('hotel', response.session.get('step'), 'The step should be set to hotel');
    }
    
    @isTest
    static void testHandle_AskForHotelCost() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'hotel', 'airfare' => '500'};
        
        // When
        BotResponse response = handler.handle('300', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(null, response.session, 'There should be no session map in the final response');
    }
    
    @isTest
    static void testHandle_InvalidSessionState() {
        // Given
        HandlerTravelApproval handler = new HandlerTravelApproval();
        Map<String, String> session = new Map<String, String>{ 'step' => 'unknown_step'};
        
        // When
        BotResponse response = handler.handle('300', null, session, null, null);
        
        // Then
        System.assertNotEquals(null, response, 'Response should not be null when an unknown step is provided');
        System.assertEquals('OK, I submitted the following travel approval request on your behalf:', response.messages[0].messageText, 'The message text should indicate a travel approval request was submitted');
    }
}
