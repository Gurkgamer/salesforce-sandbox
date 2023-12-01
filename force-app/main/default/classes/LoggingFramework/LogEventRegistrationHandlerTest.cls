/**
 * @description       : Test class that verifies the functional part of the trigger handler for the events.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 12-01-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventRegistrationHandlerTest
{
    private static final Integer NUM_EVENTS = 30;

    /**
     * @description Tests the insertion of a single event and verifies its functionality in the trigger handler.
     */
    @isTest
    static void test_InsertOneEvent_OK()
    {
        Log__e testEvent = new Log__e();

        testEvent.Message__c = 'Test Message!';

        Test.startTest();
        Database.SaveResult publishResult = Eventbus.publish(testEvent);
        Test.stopTest();

        Assert.isTrue(publishResult.isSuccess() , 'The event publishing should not have thrown an error');

        List<LogRecord__c> resultado = [SELECT Message__c FROM LogRecord__c];

        Assert.isTrue( ! resultado.isEmpty()    , 'The record that was supposed to be created does not exist');
        Assert.areEqual(1, resultado.size()     , 'The number of records does not match the expected count.');
        Assert.areEqual(testEvent.Message__c, resultado.get(0).Message__c   , 'The message should be the same');
    }

    /**
     * @description Tests the successful insertion of multiple events.
     *              Publishes a list of Log__e events and verifies that the corresponding
     *              LogRecord__c records are created with the expected values.
     *              The test checks for the successful event publication, the existence of
     *              the created records, the correct number of records, and matching message values.
    **/
    @isTest
    static void test_InsertMultipleEvents_OK()
    {
        List<Log__e> testEvents = new List<Log__e>();

        for(Integer i = 0; i < NUM_EVENTS ; i++)
        {
            Log__e newEvent = new Log__e();
            newEvent.Message__c = 'Test' + i;

            testEvents.add(newEvent);
        }

        Test.startTest();
        List<Database.SaveResult> publishResults = Eventbus.publish(testEvents);
        Test.stopTest();

        for(Database.SaveResult nextSR : publishResults)
        {
            Assert.isTrue(nextSR.isSuccess() , 'The event publication should not have thrown an error');
        }

        List<LogRecord__c> resultado = [SELECT Message__c FROM LogRecord__c];

        Assert.isTrue   ( ! resultado.isEmpty()            , 'The record that was supposed to be created does not exist');
        Assert.areEqual (NUM_EVENTS, resultado.size()    , 'The number of records does not match the expected count');

        for(Integer j = 0; j < resultado.size(); j++)
        {
            Assert.areEqual('Test' + j, resultado.get(j).Message__c   , 'The message should be the same');
        }
    }

    @isTest
    static void test_afterinsert_NULL_OK()
    {
        Test.startTest();
        try
        {
            LogEventRegistrationHandler.afterinsert(null);
        }
        catch(Exception error)
        {
            Assert.fail('El método no debería dar una excepción');
        }
        Test.stopTest();

        List<LogRecord__c> testLogs = [SELECT Id FROM LogRecord__c];

        Assert.isTrue(testLogs.isEmpty(), 'No deberían existir Logs en este test');
    }
}