/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public with sharing class RestDefaultIntegration  Implements ICallOutBehaviour
{
    Rest parameters;

    public RestDefaultIntegration(Rest parameters) 
    {
        this.parameters = parameters;
    }

    public void getToken()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(parameters.nameCredential);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');                
        HttpResponse response = http.send(request);
        parameters.token = response.getBody();
    }

    public HttpResponse callOut()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(parameters.serviceEndPoint + parameters.token);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');        
        request.setBody(parameters.body);
        HttpResponse response = http.send(request);
        return response;
    }

    public class Rest
    {
        public String nameCredential    {get;set;}
        public String tokenEndPoint     {get;set;}
        public String serviceEndPoint   {get;set;}
        private String token             {get;set;}
        public String body              {get;set;}
    }
}
