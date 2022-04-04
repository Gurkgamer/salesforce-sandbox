/**

**/
@isTest
public class WS_RestExampleTest
{
    @isTest
    static void submitContactTest_OK()
    {
        List<Contact> bbddContacts = [SELECT Id FROM Contact];

        // Contact data for the REST service
        String firstName    = 'Pedro';
        String lastName     = 'Picapiedra';
        String email        = 'testemail@madeup.com';
        String phone        = '00112233';

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/submitContact';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"firstName":"' + firstName + '","lastName":"' + lastName + '","phoneNumber":"' + phone + '","email":"' + email + '"}');
        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        WS_RestExample.submitContact();
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode, 'Unexpected Satus Code');

        List<Contact> result = [SELECT FirstName, LastName, Phone, Email FROM Contact WHERE Id NOT IN :bbddContacts];

        System.assert(!result.isEmpty(),        'The Contact did not enter the BBDD');
        System.assertEquals(1, result.size(),   'The number of records created is not correct');

        System.assertEquals(firstName, result.get(0).FirstName, 'The First Name value is not correct');
        System.assertEquals(lastName, result.get(0).LastName,   'The Last Name value is not correct');
        System.assertEquals(phone, result.get(0).Phone,         'The Phone value is not correct');
        System.assertEquals(email, result.get(0).Email,         'The email value is not correct');

    }

    @isTest
    static void submitContactTest_NoLastName_KO()
    {
        List<Contact> bbddContacts = [SELECT Id FROM Contact];

        // Contact data for the REST service
        String firstName    = 'Pedro';
        String lastName     = '';
        String email        = 'testemail@madeup.com';
        String phone        = '00112233';

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/submitContact';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('{"firstName":"' + firstName + '","lastName":"' + lastName + '","phoneNumber":"' + phone + '","email":"' + email + '"}');
        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        WS_RestExample.submitContact();
        Test.stopTest();

        WS_RestExample.ContactErrorResponse errorResponse = (WS_RestExample.ContactErrorResponse) JSON.deserialize(RestContext.response.responseBody.toString(), WS_RestExample.ContactErrorResponse.class);

        System.assertEquals(500, RestContext.response.statusCode,               'The Status code number is not correct');
        System.assert(errorResponse.message.contains('REQUIRED_FIELD_MISSING'), 'The error reason is not correct. It should contain REQUIRED_FIELD_MISSING: ' + errorResponse.message);
        System.assertEquals('System.DmlException', errorResponse.errorCode,     'The Error Type is not a DmlException');

        List<Contact> result = [SELECT FirstName, LastName, Phone, Email FROM Contact WHERE Id NOT IN :bbddContacts];

        System.assert(result.isEmpty(), 'The Contact should have not entered the BBDD');
    }

    @isTest
    static void submitContactTest_RequestBodyEmpty_KO()
    {
        // TODO - Por ahora no se puede crear un perfil en test para generar uno sin permisos de campo. Se descarta crear uno especifico para un test

        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/submitContact';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('');
        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        WS_RestExample.submitContact();
        Test.stopTest();

        WS_RestExample.ContactErrorResponse errorResponse = (WS_RestExample.ContactErrorResponse) JSON.deserialize(RestContext.response.responseBody.toString(), WS_RestExample.ContactErrorResponse.class);

        System.assertEquals(500, RestContext.response.statusCode,       'The Status code number is not correct');
        System.assert(errorResponse.message.contains('EMPTY_BODY'),     'The error reason is not correct. It should contain EMPTY_BODY: ' + errorResponse.message);
        System.assertEquals('String.IsBlank', errorResponse.errorCode,  'The Error Type did not match');
    }

}
