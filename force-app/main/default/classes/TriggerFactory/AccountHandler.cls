/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 07-05-2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   jgallaga   Initial Version
**/
public with sharing class AccountHandler implements ITriggerHandler
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

    public void finalDMLBefore(){}

    public void finalDMLAfter(){}
}
