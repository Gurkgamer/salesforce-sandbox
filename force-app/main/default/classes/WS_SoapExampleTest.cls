@isTest
public with sharing class WS_SoapExampleTest {    

    @isTest
    static void testAccountCreate() 
    {
        WS_SoapExample.ExternalRecords data = new WS_SoapExample.ExternalRecords();
       
        WS_SoapExample.Customer newCustomer = new WS_SoapExample.Customer();

        newCustomer.ExternalId = 'PAPIPUPEPO';
        newCustomer.ContactRecord = new Contact(LastName = 'Test', FirstName = 'Name', Email='testEMail@test.com');
        newCustomer.AccountRecord = new Account(Name='Company', ACcountNumber = '00041');

        data.receivedRecords = new List<WS_SoapExample.Customer>();
        data.receivedRecords.add(newCustomer);

        List<WS_SoapExample.CalloutResponse> response = WS_SoapExample.createNewAccount(data);

        for(WS_SoapExample.CalloutResponse nextResponse : response)
        {
            System.assert(String.isNotBlank(nextResponse.AccountId));
            System.assert(String.isNotBlank(nextResponse.ContactId));
        }

        List<Account> insertedAccounts = [SELECT Name, AccountNumber FROM Account];

        System.assert(!insertedAccounts.isEmpty());
        System.assert(insertedAccounts.size() == 1);
        System.assertEquals('Company', insertedAccounts.get(0).Name);
        System.assertEquals('00041', insertedAccounts.get(0).AccountNumber);
        
        List<Contact>  insertedContacts = [SELECT FirstName, LastName, Email FROM Contact];

        System.assert(!insertedContacts.isEmpty());
        System.assert(insertedContacts.size() == 1);
        System.assertEquals('Test', insertedContacts.get(0).LastName);
        System.assertEquals('Name', insertedContacts.get(0).FirstName);
        System.assertEquals('testemail@test.com', insertedContacts.get(0).Email);        
    }
}