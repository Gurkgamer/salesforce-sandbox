/**
 * @description       : Test class to verify the functionality of the LogEventBuilder class.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-31-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventBuilderTest
{
    /**
     * @description This test verifies that after using the different available methods,
     *              the submit method allows the event to be published on the bus without any issues.
     *              We are not concerned with the content of the indicated values.
     */
    @IsTest
    static void test_LogEventBuilder_Build_OK()
    {
        // Create a new LogEventBuilder instance
        LogEventBuilder builder = new LogEventBuilder();

        builder.message('Test message')
            .recordId('7077a00004FVdIXAA1');

        builder.sourceClass('TestClass')
            .type(LogEventBuilder.EventType.WARNING)
            .userId(UserInfo.getUserId());

        // Create and build the log event
        Test.startTest();
        Log__e logEventInstance = builder.build();
        Test.stopTest();

        // Verify the log event was created successfully
        Assert.areEqual('Test message', logEventInstance.Message__c, 'The event was not generated with the expected message');
        Assert.areEqual('7077a00004FVdIXAA1', logEventInstance.RecordId__c, 'The event was not generated with the expected record ID');
        Assert.areEqual('TestClass', logEventInstance.SourceClass__c, 'The event was not generated with the expected source class');
        Assert.areEqual(LogEventBuilder.EventType.WARNING.name(), logEventInstance.Type__c, 'The event was not generated with the expected type');
    }

    /**
     * @description This test verifies that the values passed to the instantiation of an event are correctly assigned to the corresponding fields.
     */
    @isTest
    static void test_LogParameters_Values_OK()
    {
        LogEventBuilder builder = new LogEventBuilder();

        String testText = 'TestMessage';
        String recordId = '7077a00004FVdIXAA1';
        String userId   = '7077a00004FVdIXAA2';
        String externalId = 'PAP0001L';
        String sourceClass = 'TestClass';
        LogEventBuilder.EventType type = LogEventBuilder.EventType.INFO;

        Test.startTest();

        builder.message(testText)
            .recordId(recordID)
            .type(LogEventBuilder.EventType.INFO)
            .sourceClass(sourceClass)
            .userId(userId)
            .externalId(externalId);

        Test.stopTest();

        Assert.areEqual(testText, builder.message, 'The event message is different from the input');
        Assert.areEqual(recordId, builder.recordId, 'The record ID is different from the input');
        Assert.areEqual(userId, builder.userId, 'The user ID is different from the input');
        Assert.areEqual(externalId, builder.externalId, 'The external ID is different from the input');
        Assert.areEqual(sourceClass, builder.sourceClass, 'The source class is different from the input');
        Assert.areEqual(type, builder.type, 'The event type is different from the input');
    }

    /**
     * @description Method that verifies that with the default parameters, that is, only instantiating the class without doing anything else,
     *              the event publication continues to work correctly.
     */
    @isTest
    static void test_DefaultLogParameterValues_Build_OK()
    {
        LogEventBuilder builder = new LogEventBuilder();

        Test.startTest();
        Log__e logEventInstance = builder.build();
        Test.stopTest();

        Assert.isTrue(logEventInstance != null, 'The log event instance should not be null');

        String emptyValue = 'This field should be empty or null';

        Assert.isTrue(String.isNotBlank(logEventInstance.TransactionId__c)      , 'The transaction ID was not automatically populated');
        Assert.areEqual(LogEventBuilder.EventType.LOG.name(), logEventInstance.Type__c , 'The event type did not receive the expected default value');
        Assert.isTrue(logEventInstance.EventTime__c != null                     , 'The event time cannot be empty');
        Assert.isTrue(String.isBlank(logEventInstance.Message__c)               , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExternalId__c)            , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.SourceClass__c)           , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionStackTrace__c)   , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionMessage__c)      , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionCause__c)        , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.DMLExceptionFields__c)    , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.UserId__c)                , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.RecordId__c)              , emptyValue);
    }

    /**
     * @description This test method verifies that the information regarding an exception informs the fields of the event that are prepared to store such data.
     */
    @isTest
    static void test_ExceptionDataParameters_OK()
    {
        LogEventBuilder builder;

        Test.startTest();
        try
        {
            Integer i = 1/0;
        }
        Catch(Exception error)
        {
            builder = new LogEventBuilder().exception(error);

        }
        Test.stopTest();

        String noDataMessage = 'The exception information was not stored correctly';

        Assert.IsTrue(String.isNotBlank(builder.exceptionMessage)   , noDataMessage);
        Assert.IsTrue(String.isNotBlank(builder.exceptionStackTrace), noDataMessage);
        Assert.IsTrue(String.isNotBlank(builder.exceptionType)      , noDataMessage);
        //La causa en esta situación, estará a nulo
        Assert.IsTrue(String.isBlank(builder.exceptionCause)        , 'This field should not have any data');
    }


    /**
     * @description This test verifies that after inserting an exception and publishing the event, no issues occur.
     */
    @isTest
    static void test_ExceptionData_Build_OK()
    {
        Log__e publishResult;

        Test.startTest();
        try
        {
            Integer i = 1/0;
        }
        Catch(Exception error)
        {
            publishResult = new LogEventBuilder().exception(error).build();
        }
        Test.stopTest();

        Assert.IsTrue(publishResult != null   , 'The event publication should not have resulted in an error');
    }

    /**
     * @description This test ensures that after registering all the DML error events, they have been published correctly.
     */
    @isTest
    static void test_DMLExceptionSubmit_OK()
    {
        List<Log__e> dmlsFieldsEventBuilt = new List<Log__e>();

        Test.startTest();
        try
        {
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < 8 ; i++)
            {
                accounts.add(new Account());
            }
            insert accounts;
        }
        Catch(DmlException dmlError)
        {
            dmlsFieldsEventBuilt.add(new LogEventBuilder().exception(dmlError).build());

            for(Integer i = 0; i < dmlError.getNumDml(); i++)
            {
                dmlsFieldsEventBuilt.add(new LogEventBuilder().dmlFieldsException(dmlError, i).build());
            }
        }
        Test.stopTest();

        for(Log__e nextSubmit :dmlsFieldsEventBuilt)
        {
            Assert.isTrue(String.isNotBlank(nextSubmit.ExceptionMessage__c), 'Something caused the event to not be able to be published');
        }
    }

    /**
     * @description Method that verifies that the information about the DML exception is correctly filled in the event logs.
     */
    @isTest
    static void test_DMLExceptionData_OK()
    {
        LogEventBuilder mainDMLException = new LogEventBuilder();
        List<LogEventBuilder> dmlMissingFieldExceptions = new List<LogEventBuilder>();

        Test.startTest();
        try
        {
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < 8 ; i++)
            {
                accounts.add(new Account());
            }
            insert accounts;
        }
        Catch(DmlException dmlError)
        {
            mainDMLException = new LogEventBuilder().exception(dmlError);

            for(Integer i = 0; i < dmlError.getNumDml(); i++)
            {
                dmlMissingFieldExceptions.add(new LogEventBuilder().dmlFieldsException(dmlError, i));
            }
        }
        Test.stopTest();

        String emptyValue = 'This field should be null';

        // Se miran que los campos del DML normal se hayan rellenado
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionMessage)      , 'The exception message should not be blank');
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionStackTrace)   , 'The exception stack trace should not be blank');
        Assert.isTrue(String.isBlank(mainDMLException.exceptionCause)           , emptyValue); // La causa estará a nulo
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionType)         , 'The exception type information should not be blank');
        Assert.isTrue(String.isNotBlank(mainDMLException.transactionId)         , 'The transaction id should have been provided');
        Assert.areEqual(LogEventBuilder.EventType.ERROR, mainDMLException.type  , 'The event type must be ERROR');
        Assert.isTrue(mainDMLException.eventTime != null                        , 'The event time should have been set');

        Assert.isTrue(String.isBlank(mainDMLException.message)              , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.externalId)           , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.sourceClass)          , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.userId)               , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.recordId)             , emptyValue);

        for(LogEventBuilder nextDmlEvent :dmlMissingFieldExceptions)
        {
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionMessage)  , 'The DML exception message should not be blank');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionStackTrace), 'The DML exception stack trace should not be blank');
            Assert.isTrue(String.isBlank(nextDmlEvent.exceptionCause)       , emptyValue); // La causa estará a nulo
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionType)     , 'The DML exception type should not be blank');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.dmlExceptionFields), 'The DML exception fields should be present');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.transactionId)     , 'The transaction id should have been automatically provided');
            Assert.areEqual(LogEventBuilder.EventType.ERROR,nextDmlEvent.type, 'The event type cannot be null');
            Assert.isTrue(nextDmlEvent.eventTime != null                    , 'The event should have the event time field set');

            Assert.isTrue(String.isBlank(nextDmlEvent.message)              , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.externalId)           , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.sourceClass)          , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.userId)               , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.recordId)             , emptyValue);
        }
    }

    /**
     * @description Method to ensure that the functionality of saving specific information of a DML index does not receive incorrect values.
     */
    @IsTest
    static void test_DMLException_WrongIndex_OK()
    {
        LogEventBuilder builder = new LogEventBuilder();

        Test.startTest();
        try
        {
            insert new account();
        }
        catch(DMLException error)
        {
            builder.dmlFieldsException(error,2);
        }
        Test.stopTest();

        String emptyValue = 'This field should be null';

        Assert.isTrue(String.isBlank(builder.exceptionMessage)      , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionStackTrace)   , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionCause)        , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionType)         , emptyValue);
        Assert.isTrue(String.isBlank(builder.dmlExceptionFields)    , emptyValue);
    }

    /**
     * @description This test verifies that if null values are passed to the exception method, nothing will happen.
     *              The fields are not overwritten, and no error is thrown.
     */
    @IsTest
    static void test_NullValuesException_OK()
    {
        LogEventBuilder builder = new LogEventBuilder();

        Test.startTest();
        builder.exception(null);
        Test.stopTest();

        String emptyValue = 'This field should be null';

        Assert.isTrue(String.isBlank(builder.exceptionMessage)      , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionStackTrace)   , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionCause)        , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionType)         , emptyValue);
    }

    /**
     * @description This test verifies that if null values are passed to the DML exception method, nothing will happen.
     *              The fields are not overwritten, and no error is thrown.
     */
    @IsTest
    static void test_NullValuesDMLException_OK()
    {
        LogEventBuilder builder1 = new LogEventBuilder();
        LogEventBuilder builder2 = new LogEventBuilder();
        LogEventBuilder builder3 = new LogEventBuilder();
        LogEventBuilder builder4 = new LogEventBuilder();

        Test.startTest();
        builder1.dmlFieldsException(null,null);
        builder2.dmlFieldsException(new DmlException(),null);
        builder3.dmlFieldsException(null, 1);
        builder4.dmlFieldsException(null, -1);
        Test.stopTest();

        String emptyValue = 'This field should be null';

        Assert.isTrue(String.isBlank(builder1.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder1.dmlExceptionFields)   , emptyValue);

        Assert.isTrue(String.isBlank(builder2.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder2.dmlExceptionFields)   , emptyValue);

        Assert.isTrue(String.isBlank(builder3.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder3.dmlExceptionFields)   , emptyValue);

        Assert.isTrue(String.isBlank(builder4.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder4.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder4.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder4.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder4.dmlExceptionFields)   , emptyValue);
    }

    /**
     * @description Test that ensures the event type cannot be set to null.
     */
    @isTest
    static void test_NullType_OK()
    {
        LogEventBuilder builder = new LogEventBuilder();

        Test.startTest();
        builder.type(null);
        Test.stopTest();

        Assert.areEqual(LogEventBuilder.EventType.LOG, builder.type    , 'The event type should not have been changed');
    }

    /**
     * @description To see if the print method works, a test check will change the message.
     */
    @isTest
    static void test_print_OK()
    {
        String testMessage = 'This is not the test message';
        LogEventBuilder builder = new LogEventBuilder();
        builder.message(testMessage);

        Test.startTest();
        builder.print();
        Test.stopTest();

        Assert.areNotEqual(testMessage, builder.message, 'The message should have changed when testing the debug print');
        Assert.areEqual('Test print', builder.message, 'It is not the message it should have in this test');
    }
}