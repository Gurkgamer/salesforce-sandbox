/**
 * @description       : A utility class for managing Log events in the Log__e platform.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class LogEventRegistrationUtil
{
    /**
     * @description This method, given a list of LogEvent platform events, returns a list of Log records. It transforms the information of each event into a record.
     * @param       platformEvents
     *              List of Log__e platform events
     */
    public static List<LogRecord__c> createLoggingRecords(List<Log__e> platformEvents)
    {
        List<LogRecord__c> logRecords = new List<LogRecord__c>();

        if(platformEvents == null)
        {
            return logRecords;
        }

        for(Log__e nextEvent : platformEvents)
        {
            LogRecord__c nextLog = new LogRecord__c();

            nextLog.DMLExceptionFields__c   = nextEvent.DMLExceptionFields__c;
            nextLog.EventTime__c            = nextEvent.EventTime__c;
            nextLog.ExceptionCause__c       = nextEvent.ExceptionCause__c;
            nextLog.ExceptionMessage__c     = nextEvent.ExceptionMessage__c;
            nextLog.ExceptionStackTrace__c  = nextEvent.ExceptionStackTrace__c;
            nextLog.ExceptionType__c        = nextEvent.ExceptionType__c;
            nextLog.ExternalId__c           = nextEvent.ExternalId__c;
            nextLog.Message__c              = nextEvent.Message__c;
            nextLog.RecordId__c             = nextEvent.RecordId__c;
            nextLog.SourceClass__c          = nextEvent.SourceClass__c;
            nextLog.TransactionId__c        = nextEvent.TransactionId__c;
            nextLog.Type__c                 = nextEvent.Type__c;
            nextLog.UserId__c               = nextEvent.UserId__c;

            logRecords.add(nextLog);
        }

        return logRecords;
    }
}