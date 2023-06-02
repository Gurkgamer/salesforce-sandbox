/**
 * @description       : Test class to verify the functionality of the LogEventBuilderHelper class.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
@IsTest
public with sharing class LogEventBuilderHelperTest
{
    @IsTest
    static void testCreateLogEventBuilder()
    {
        Test.startTest();

        LogEventBuilder builder = LogEventBuilderHelper.createLogEventBuilder();

        Test.stopTest();

        Assert.isTrue(builder != null);
    }

    @IsTest
    static void testPublish()
    {
        // Add LogEventBuilders to the helper
        LogEventBuilderHelper.createLogEventBuilder();
        LogEventBuilderHelper.createLogEventBuilder();

        Test.startTest();

        List<Database.SaveResult> publishResults = LogEventBuilderHelper.publish();

        Test.stopTest();

        Assert.areEqual(2, publishResults.size());

        for (Database.SaveResult result : publishResults)
        {
            Assert.isTrue(result.isSuccess());
        }

        Assert.isTrue(LogEventBuilderHelper.builtLogEventBuilders.isEmpty());
    }

    @IsTest
    static void testResetLogEvents()
    {
        // Test the resetLogEvents method

        Test.startTest();

        LogEventBuilderHelper.createLogEventBuilder();
        System.assert(!LogEventBuilderHelper.builtLogEventBuilders.isEmpty());
        LogEventBuilderHelper.resetLogEvents();

        Test.stopTest();

        System.assert(LogEventBuilderHelper.builtLogEventBuilders.isEmpty());
    }

    // Functional Test
    @IsTest
    static void testLogEventBuilderHelper()
    {
        // Test the LogEventBuilderHelper class functionality

        Test.startTest();

        // Create LogEventBuilders
        LogEventBuilder builder1 = LogEventBuilderHelper.createLogEventBuilder();
        LogEventBuilder builder2 = LogEventBuilderHelper.createLogEventBuilder();

        // Publish events
        List<Database.SaveResult> publishResults = LogEventBuilderHelper.publish();

        Test.stopTest();

        // Assertions
        System.assertEquals(2, publishResults.size());

        for (Database.SaveResult result : publishResults)
        {
            Assert.isTrue(result.isSuccess());
        }

        Assert.isTrue(LogEventBuilderHelper.builtLogEventBuilders.isEmpty());
    }
}