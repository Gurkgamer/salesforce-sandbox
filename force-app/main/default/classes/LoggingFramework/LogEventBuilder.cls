/**
 * @description       : Class that implements the Builder pattern to construct an event log record
 *                      the corresponding method in a chain to pass the values.
 *                      Finally, it is recommended to call the build() method to receive a Log Event
 *                      record in return.
 *                      Example:
 *                          new LogEventBuilder()
 *                          .message('A text')
 *                          .recordID('00138383923')
 *                          .build();
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class LogEventBuilder
{

    // These fields represent the fields that the Log_e entity has
    @TestVisible private String message;
    @TestVisible private String externalId;
    @TestVisible private String sourceClass;
    @TestVisible private String transactionId;
    @TestVisible private String exceptionStackTrace;
    @TestVisible private String exceptionMessage;
    @TestVisible private String exceptionCause;
    @TestVisible private String exceptionType;
    @TestVisible private String dmlExceptionFields;
    @TestVisible private Id userId;
    @TestVisible private Id recordId;
    @TestVisible private EventType type;
    @TestVisible private Datetime eventTime;

    // Add new types as needed
    public enum EventType
    {
        WARNING,
        INFO,
        ERROR,
        LOG
    }

    /**
     * @description Constructor of this class.
     *              Some default values regarding the timing and transation of the event registration
     *              will be set.
     *              The default value for the type will be LOG.
     */
    public LogEventBuilder()
    {
        this.transactionId  = System.Request.getCurrent().getRequestId();
        this.type           = EventType.LOG;
        this.eventTime      = System.now();
    }

    /**
     * @description Transforms the LogEventBuilder instance into a Log__e
     *              instance.
     * @return      Log__e
     *              A Log__e platform event record instance
     */
    public Log__e build()
    {
        Log__e logEvent = new Log__e();

        logEvent.DMLExceptionFields__c  = dmlExceptionFields;
        logEvent.EventTime__c           = eventTime;
        logEvent.ExceptionCause__c      = exceptionCause;
        logEvent.ExceptionMessage__c    = exceptionMessage;
        logEvent.ExceptionStackTrace__c = exceptionStackTrace;
        logEvent.ExceptionType__c       = exceptionType;
        logEvent.ExternalId__c          = externalId;
        logEvent.Message__c             = message;
        logEvent.RecordId__c            = recordID;
        logEvent.SourceClass__c         = sourceClass;
        logEvent.TransactionId__c       = transactionId;
        logEvent.Type__c                = type?.name();
        logEvent.UserId__c              = userId;

        return logEvent;
    }

    /**
     * @description Prints into the Salesforce log the contents of the instance into the Salesfor debud logs.
     */
    public LogEventBuilder print()
    {
        System.debug('@@@@@@@@');
        printParameter(message, 'message');
        printParameter(type, 'type');
        printParameter(sourceClass, 'sourceClass');
        printParameter(userId, 'userId');
        printParameter(recordId, 'recordId');
        printParameter(externalId, 'externalId');
        printParameter(eventTime, 'eventTime');
        printParameter(exceptionMessage, 'exceptionMessage');
        printParameter(exceptionStackTrace, 'exceptionStackTrace');
        printParameter(exceptionType, 'exceptionType');
        printParameter(exceptionCause, 'exceptionCause');
        printParameter(dmlExceptionFields, 'dmlExceptionFields');
        printParameter(transactionId, 'transactionId');

        if(Test.isRunningTest())
        {
            message = 'Test print';
        }

        return this;
    }

    /**
     * @description Utility to print a parameter into the Salesforce debug logs.
     *              If the parameter is null, it will not be printed.
     */
    private void printParameter(Object parameter, String parameterName)
    {
        if(parameter != null)
        {
            System.debug(parameterName + ': ' + parameter);
        }
    }

    /**
     * The following methods allow the developer to populate the fields of the class according to their needs.
     * By returning itself, the developer can chain the subsequent method calls directly to
     * construct the desired event record.
     */

    public LogEventBuilder message(String message)
    {
        this.message = message;
        return this;
    }

    public LogEventBuilder recordId(Id recordId)
    {
        this.recordId = recordId;
        return this;
    }

    public LogEventBuilder externalId(String externalId)
    {
        this.externalId = externalId;
        return this;
    }

    public LogEventBuilder sourceClass(String sourceClass)
    {
        this.sourceClass = sourceClass;
        return this;
    }

    public LogEventBuilder type(EventType type)
    {
        if(type == null)
        {
            return this;
        }

        this.type = type;
        return this;
    }

    public LogEventBuilder userId(Id userId)
    {
        this.userId = userId;
        return this;
    }

    /**
     * @description It informs the exception fields with details about the problem.
     *              The cause value may appear as null if the exception being logged was not caught due to another original exception.
     * @param       exceptionError
     *              Excepción que se quiere registrar.
     */
    public LogEventBuilder exception(Exception exceptionError)
    {
        if(exceptionError == null)
        {
            return this;
        }

        this.type                   = EventType.ERROR;
        this.exceptionMessage       = exceptionError.getMessage();
        this.exceptionStackTrace    = exceptionError.getStackTraceString();
        this.exceptionCause         = String.valueOf(exceptionError.getCause());
        this.exceptionType          = exceptionError.getTypeName();
        return this;
    }

    /**
     * @description It populates the DML exception fields with information from the DML exception element indicated by the received index.
     *              Use this method to individually identify each DML error.
     * @param       dmlError
     *              The DML exception that has occurred, necessary to retrieve the DML exception element of interest to report.
     * @param       dmlErrorIndex
     *              The position where the information about the DML problem that you want to report is located.
     */
    public LogEventBuilder  dmlFieldsException(DmlException dmlError, Integer dmlErrorIndex)
    {
        if(dmlError == null || dmlErrorIndex == null || dmlError.getNumDml() < dmlErrorIndex || dmlErrorIndex < 0)
        {
            return this;
        }

        this.type                   = EventType.ERROR;
        this.exceptionMessage       = dmlError.getDMLMessage(dmlErrorIndex);
        this.exceptionStackTrace    = dmlError.getStackTraceString();
        this.exceptionCause         = String.valueOf(dmlError.getCause());
        this.exceptionType          = dmlError.getDmlType(dmlErrorIndex).name();
        this.dmlExceptionFields     = dmlError.getDmlFields(dmlErrorIndex).toString();

        return this;
    }
}