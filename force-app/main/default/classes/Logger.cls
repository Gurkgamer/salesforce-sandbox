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

    /**
    * @author       jgallaga | 08/03/2022
    * @description
                    This variable contains the setup entries for the Logger.
                    Mostly used to check if the Logger or the Debug is enabled.
    * @return       Map<String, LogSetup__mdt>
    **/
    @TestVisible
    private static Map<String, LogSetup__mdt> logSetup
    {
        get
        {
            if(logSetup == null)
            {
                logSetup = new Map<String, LogSetup__mdt>();
                for(LogSetup__mdt nextSetup : LogSetup__mdt.getAll().values())
                {
                    logSetup.put(nextSetup.developerName, nextSetup);
                }
            }
            return logSetup;
        }
        set;
    }

    //#region log - These are sent to the platform event and written to system.debug if enabled

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the message and writes to the system log
     * @param       String
     *                  The message String
     * @return      Database.SaveResult
     *                  The Event publication result
     */
    global static Database.SaveResult log(String message)
    {
        return log(message, System.LoggingLevel.DEBUG, null);
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the message and Log Type. Writes to the system log.
     * @param       String
     *                  The message String
     * @param       String
     *                  Used to describe the kind of execution the log is working at
     * @return      Database.SaveResult
     *                  The Event publication result
     */
    global static Database.SaveResult log(String message, String logType)
    {
        return log(message, System.LoggingLevel.DEBUG, logType);
    }


    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the message and Log Type. Writes to the system log.
     * @param       String
     *                  The message String
     * @param       System.LoggingLevel
     *                  The message of the log will be written to system debug with this System debug level.
     * @return      Database.SaveResult
     *                  The Event publication result
     */
    global static Database.SaveResult log(String message, System.LoggingLevel level)
    {
        return log(message, level, null);
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the information contained in the Exception. This does not write to the System debug log.
     * @param       Exception
     *                  The exception to log
     * @return      Database.SaveResult
     *                  The Event publication result
     */
    global static Database.SaveResult log(Exception error)
    {
        return send(error.getMessage(), 'Exception',  error.getTypeName(), error.getLineNumber(), error.getStackTraceString(), null, null);
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the information contained in the DML Exception. This does not write to the System debug log.
     *              A DML Exception cointains an entry for each record that made an error. The Logger will send a first event for the Main Exception
     *              and after an event for each invidual record entry that failed.
     * @param       DMLException
     *                  The exception to log
     * @return      Database.SaveResult
     *                  The Event publication result of the main Exception.
     */
    global static List<Database.SaveResult> log(DMLException dmlError)
    {
        List<Database.SaveResult> publishResults = new List<Database.SaveResult>();

        Database.SaveResult dmlEventPublish;
        dmlEventPublish= send(dmlError.getMessage(), 'DML Exception', dmlError.getTypeName(), dmlError.getLineNumber(), dmlError.getStackTraceString(), null, null);

        publishResults.add(dmlEventPublish);

        for(Integer i = 0; i < dmlError.getNumDml(); i++)
        {
            dmlEventPublish = send(dmlError.getDmlMessage(i), 'DML Exception', dmlError.getDmlType(i).name(), dmlError.getLineNumber(), dmlError.getStackTraceString(), dmlError.getDmlId(i), dmlError.getDmlFieldNames(i).toString());
            publishResults.add(dmlEventPublish);
        }

        return publishResults;
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the information contained in the DML Exception. This does not write to the System debug log.
     *              A Email Exception cointains an entry for each email that could not be sent. The Logger will send a first event for the Main Exception
     *              and after an event for each invidual email that failed.
     * @param       EmailException
     *                  The exception to log
     * @return      Database.SaveResult
     *                  The Event publication result of the main Exception.
     */
    global static List<Database.SaveResult> log(EmailException dmlError)
    {
        List<Database.SaveResult> publishResults = new List<Database.SaveResult>();

        Database.SaveResult emailEventPublish;
        emailEventPublish = send(dmlError.getMessage(), 'Email Exception', dmlError.getTypeName(), dmlError.getLineNumber(), dmlError.getStackTraceString(), null, null);
        publishResults.add(emailEventPublish);

        for(Integer i = 0; i < dmlError.getNumDml(); i++)
        {
            emailEventPublish = send(dmlError.getDmlMessage(i), 'Email Exception', dmlError.getDmlType(i).name(), dmlError.getLineNumber(), dmlError.getStackTraceString(), dmlError.getDmlId(i), dmlError.getDmlFieldNames(i).toString());
            publishResults.add(emailEventPublish);
        }

        return publishResults;
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Sends a Platform Event with the information contained in the DML Exception. This does not write to the System debug log.
     *              A Email Exception cointains an entry for each email that could not be sent. The Logger will send a first event for the Main Exception
     *              and after an event for each invidual email that failed.
     * @param       EmailException
     *                  The exception to log
     * @return      Database.SaveResult
     *                  The Event publication result of the main Exception.
     */
    global static Database.SaveResult log(String message, System.LoggingLevel level, String logType)
    {
        if(isDebugOn())
        {
            writeDebug(level, message);
        }

        if(isLoggerOn())
        {
           return send(message, logType, null, null, null, null, null);
        }

        return null;
    }

    //#endregion

    //#region util

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              If needed, the Logger functionality to send Platform Events can be disabled.
     *              In the event of missing the configuration entry at metadata,
     *              by default the Logger will be disabled and a message will be written to the system debug.
     * @return      Boolean
     *                  Tells if the Event publication functionality is enabled
     */
    private static Boolean isLoggerOn()
    {
        if(!logSetup.containsKey('EnableLogger') || String.isBlank(logSetup.get('EnableLogger').Value__c))
        {
            writeDebug(System.LoggingLevel.ERROR, 'The Setup entry for EnableLogger is missing');
            return false;
        }

        return logSetup.get('EnableLogger').Value__c == '1' ? true : false;
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              If needed, the debug message written to the system logs can be disabled.
     *              In the event of missing the configuration entry at metadata,
     *              by default the debug will be disabled and a message will be written to the system debug.
     * @return      Boolean
     *                  Tells if the writting to the System debug is enabled
     */
    private static Boolean isDebugOn()
    {
        if(!logSetup.containsKey('EnableSFLog') || String.isBlank(logSetup.get('EnableSFLog').Value__c))
        {
            writeDebug(System.LoggingLevel.ERROR, 'The Setup entry for EnableSFLog is missing');
            return false;
        }

        return logSetup.get('EnableSFLog').Value__c == '1' ? true : false;
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              Writes a message to the System logs.
     *              If the level is null, it will default to DEBUG logging level
     * @param       System.LoggingLevel
     *                  The log is written in this Logging level
     * @param       String
     *                  The message that will be written
     */
    private static void writeDebug(System.LoggingLevel level, String message)
    {
        if(level == null)
        {
            level = System.LoggingLevel.DEBUG;
        }

        System.debug(level, message);
    }

    /**
     * @author      jgallaga
     * @date        08/03/2022
     * @description
     *              The parameters received will be sent as a Platform Event.
     *              The event is published to the Salesforce Event Bus.
     * @param       System.LoggingLevel
     *                  The log is written in this Logging level
     * @param       String
     *                  The message that will be written
     */
    private static Database.SaveResult send(String message, String logType, String exceptionType, Integer exceptionLine, String exceptionStackTrace, String exceptionRecordId, String exceptionFields)
    {
        Log__e event = new Log__e();

        // TODO - Comprobar que no pasa nada si se pasan string demasiado grandes, truncar si hay pegas

        event.UserId__c                 = UserInfo.getUserId();
        event.TransactionId__c          = System.Request.getCurrent().getRequestId();
        event.PublishedTime__c          = Datetime.now();
        event.Message__c                = message;
        event.LogType__c                = logType;
        event.ExceptionType__c          = exceptionType;
        event.ExceptionLine__c          = String.valueOf(exceptionLine);
        event.ExceptionStackTrace__c    = exceptionStackTrace;
        event.RecordId__c               = exceptionRecordId;
        event.ExceptionDMLFields__c     = exceptionFields;

        return Eventbus.publish(event);
    }

    //#endregion
}