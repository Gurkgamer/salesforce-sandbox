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
public with sharing class AccountMergeHandler {
    public AccountMergeHandler() {

    }

    public static Map<Account,List<Account>> getMergedAccountRecords(Map<Id,Account> updatedRecordsByMerge)
    {
        Map<Account, List<Account>> mergedAccountData = new Map<Account, List<Account>>();

        if(updatedRecordsByMerge == null)
        {
            return mergedAccountData;
        }

        Set<Id> receivedAccountIds = updatedRecordsByMerge.keySet();

        Map<Id,Account> deletedMergedAccounts = new Map<Id,Account>([SELECT Name, MasterRecordId, AccountNumber FROM Account WHERE MasterRecordId IN :receivedAccountIds AND IsDeleted = true ALL ROWS]);

        for(Account nextDeletedMergedAccount : deletedMergedAccounts.values())
        {
            if(updatedRecordsByMerge.containsKey(nextDeletedMergedAccount.MasterRecordId))
            {
                Account mergedAccount = (Account) updatedRecordsByMerge.get(nextDeletedMergedAccount.MasterRecordId);

                if(!mergedAccountData.containsKey(mergedAccount))
                {
                    mergedAccountData.put(mergedAccount, new List<Account>());
                }

                mergedAccountData.get(mergedAccount).add(nextDeletedMergedAccount);
            }
        }

        return mergedAccountData;
    }

    public static List<Account> checkImportantFields(Map<Account, List<Account>> mergedAccounts)
    {
        List<Account> correctedAccounts = new List<Account>();

        for(Account nextMergedAccount : mergedAccounts.keySet())
        {
            for(Account deletedAccount : mergedAccounts.get(nextMergedAccount))
            {
                if(String.isBlank(nextMergedAccount.AccountNumber) && String.isNotBlank(deletedAccount.AccountNumber))
                {
                    nextMergedAccount.AccountNumber = deletedAccount.AccountNumber;
                    correctedAccounts.add(nextMergedAccount);
                }
            }
        }

        return correctedAccounts;
    }
}
