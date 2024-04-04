
@isTest
public class HandlerDashboard_1_Tests {

    static Id createTestFolder(String folderName) {
        Folder testFolder = new Folder(Name = folderName, DeveloperName = folderName, AccessType = 'Public', Type = 'Dashboard');
        insert testFolder;
        return testFolder.Id;
    }
    
    static void createTestDashboards(String dashboardName, Id folderId) {
        Dashboard testDashboard = new Dashboard(
            DeveloperName = dashboardName,
            Title = dashboardName + ' Title',
            FolderId = folderId
        );
        insert testDashboard;
    }

    @isTest
    static void testHandleWithValidSearchKey() {
        // Arrange
        Id salesFolderId = createTestFolder('Sales');
        createTestDashboards('SalesDashboard', salesFolderId);
        
        HandlerDashboard handler = new HandlerDashboard();
        String[] params = new String[]{'SalesDashboard'};
        Map<String, String> session = new Map<String, String>();

        // Act
        BotResponse response = handler.handle('search', params, session, null, null);

        // Assert
        System.assertNotEquals(null, response, 'Response should not be null');
        BotMessage message = response.getMessage();
        System.assertNotEquals(null, message.getRecords(), 'Record list should not be null');
        System.assertTrue(message.getRecords().size() > 0, 'At least one record should be returned for "SalesDashboard" keyword');
    }
    
    @isTest
    static void testHandleWithNoMatchingDashboards() {
        // Arrange
        Id marketingFolderId = createTestFolder('Marketing');
        createTestDashboards('MarketingDashboard', marketingFolderId);

        HandlerDashboard handler = new HandlerDashboard();
        String[] params = new String[]{'NonexistentDashboard'};
        Map<String, String> session = new Map<String, String>();

        // Act
        BotResponse response = handler.handle('search', params, session, null, null);
        
        // Assert
        System.assertNotEquals(null, response, 'Response should not be null');
        BotMessage message = response.getMessage();
        System.assertNotEquals(null, message.getRecords(), 'Record list should not be null');
        System.assertEquals(0, message.getRecords().size(), 'Should return no records for non-existent dashboard keyword');
    }
    
    @isTest
    static void testHandleWithInvalidParams() {
        // Arrange
        Id salesFolderId = createTestFolder('Sales');
        createTestDashboards('SalesDashboard', salesFolderId);

        HandlerDashboard handler = new HandlerDashboard();
        String[] params = null; // Invalid params
        Map<String, String> session = new Map<String, String>();

        // Act and Assert
        try {
            BotResponse response = handler.handle('search', params, session, null, null);
            System.fail('An exception should have been thrown due to null params');
        } catch (Exception e) {
            String expectedMessage = 'Argument 1 cannot be null';
            System.assertEquals(expectedMessage, e.getMessage(), 'Exception message should match expected message');
        }
    }
}
