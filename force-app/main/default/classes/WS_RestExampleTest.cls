@isTest
public class WS_RestExampleTest
{
    @isTest
    static void submitContactTest()
    {   
        List<Contact> bbddContacts = [SELECT Id FROM Contact];

        // Contact data for the REST service
        String firstName    = 'Pedro';
        String lastName     = 'Picapiedra';
        String email        = 'testemail@madeup.com';
        String phone        = '00112233';

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/Roland/submitContact';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"firstName":"' + firstName + '","lastName":"' + lastName + '","phoneNumber":"' + phone + '","email":"' + email + '"}');
        RestContext.request = request;
        RestContext.response = new RestResponse();


        Test.startTest();
        WS_RestExample.submitContact(firstName, lastName, email, phone);
        Test.stopTest();

        List<Contact> result = [SELECT FirstName, LastName, Phone, Email FROM Contact WHERE Id NOT IN :bbddContacts];

        System.assert(!result.isEmpty(),        'The Contact did not enter the BBDD');
        System.assertEquals(1, result.size(),   'The number of records created is not correct');

        System.assertEquals(firstName, result.get(0).FirstName, 'The First Name value is not correct');
        System.assertEquals(lastName, result.get(0).LastName,   'The Last Name value is not correct');
        System.assertEquals(phone, result.get(0).Phone,         'The Phone value is not correct');
        System.assertEquals(email, result.get(0).Email,         'THe email value is not correct');


    }
}
