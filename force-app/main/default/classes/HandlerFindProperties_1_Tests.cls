
@isTest
private class HandlerFindProperties_1_Tests {
    private static void bypassTriggers() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @testSetup
    static void setup() {
        bypassTriggers();
        // No specific setup data required for these tests as they do not depend on database records.
    }

    @isTest
    static void testInitialSessionNull() {
        HandlerFindProperties handler = new HandlerFindProperties();
        BotResponse response = handler.handle(null, null, null, null, null);
        // Replace <<messageProperty>> and <<textProperty>> with actual property or method names
        System.assertEquals('What City?', response.<<messageProperty>>.<<textProperty>>);
        System.assertNotNull(response.session);
    }

    @isTest
    static void testStepCity() {
        HandlerFindProperties handler = new HandlerFindProperties();
        Map<String, String> session = new Map<String, String>{
            'step' => 'city'
        };
        BotResponse response = handler.handle('San Francisco', null, session, null, null);
        // Replace <<messageProperty>> and <<textProperty>> with actual property or method names
        System.assertEquals('What type of property?', response.<<messageProperty>>.<<textProperty>>);
        System.assertEquals('type', response.session.get('step'));
    }

    @isTest
    static void testStepType() {
        HandlerFindProperties handler = new HandlerFindProperties();
        Map<String, String> session = new Map<String, String>{
            'step' => 'type',
            'city' => 'San Francisco'
        };
        BotResponse response = handler.handle('Condominium', null, session, null, null);
        // Replace <<messageProperty>> and <<textProperty>> with actual property or method names
        System.assertEquals('Price range from?', response.<<messageProperty>>.<<textProperty>>);
        System.assertEquals('minPrice', response.session.get('step'));
    }

    @isTest
    static void testStepMinPrice() {
        HandlerFindProperties handler = new HandlerFindProperties();
        Map<String, String> session = new Map<String, String>{
            'step' => 'minPrice',
            'city' => 'San Francisco',
            'type' => 'Condominium'
        };
        BotResponse response = handler.handle('500000', null, session, null, null);
        // Replace <<messageProperty>> and <<textProperty>> with actual property or method names
        System.assertEquals('Price range to?', response.<<messageProperty>>.<<textProperty>>);
        System.assertEquals('maxPrice', response.session.get('step'));
    }

    @isTest
    static void testStepMaxPriceWithProperties() {
        bypassTriggers();
        // Assuming there are properties set up in the @testSetup method
        HandlerFindProperties handler = new HandlerFindProperties();
        Map<String, String> session = new Map<String, String>{
            'step' => 'maxPrice',
            'city' => 'San Francisco',
            'type' => 'Condominium',
            'minPrice' => '500000'
        };
        BotResponse response = handler.handle('1000000', null, session, null, null);
        // Replace <<messageProperty>>, <<textProperty>>, and <<recordsProperty>> with actual property or method names
        System.assert(response.<<messageProperty>>.<<textProperty>>.contains('Here is a list of properties in San Francisco between'));
        System.assertNotNull(response.<<messageProperty>>.<<recordsProperty>>);
    }

    @isTest
    static void testInvalidStep() {
        HandlerFindProperties handler = new HandlerFindProperties();
        Map<String, String> session = new Map<String, String>{
            'step' => 'invalidStep'
        };
        BotResponse response = handler.handle('Some input', null, session, null, null);
        // Replace <<messageProperty>> and <<textProperty>> with actual property or method names
        System.assertEquals('Sorry, I don\'t know how to handle that', response.<<messageProperty>>.<<textProperty>>);
    }
}
