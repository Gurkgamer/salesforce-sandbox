/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 07-04-2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   jgallaga   Initial Version
**/
public with sharing class AccountHandler implements ITriggerHandler
{
    // For Before Update
    private static Map<Account,List<Account>> mergedAccountsWithDeletedMergedAccounts;

    //#region Insert

    public void bulkBeforeInsert(List<Account> newList)
    {
        System.debug('Esto es en before');
    }

    public void bulkAfterInsert(List<Account> newList)
    {
        System.debug('Esto es en after');
    }

    public void beforeInsert(List<SObject> newList){}

    public void afterInsert(List<SObject> newList){}

    //#endregion

    //#region Update

    public void bulkBeforeUpdate(List<SObject> newList , Map<Id,SObject> oldMap)
    {
        mergedAccountsWithDeletedMergedAccounts = AccountMergeHandler.getMergedAccountRecords((Map<Id,Account>) Trigger.newMap);
    }

    public void beforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap)
    {
        List<Account> accountToExternal = AccountMergeHandler.checkImportantFields(mergedAccountsWithDeletedMergedAccounts);
    }

    public void bulkAfterUpdate(List<SObject> newList , Map<Id,SObject> oldMap){}

    public void afterUpdate(List<SObject> newList, Map<Id,SObject> oldMap){}

    //#endregion

    //#region Delete

    public void bulkBeforeDelete(List<SObject> oldList){}

    public void bulkAfterDelete(List<SObject> oldList){}

    public void beforeDelete(LIst<SObject> oldMap){}

    public void afterDelete(List<SObject> oldMap){}

    //#endregion

    //#region DMLs

    public void finalDMLBefore(){}

    public void finalDMLAfter(){}

    //#endregion
}
