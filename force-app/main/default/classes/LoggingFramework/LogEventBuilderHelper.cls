/**
 * @description       : The LogEventBuilderHelper class provides a convenient way to manage instances of the LogEventBuilder class and publish batches of log events.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 12-02-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class LogEventBuilderHelper
{
    @TestVisible
    private static List<LogEventBuilder> builtLogEventBuilders  = new List<LogEventBuilder>();

    /**
     * @description Creates a new LogEventBuilder instance with the provided message and adds it to the list of events.
     *
     * @param       message
     *              The message for the log event.
     * @return      LogEventBuilder
     *              The newly created LogEventBuilder instance.
     */
    public static LogEventBuilder createLogEventBuilder()
    {
        LogEventBuilder newEventBuilderInstance = new LogEventBuilder();
        builtLogEventBuilders.add(newEventBuilderInstance);

        return newEventBuilderInstance;
    }

    /**
     * @description Prepares the accumulated log events for publishing and publishes them to the Event bus.
     *              The list of record instances will be cleared.
     *
     * @return      List<Database.SaveResult>
     *              A list of Database.SaveResult objects indicating the success or failure of the publish operation.
     */
    public static List<Database.SaveResult> publish()
    {
        List<Log__e> eventsToPublish = new List<Log__e>();

        for(LogEventBuilder nextLogEventBuilder : builtLogEventBuilders)
        {
            eventsToPublish.add(nextLogEventBuilder.build());
        }

        List<Database.SaveResult> publishResults = Eventbus.publish(eventsToPublish);

        //Clean the published events
        resetLogEvents();

        return publishResults;
    }

    /**
     * @description Allows to remove the LogEventBuilder instances that are present in the helper without publishing.
     */
    public static void resetLogEvents()
    {
        builtLogEventBuilders.clear();
    }
}