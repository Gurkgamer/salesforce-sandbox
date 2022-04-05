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
public with sharing class AccountMergeHandler
 {

    /**
    * @description      Returns a map with merged Accounts and the list of the deleted accounts that merged with that Master record
    * @author           jgallaga | 05/04/2022
    * @param            Map<Id, Account> updatedRecordsByMerge
    * @return           Map<Account, List<Account>>
    **/
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
                Account mergedAccount = updatedRecordsByMerge.get(nextDeletedMergedAccount.MasterRecordId);

                if(!mergedAccountData.containsKey(mergedAccount))
                {
                    mergedAccountData.put(mergedAccount, new List<Account>());
                }

                mergedAccountData.get(mergedAccount).add(nextDeletedMergedAccount);
            }
        }

        return mergedAccountData;
    }

    /**
    * @description      Si se cumplen las condiciones indicadas, la cuenta unificado recibe los valores correctos a partir del borrado.
    *                   Se devuelve la lista de aquellas cuentas unificadas que han necesitado corregirse.
    * @author           jgallaga | 05/04/2022
    * @param            Map<Account,List<Account>> mergedAccounts
    * @return           List<Account>
    **/
    public static List<Account> checkImportantFields(Map<Account, List<Account>> mergedAccounts)
    {
        List<Account> correctedAccounts = new List<Account>();

        if(mergedAccounts == null)
        {
            return null;
        }

        for(Account nextMergedAccount : mergedAccounts.keySet())
        {
            if(mergedAccounts.get(nextMergedAccount) == null)
            {
                continue;
            }

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
