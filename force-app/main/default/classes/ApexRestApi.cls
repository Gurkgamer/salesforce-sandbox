/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 02-13-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class ApexRestApi
{

    @InvocableMethod
    public static List<String> llamarApi()
    {
        Id recordtype = '0127Q000000mPPa';



        return new List<String>{getPicklistValuesFromRecordType(Account.GetSobjectType(),recordtype, Account.Dependent_Picklist__c)};
    }


    public static String getPicklistValuesFromRecordType(Schema.SObjectType salesforceObject, Id recordTypeId, Schema.SObjectField picklistField)
    {
        String resultado = '';
        try
        {
            HttpRequest restRequest = new HttpRequest();

            String objectName   = salesforceObject.getDescribe().getName();
            String picklistName = picklistField.getDescribe().getName();

            String domainURL    = URL.getOrgDomainUrl().toExternalForm();
            String endpoint     = domainURL + '/services/data/v56.0/ui-api/object-info/' + objectName + '/picklist-values/' + recordTypeId + '/' + picklistName;

            restRequest.setEndpoint(endpoint);

            restRequest.setMethod('GET');

            String sesionId = UserInfo.getSessionId();
            restRequest.setHeader('Authorization', 'Bearer ' + sesionId);


            Http apiCall = new Http();

            HttpResponse response = apiCall.send(restRequest);

            resultado = response.getBody();
        }
        catch(Exception error)
        {
            System.debug(error.getCause());
            System.debug(error.getMessage());
            System.debug(error.getStackTraceString());

        }
        return resultado;
    }
}