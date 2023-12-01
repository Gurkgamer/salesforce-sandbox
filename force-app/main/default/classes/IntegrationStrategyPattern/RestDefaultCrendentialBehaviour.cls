/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public without sharing class RestDefaultCrendentialBehaviour implements ICredentialBehaviour
{
    private String nameCredential;

    public RestDefaultCrendentialBehaviour(String nameCredential) 
    {
        this.nameCredential = nameCredential;
    }

    public String getCredentials()
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(nameCredential);
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');                
        HttpResponse response = http.send(request);
        return response.getBody();
    }

}