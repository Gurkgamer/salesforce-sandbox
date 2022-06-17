/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public without sharing class RestDefaultLogBehaviour implements ILogBehaviour
{
    public void logResponse(Object response)
    {
        HttpResponse theResponse = (HttpResponse) response;
        // Log things
    }
}
