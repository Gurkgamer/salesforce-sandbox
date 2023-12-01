/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 10-09-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class PropagateBlockedFieldBatch implements Database.Batchable<sObject>
{
    private Related_Blocked_Records__mdt currentObjectParameters;
    private integer currentSobjectIndex;


    public PropagateBlockedFieldBatch(Integer indexValue)
    {
        if(indexValue == null || indexValue < 1)
        {
            currentSobjectIndex = 1;
        }
        else
        {
            currentSobjectIndex = indexValue;
        }

        currentObjectParameters = getCurrentSObjectMetadataSetup(currentSobjectIndex);
    }


    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String formulaField = currentObjectParameters.Formula_field__c;
        String blockingField = currentObjectParameters.Blocking_field__c;

        String scopeQuery = 'SELECT ' + formulaField + ' , ' + blockingField + ' FROM ' + currentObjectParameters.DeveloperName + ' WHERE (' + formulaField + ' = true AND ' + blockingField + ' = false) OR (' + formulaField + ' = false AND ' + blockingField + ' = true)';

        return Database.getQueryLocator(scopeQuery);
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        String blockingField = currentObjectParameters.Blocking_field__c;
        String formulaField = currentObjectParameters.Formula_field__c;

        for(sObject nextO : scope)
        {
            nextO.put(blockingField,nextO.get(formulaField));
        }

        update scope;
    }

    public void finish(Database.BatchableContext BC)
    {
        Integer nextIndex = currentSobjectIndex + 1;

        if(getCurrentSObjectMetadataSetup(nextIndex) != null)
        {
            Database.executeBatch(new PropagateBlockedFieldBatch(nextIndex));
        }
    }

    private Related_Blocked_Records__mdt getCurrentSObjectMetadataSetup(Integer indexValue)
    {
        Related_Blocked_Records__mdt foundMetada;

        for(Related_Blocked_Records__mdt metadt : Related_Blocked_Records__mdt.GetAll().Values())
        {
            if(metadt.Index__c == indexValue)
            {
                foundMetada = metadt;
                break;
            }
        }

        return foundMetada;
    }
}