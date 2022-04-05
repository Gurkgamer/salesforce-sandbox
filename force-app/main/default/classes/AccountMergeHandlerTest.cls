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
@isTest
public class AccountMergeHandlerTest
{

    // Bulking params
    static final Integer MAX_MERGED_ACCOUNTS = 300;

    @isTest
    static void mergeAccount_OK()
    {
        Account master = new Account(Name='Account1');

        Account[] duplicates = new Account[]{
        new Account(Name='Account1, Inc.', AccountNumber = '001'),
        new Account(Name='Account 1', AccountNumber = '001')
        };

        List<Account> cuentas = new List<Account>();
        cuentas.add(master);
        cuentas.addAll(duplicates);

        insert cuentas;

        Test.startTest();
        Database.MergeResult[] results = Database.merge(master, duplicates, false);
        Test.stopTest();

        List<Account> remainingAccount = [SELECT Name, AccountNumber FROM Account];

        System.assertEquals(1, remainingAccount.size());
        System.assertEquals('001',remainingAccount.get(0).AccountNumber);


        List<Account> deletedAccounts = [SELECT Name, MasterRecordId, AccountNumber FROM Account WHERE MasterRecordId = :remainingAccount.get(0).Id AND IsDeleted = true ALL ROWS];

        System.assertEquals(2, deletedAccounts.size());
    }

    @isTest
    static void test_getMergedAccountRecords_null_OK()
    {
        Map<Id,Account> nothing;

        Test.startTest();
        Map<Account, List<Account>> result = AccountMergeHandler.getMergedAccountRecords(nothing);
        Test.stopTest();

        System.assert(result.isEmpty());
    }


    @isTest
    static void test_getMergedAccountRecords_Empty_OK()
    {
        Map<Id,Account> empty = new Map<Id,Account>();

        Test.startTest();
        Map<Account, List<Account>> result = AccountMergeHandler.getMergedAccountRecords(empty);
        Test.stopTest();

        System.assert(result.isEmpty());
    }

    @isTest
    static void test_getMergedAccountRecords_NotMergedAccounts_OK()
    {
        List<Account> newAccounts = new List<Account>();

        for(Integer i = 0; i < MAX_MERGED_ACCOUNTS ; i++)
        {
            newAccounts.add( new Account(Name = 'TstAcc' + i) );

        }

        insert newAccounts;

        Map<Id,Account> notMergedAccounts = new Map<Id,Account>(newAccounts);

        Test.startTest();
        Map<Account, List<Account>> result = AccountMergeHandler.getMergedAccountRecords(notMergedAccounts);
        Test.stopTest();

        System.assert(result.isEmpty());
    }

    @isTest
    static void test_checkImportantFields_ModifyMergedAccounts_OK()
    {
        List<Account> newAccounts = new List<Account>();

        Map<Account, List<Account>> accountTestRecords = new Map<Account, List<Account>>();

        Account masterAccount;

        for(Integer i = 0; i < MAX_MERGED_ACCOUNTS ; i++)
        {
            if(i == 0)
            {
                masterAccount = new Account(Name = 'TstAcc' + i);
                newAccounts.add(masterAccount);
                accountTestRecords.put(masterAccount, new List<Account>());
            }
            else
            {
                Account deletedAccount = new Account(Name = 'TstAcc' + i, AccountNumber='001');
                newAccounts.add(deletedAccount);
                accountTestRecords.get(masterAccount).add(deletedAccount);
            }
        }

        insert newAccounts;

        Test.startTest();
        List<Account> modifiedAccount = AccountMergeHandler.checkImportantFields(accountTestRecords);
        Test.stopTest();

        System.assert(!modifiedAccount.isEmpty());
        System.assertEquals('001', modifiedAccount.get(0).AccountNumber);
        System.assertEquals(masterAccount.Id, modifiedAccount.get(0).Id);
    }
}
