/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-30-2023
 * @last modified by  : Gurkgamer
**/
@IsTest
public with sharing class LogEventBuilderHelperTest
{
    @IsTest
    static void testCreateLogEventBuilder()
    {
        Test.startTest();

        LogEventBuilder builder = LogEventBuilderHelper.createLogEventBuilder('Test Message');

        Test.stopTest();

        Assert.isTrue(builder != null);
    }

    @IsTest
    static void testPublish()
    {
        // Add LogEventBuilders to the helper
        LogEventBuilderHelper.appendLogEventBuilder(new LogEventBuilder('Event 1'));
        LogEventBuilderHelper.appendLogEventBuilder(new LogEventBuilder('Event 2'));

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
    static void testAppendLogEventBuilder()
    {
        // Test the appendLogEventBuilder method
        LogEventBuilder builder = new LogEventBuilder('Test Message');

        Test.startTest();

        LogEventBuilderHelper.appendLogEventBuilder(builder);

        Test.stopTest();

        Assert.isTrue(LogEventBuilderHelper.builtLogEventBuilders.contains(builder));
    }

    @IsTest
    static void testResetLogEvents()
    {
        // Test the resetLogEvents method
        LogEventBuilder builder = new LogEventBuilder('Test Message');

        Test.startTest();

        LogEventBuilderHelper.appendLogEventBuilder(builder);
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
        LogEventBuilder builder1 = LogEventBuilderHelper.createLogEventBuilder('Event 1');
        LogEventBuilder builder2 = LogEventBuilderHelper.createLogEventBuilder('Event 2');

        // Append additional LogEventBuilder
        LogEventBuilder builder3 = new LogEventBuilder('Event 3');
        LogEventBuilderHelper.appendLogEventBuilder(builder3);

        Assert.areEqual(3, LogEventBuilderHelper.builtLogEventBuilders.size());

        // Publish events
        List<Database.SaveResult> publishResults = LogEventBuilderHelper.publish();

        Test.stopTest();

        // Assertions
        System.assertEquals(3, publishResults.size());

        for (Database.SaveResult result : publishResults)
        {
            Assert.isTrue(result.isSuccess());
        }

        Assert.isTrue(LogEventBuilderHelper.builtLogEventBuilders.isEmpty());
    }
}