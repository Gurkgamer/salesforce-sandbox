/**
 * @description       : Clase test que comprueba el la parte funcional del trigger handler para los eventos
 *                      de plataforma.
 * @author            : jgallaga
 * @group             : Seidor
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventRegistrationHandlerTest
{
    private static final Integer NUM_EVENTS = 30;

    @isTest
    static void test_InsertOneEvent_OK()
    {
        Log__e testEvent = new Log__e();

        testEvent.Message__c = 'Test Message!';

        Test.startTest();
        Database.SaveResult publishResult = Eventbus.publish(testEvent);
        Test.stopTest();

        Assert.isTrue(publishResult.isSuccess() , 'La publicación del evento no debería haber dado error');

        List<LogRecord__c> resultado = [SELECT Message__c FROM LogRecord__c];

        Assert.isTrue( ! resultado.isEmpty()    , 'El registro que se tenía que haber creado no existe');
        Assert.areEqual(1, resultado.size()     , 'El número de registros no coincide con el esperado');
        Assert.areEqual(testEvent.Message__c, resultado.get(0).Message__c   , 'El mensaje debería ser el mismo');
    }

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
            Assert.isTrue(nextSR.isSuccess() , 'La publicación del evento no debería haber dado error');
        }

        List<LogRecord__c> resultado = [SELECT Message__c FROM LogRecord__c];

        Assert.isTrue   ( ! resultado.isEmpty()            , 'El registro que se tenía que haber creado no existe');
        Assert.areEqual (NUM_EVENTS, resultado.size()    , 'El número de registros no coincide con el esperado');

        for(Integer j = 0; j < resultado.size(); j++)
        {
            Assert.areEqual('Test' + j, resultado.get(j).Message__c   , 'El mensaje debería ser el mismo');
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