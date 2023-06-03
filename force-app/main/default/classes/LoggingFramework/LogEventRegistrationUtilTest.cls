/**
 * @description       : Tests for LogEventRegistration class.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 06-03-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventRegistrationUtilTest
{
    private static final Integer NUM_EVENTS = 40;

    /**
     * @description Tests the transformation from a list of Log__e record to a LogRecord__c list.
     */
    @isTest
    static void test_createLoggingRecords_OK()
    {
        List<Log__e> newEventLogs = new List<Log__e>();

        String testDMLExceptionFields   = 'Fields';
        Datetime testEventTime          = System.now();
        String testExceptionCause       = 'This cause';
        String testExceptionMessage     = 'This exception message';
        String testExceptionStackTrace  = 'Error in this place';
        String testExceptionType        = 'Exception type';
        String testExternalId           = 'EXT00000';
        String testMessage              = 'TestMessage';
        String testRecordId             = '001A0A0A0A0A0A';
        String testSourceClass          = 'LogEventRegistrationUtilTest';
        String testTransactionId        = 'NUMBER';
        String testType                 = 'INFO';
        String testUserId               = '002002020200';


        for(Integer i = 0 ; i < NUM_EVENTS; i++)
        {
            Log__e newEvent = new Log__e();

            newEvent.DMLExceptionFields__c  = testDMLExceptionFields;
            newEvent.EventTime__c           = testEventTime;
            newEvent.ExceptionCause__c      = testExceptionCause;
            newEvent.ExceptionMessage__c    = testExceptionMessage;
            newEvent.ExceptionStackTrace__c = testExceptionStackTrace;
            newEvent.ExceptionType__c       = testExceptionType;
            newEvent.ExternalId__c          = testExternalId + i;
            newEvent.Message__c             = testMessage;
            newEvent.RecordId__c            = testRecordId + i;
            newEvent.SourceClass__c         = testSourceClass;
            newEvent.TransactionId__c       = testTransactionId + i;
            newEvent.Type__c                = testType;
            newEvent.UserId__c              = testUserId + i;

            newEventLogs.add(newEvent);
        }


        Test.startTest();
        List<LogRecord__c> resultingLogRecords = LogEventRegistrationUtil.createLoggingRecords(newEventLogs);
        Test.stopTest();

        Assert.isTrue(resultingLogRecords != null       , 'The method must recturn a lista');
        Assert.isTrue( ! resultingLogRecords.isEmpty()  , 'The list can not be empty');
        Assert.areEqual(NUM_EVENTS, resultingLogRecords.size(), 'The number of records transformed should match');

        String faultTestMessage = 'The value of this field has not been transferred correctly to the record';

        for(Integer j = 0; j < resultingLogRecords.size(); j++)
        {
            LogRecord__c testLog = resultingLogRecords.get(j);

            Assert.areEqual(testDMLExceptionFields  , testLog.DMLExceptionFields__c     , faultTestMessage);
            Assert.areEqual(testEventTime           , testLog.EventTime__c              , faultTestMessage);
            Assert.areEqual(testExceptionCause      , testLog.ExceptionCause__c         , faultTestMessage);
            Assert.areEqual(testExceptionMessage    , testLog.ExceptionMessage__c       , faultTestMessage);
            Assert.areEqual(testExceptionStackTrace , testLog.ExceptionStackTrace__c    , faultTestMessage);
            Assert.areEqual(testExceptionType       , testLog.ExceptionType__c          , faultTestMessage);
            Assert.areEqual(testExternalId + j      , testLog.ExternalId__c             , faultTestMessage);
            Assert.areEqual(testMessage             , testLog.Message__c                , faultTestMessage);
            Assert.areEqual(testRecordId + j        , testLog.RecordId__c               , faultTestMessage);
            Assert.areEqual(testSourceClass         , testLog.SourceClass__c            , faultTestMessage);
            Assert.areEqual(testTransactionId + j   , testLog.TransactionId__c          , faultTestMessage);
            Assert.areEqual(testType                , testLog.Type__c                   , faultTestMessage);
            Assert.areEqual(testUserId + j          , testLog.UserId__c                 , faultTestMessage);
        }
    }

    /**
     * @description Tests the transformation from a single Log__e record to a LogRecord__c record.
     */
    @isTest
    static void test_createLoggingRecords_SingleEvent_OK()
    {
        Log__e newEvent = new Log__e();

        Test.startTest();
        List<LogRecord__c> resultingLogRecords = LogEventRegistrationUtil.createLoggingRecords(new List<Log__e>{newEvent});
        Test.stopTest();

        Assert.isTrue(resultingLogRecords != null, 'The method must return a list');
        Assert.isTrue(resultingLogRecords.size() == 1, 'The list should contain a single record');
    }

    /**
     * @description Check that after the method is called with a null parameter, the result returned is an empty list
     */
    @isTest
    static void test_createLoggingRecords_NullParam_OK()
    {
        List<LogRecord__c> testLogs;

        Test.startTest();
        testLogs = LogEventRegistrationUtil.createLoggingRecords(null);
        Test.stopTest();

        Assert.isTrue(testLogs != null      , 'The method should not return null');
        Assert.isTrue(testLogs.isEmpty()    , 'The list of elements should be empty.');
    }

    /**
     * @description Checks that fom an empty list, an empty list is returned.
     */
    @isTest
    static void test_createLoggingRecords_EmptyList_OK()
    {
        List<LogRecord__c> testLogs;

        Test.startTest();
        testLogs = LogEventRegistrationUtil.createLoggingRecords(new List<Log__e>());
        Test.stopTest();

        Assert.isTrue(testLogs != null      , 'The method should not return null');
        Assert.isTrue(testLogs.isEmpty()    , 'The list of elements should be empty.');
    }
}