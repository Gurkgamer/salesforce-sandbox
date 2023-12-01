/**
 * @description       :
 * @author            : jgallaga
 * @group             :
 * @last modified on  : 08/04/2022
 * @last modified by  : jgallaga
 * Modifications Log
 * Ver   Date         Author     Modification
 * 1.0   08/04/2022   jgallaga   Initial Version
**/
global with sharing class WS_SoapExample
{
    webservice static List<CalloutResponse> createNewAccount(ExternalRecords records)
    {
        records.insertRecords();
        List<CalloutResponse> result = records.createResponse();
        return result;
    }
    
    global class Customer
    {
        // Los campos deben ser webservice para que sean usables en la llamada y aparezcan en el WSDL
        webservice String ExternalId;
        webservice Contact ContactRecord;
        webservice Account AccountRecord;
    }
    
    global class ExternalRecords
    {
        // El campo debe ser webservice para que sea usable en la llamada y aparezca en el WSDL
        webservice List<Customer> receivedRecords;

        public void insertRecords()
        {
            insertAccounts();
            insertContacts();
        }

        private void insertAccounts()
        {
            List<Account> newAccounts = new List<Account>();

            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;

            for(Customer nextCustomer : receivedRecords)
            {
                newAccounts.add(nextCustomer.AccountRecord);
            }

            Database.SaveResult[] accountCreationResults = Database.insert(newAccounts, dml);
        }

        private void insertContacts()
        {
            List<Contact> newContacts = new List<Contact>();

            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;

            for(Customer nextCustomer : receivedRecords)
            {
                if(String.isNotBlank(nextCustomer.AccountRecord.Id))
                {
                    nextCustomer.ContactRecord.AccountId = nextCustomer.AccountRecord.Id;
                    newContacts.add(nextCustomer.ContactRecord);
                }
            }

            Database.SaveResult[] contactCreationResults = Database.insert(newContacts, dml);
        }
        
        public List<CalloutResponse> createResponse()
        {
            List<CalloutResponse> response = new List<CalloutResponse>();

            for(Customer nextCustomer : receivedRecords)
            {
                CalloutResponse newResponse = new CalloutResponse();

                newResponse.ExternalId  = nextCustomer.ExternalId;
                newResponse.ContactId   = nextCustomer.ContactRecord.Id;
                newResponse.AccountId   = nextCustomer.AccountRecord.Id;
                response.add(newResponse);
            }

            return response;
        }
    }

    global class CalloutResponse // Tiene que ser global para poder devolverse como respuesta
    {
        // Las variables a devolver tienen que ser webservice, sino no apareceran en la respuesta
        webservice String ExternalId;
        webservice String ContactId;
        webservice String AccountId;
    }
}