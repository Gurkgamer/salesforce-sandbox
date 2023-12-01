/**
 * @description       :
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 10-29-2022
 * @last modified by  : Gurkgamer
**/
@RestResource(urlMapping='/peaje')
global with sharing class WS_IntegrationService
{

    @HttpPost
    global static void submitData()
    {
        IntegrationResponse a = new IntegrationResponse();
        RestRequest req     = RestContext.request;
        RestResponse res    = Restcontext.response;
        res.responseBody = Blob.valueOf(JSON.serialize(a));

    }

    private class IntegrationResponse
    {
        String status;
        String statusCode;
        String message;
    }

}