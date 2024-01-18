/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 01-17-2024
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class RecordComparator_Test
{
    @IsTest
    static void userLocaleSort()
    {
        string userLocale = 'fr_FR';

        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey=userLocale, TimeZoneSidKey='America/Los_Angeles',
        ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User'].Id,
        UserName='standarduser' + DateTime.now().getTime() + '@testorg.com');

        System.runAs(u)
        {
            List<Account> testAccounts = new List<Account>();

            testAccounts.add(new Account(name = 'épaule'));
            testAccounts.add(new Account(name = 'Bread'));
            testAccounts.add(new Account(name = 'Grocery'));
            testAccounts.add(new Account(name = 'à'));

            RecordComparator normalTextComparator = new RecordComparator(Account.name);

            // Default sort
            testAccounts.sort(normalTextComparator);

            Assert.areEqual('Bread', testAccounts.get(0).Name);
            Assert.areEqual('Grocery', testAccounts.get(1).Name);
            Assert.areEqual('à', testAccounts.get(2).Name);
            Assert.areEqual('épaule', testAccounts.get(3).Name);

            // Sort based on user Locale
            RecordComparator localeTextComparator = new RecordComparator(Account.Name);
            localeTextComparator.sortByLocale();

            testAccounts.sort(localeTextComparator);
            Assert.areEqual('à', testAccounts.get(0).Name);
            Assert.areEqual('Bread', testAccounts.get(1).Name);
            Assert.areEqual('épaule', testAccounts.get(2).Name);
            Assert.areEqual('Grocery', testAccounts.get(3).Name);
        }
    }
}