/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public without sharing class RestDefaultResponseBehaviour implements IResponseBehaviour
{
    public void manageResponse(Object response)
    {
        HttpResponse parsedResponse = (HttpResponse) response;
        // Do something
    }
}
