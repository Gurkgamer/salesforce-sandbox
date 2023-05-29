/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-29-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class PlatformEventBatchBuilder
{

    private static List<LogEventBuilder> events = new List<LogEventBuilder>();

    public static LogEventBuilder newLogEvent(String message)
    {
        LogEventBuilder newEventInstance = new LogEventBuilder(message);
        events.add(newEventInstance);

        return newEventInstance;
    }

    public static List<Database.SaveResult> publish()
    {
        List<Log__e> eventsToPublish = new List<Log__e>();

        for(LogEventBuilder nextEventInBatch : events)
        {
            eventsToPublish.add(nextEventInBatch.build());
        }

        return Eventbus.publish(eventsToPublish);
    }
}