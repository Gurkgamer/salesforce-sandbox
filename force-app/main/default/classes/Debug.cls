public without sharing class Debug
{
    private static List<Logger> loggerRecords = new List<Logger>();

    public static Logger log(Strnig message)
    {
        Logger newLogEvent = new Logger();
        newLogEvent.message(message);
        loggerRecords.add(newLogEvent);
        return newLogEvent;
    }

    public static void publish()
    {
        List<Log__e> logEventRecords = new List<Log__e>();
        for(Logger nextLogEvent : loggerRecords)
        {
            logEventRecords.add(nextLogEvent.getEventRecord());
        }

        EventBus.publish(logEventRecords);
        loggerRecords.clear();
    }
}