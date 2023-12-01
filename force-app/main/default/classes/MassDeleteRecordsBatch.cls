/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 10-24-2023
 * @last modified by  : Gurkgamer
**/
global without sharing class MassDeleteRecordsBatch implements Database.Batchable<SObject>
{

    private LIst<String> records;

    global MassDeleteRecordsBatch(List<String> recordValues)
    {
        records = recordValues;
    }

    @AuraEnabled
    global static Id processData(List<String> values)
    {
        List<String> cleanvalues = new List<String>();
        System.debug('Valores: ' + values);

        for(String next : values)
        {
            next = next.remove('\\n');
            next = next.remove('\n');
            next = next.remove('\r');
            next = next.remove('\r');
            next = next.unescapeJava();
            next = next.normalizeSpace();
            next = next.trim();
            cleanvalues.add(next);
        }

        System.debug('fin');
        System.debug(cleanvalues);

        if(cleanvalues == null || cleanvalues.isEmpty())
        {
            return null;
        }

        return Database.executeBatch(new MassDeleteRecordsBatch(cleanvalues),200);
    }

    @AuraEnabled
    global static Boolean hasBatchFinish(Id batchId)
    {
        try
        {
            AsyncApexJob a =
            [   SELECT  Status
                FROM    AsyncApexJob
                WHERE   Id = :batchId];
            return a.Status == 'Completed' ? true : false;
        }
        catch (Exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug(records);
        String query = 'SELECT Id FROM Account WHERE Name IN :records';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope)
    {
        delete scope;
    }

    global void finish(Database.BatchableContext BC)
    {

    }

}