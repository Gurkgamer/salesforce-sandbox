// -> https://{instance}.salesforce.com/services/apexrest/.
// -> https://gurkgamer-example-dev-ed.my.salesforce.com/services/apexrest/Contact/submitContact
// -> Docu: https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_rest_methods.htm
// -> Trailhead: https://trailhead.salesforce.com/content/learn/modules/apex_integration_services/apex_integration_webservices
// -> REST API supports OAuth 2.0
@RestResource(urlMapping='/Contact/*')
global with sharing class WS_RestExample
{

    @HttpPost
    global static void submitContact(String firstName, String lastName, String email, String phoneNumber)
    {
        Contact newContact = new Contact();
        newContact.FirstName = firstName;
        newContact.LastName = lastName;
        newContact.Phone = phoneNumber;
        newContact.Email = email;

        RestResponse result = RestContext.response;
        result.addHeader('Content-Type', 'application/json');

        if(checkContactAccssible())
        {
            Savepoint sp = Database.setSavepoint(); // Save state de la BBDD por si falla el DML
            try
            {
                insert newContact;
                result.statusCode = 201;
                ContactSuccessResponse resultado = new ContactSuccessResponse(newContact.Id, 'Contacto insertado correctamente.');
                result.responseBody = Blob.valueOf(JSON.serialize(resultado));
            }
            catch(DMLException dmlError)
            {
                result.statusCode = 500;
                ContactErrorResponse errorResponse = new ContactErrorResponse(newContact, dmlError.getMessage(), dmlError.getTypeName());
                result.responseBody = Blob.valueOf(JSON.serialize(errorResponse));
                Database.rollback(sp);

            }
            catch(Exception exceptionError)
            {
                result.statusCode = 500;
                ContactErrorResponse errorResponse = new ContactErrorResponse(newContact, exceptionError.getMessage(), exceptionError.getTypeName());
                result.responseBody = Blob.valueOf(JSON.serialize(errorResponse));
                Database.rollback(sp);
            }
        }
        else
        {
            result.statusCode = 500;
            ContactErrorResponse errorResponse = new ContactErrorResponse(newContact, 'FIELD NOT AVAILABLE', 'Insufficient field-level access.');
            result.responseBody = Blob.valueOf(JSON.serialize(errorResponse));
        }
    }

    private static Boolean checkContactAccssible()
    {
        return (
            Schema.SObjectType.Contact.isAccessible()                   &&
            Schema.SObjectType.Contact.fields.FirstName.isAccessible()  &&
            Schema.SObjectType.Contact.fields.LastName.isAccessible()   &&
            Schema.SObjectType.Contact.fields.Phone.isAccessible()      &&
            Schema.SObjectType.Contact.fields.Email.isAccessible()      );
    }

    @TestVisible
    class ContactSuccessResponse
    {
        @TestVisible
        String message;
        @TestVisible
        String salesforceId;

        ContactSuccessResponse(String recordId, String customMessage)
        {
            message         = customMessage;
            salesforceId    = recordId;
        }
    }

    @TestVisible
    class ContactErrorResponse
    {
        @TestVisible
        String errorCode;
        @TestVisible
        String message;
        Contact recordValues;

        ContactErrorResponse(Contact receivedRecord, String customMessage, String errorCodeType)
        {
            errorCode       = errorCodeType;
            message         = customMessage;
            recordValues    = receivedRecord;
        }
    }

}
