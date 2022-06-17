/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public with sharing class Integrator 
{
    ICallOutBehaviour callout;

    public Integrator(ICallOutBehaviour callOutB) 
    {
        callout = callOutB;
    }

    public void getToken()
    {
        callout.getToken();
    }

    public HttpResponse callOut()
    {
        return callout.callOut();
    }
}
