/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventRegistrationUtilTest
{
    private static final Integer NUM_EVENTS = 40;

    @isTest
    static void test_createLogginRecords_OK()
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

        List<LogRecord__c> resultingLogRecords;

        Test.startTest();
        resultingLogRecords = LogEventRegistrationUtil.createLogginRecords(newEventLogs);
        Test.stopTest();

        Assert.isTrue(resultingLogRecords != null       , 'El método tendría que haber devuelvo una lista');
        Assert.isTrue( ! resultingLogRecords.isEmpty()  , 'La lista no puede estar vacía');

        String faultTestMessage = 'El valor de este campo no se ha trasladado correctamente al registro';

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

    @isTest
    static void test_createLogginRecords_NullParam_OK()
    {
        List<LogRecord__c> testLogs;

        Test.startTest();
        testLogs = LogEventRegistrationUtil.createLogginRecords(null);
        Test.stopTest();

        Assert.isTrue(testLogs != null      , 'El método no debería devolver un null');
        Assert.isTrue(testLogs.isEmpty()    , 'La lista de elementos debería estar vacío');
    }


    @isTest
    static void test_createLogginRecords_EmptyList_OK()
    {
        List<LogRecord__c> testLogs;

        Test.startTest();
        testLogs = LogEventRegistrationUtil.createLogginRecords(new List<Log__e>());
        Test.stopTest();

        Assert.isTrue(testLogs != null      , 'El método no debería devolver un null');
        Assert.isTrue(testLogs.isEmpty()    , 'La lista de elementos debería estar vacío');
    }
}