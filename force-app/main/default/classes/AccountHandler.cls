/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 05/04/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   05/04/2022   jgallaga   Initial Version
**/
public with sharing class AccountHandler
{

    private static Map<Account,List<Account>> mergedAccountsWithDeletedMergedAccounts;

    public static void bulkBefore(List<Account> newList, Map<Id,Account> oldMap)
    {
        if(Trigger.operationType == System.TriggerOperation.BEFORE_UPDATE)
        {
            mergedAccountsWithDeletedMergedAccounts = AccountMergeHandler.getMergedAccountRecords((Map<Id,Account>) Trigger.newMap);
        }
    }

    public static void beforeInsert(List<Account> newList){}

    public static void beforeUpdate(List<Account> newList, Map<Id,Account> oldMap)
    {
        List<Account> accountToExternal = AccountMergeHandler.checkImportantFields(mergedAccountsWithDeletedMergedAccounts);
    }

    public static void beforeDelete(Map<Id,Account> oldMap){}

    public static void bulkAfter(List<Account> newList, Map<Id,Account> oldMap){}

    public static void afterInsert(List<Account> newList){}

    public static void afterUpdate(List<Account> newList, Map<Id,Account> oldMap){}

    public static void afterDelete(Map<Id,Account> oldMap){}

}
