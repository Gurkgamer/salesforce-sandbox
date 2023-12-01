/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public without sharing class RestDefaultCallOutBehaviour implements ICallOutBehaviour
{
    private String endPoint;
    private String body;

    public RestDefaultCallOutBehaviour(String endPoint, String body)
    {
        this.endPoint   = endPoint;
        this.body       = body;
    }

    public Object callOut(String credentials)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint + credentials);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');        
        request.setBody(body);
        HttpResponse response = http.send(request);
        return response;
    }
}