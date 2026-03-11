/**
 * @description       : Logger class that sends a Platform Event with useful debugging data. Use the appropriate method to publish a message to the Event Bus.
 * @author            : jgallaga
 * @group             : NTS
 * @last modified on  : 29/03/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   15/02/2022   jgallaga   Initial Version
**/
global without sharing class Logger
{
    private Log__e eventRecord;
    private System.LoggingLevel debugLevel;

    public Logger()
    {
        eventRecord = new Log__e();
        eventRecord.UserId__c                 = UserInfo.getUserId();
        eventRecord.TransactionId__c          = System.Request.getCurrent().getRequestId();
        eventRecord.PublishedTime__c          = Datetime.now();

        debugLevel = System.LoggingLevel.DEBUG;
    }

    public Log__e getEventRecord()
    {
        return eventRecord;
    }


    public Logger message(String message)
    {
        eventRecord.message__c = message;
        return this;
    }

    public Logger exception(Exception exceptionError)
    {
        return this;
    }

    public Logger sourceClass(String className)
    {
        eventRecord.sourceClass__c = className;
        return this;
    }

    public Logger dmlException(DMLException dmlError)
    {
        // List<Database.SaveResult> publishResults = new List<Database.SaveResult>();

        // Database.SaveResult dmlEventPublish;
        // dmlEventPublish= send(dmlError.getMessage(), 'DML Exception', dmlError.getTypeName(), dmlError.getLineNumber(), dmlError.getStackTraceString(), null, null);

        // publishResults.add(dmlEventPublish);

        // for(Integer i = 0; i < dmlError.getNumDml(); i++)
        // {
        //     dmlEventPublish = send(dmlError.getDmlMessage(i), 'DML Exception', dmlError.getDmlType(i).name(), dmlError.getLineNumber(), dmlError.getStackTraceString(), dmlError.getDmlId(i), dmlError.getDmlFieldNames(i).toString());
        //     publishResults.add(dmlEventPublish);
        // }

        return this;
    }

    global Logger emailException(EmailException dmlError)
    {
        // List<Database.SaveResult> publishResults = new List<Database.SaveResult>();

        // Database.SaveResult emailEventPublish;
        // emailEventPublish = send(dmlError.getMessage(), 'Email Exception', dmlError.getTypeName(), dmlError.getLineNumber(), dmlError.getStackTraceString(), null, null);
        // publishResults.add(emailEventPublish);

        // for(Integer i = 0; i < dmlError.getNumDml(); i++)
        // {
        //     emailEventPublish = send(dmlError.getDmlMessage(i), 'Email Exception', dmlError.getDmlType(i).name(), dmlError.getLineNumber(), dmlError.getStackTraceString(), dmlError.getDmlId(i), dmlError.getDmlFieldNames(i).toString());
        //     publishResults.add(emailEventPublish);
        // }

        return this;
    }

    private Logger writeDebug()
    {
        if(debugLevel == null)
        {
            debugLevel = System.LoggingLevel.DEBUG;
        }

        System.debug(debugLevel, eventRecord.message__c);
        return this;
    }
}