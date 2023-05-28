/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-28-2023
 * @last modified by  : Gurkgamer
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   Gurkgamer   Initial Version
**/
public with sharing class AccountTriggerHandler implements ITriggerHandler
{
    public void beforeInsert(List<SObject> newList){}

    public void beforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap)
    {
        Map<Account,List<Account>> mergedAccountsWithDeletedMergedAccounts = AccountMergeHandler.getMergedAccountRecords((Map<Id,Account>) Trigger.newMap);
        List<Account> accountToExternal = AccountMergeHandler.checkImportantFields(mergedAccountsWithDeletedMergedAccounts);
    }

    public void beforeDelete(LIst<SObject> oldMap){}

    public void afterInsert(List<SObject> newList){}

    public void afterUpdate(List<SObject> newList, Map<Id,SObject> oldMap){}

    public void afterDelete(List<SObject> oldMap){}
}