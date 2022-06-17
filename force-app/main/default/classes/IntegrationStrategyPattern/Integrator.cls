/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public with sharing class Integrator
{
    ICredentialBehaviour    credentialBehaviour;
    ICallOutBehaviour       callOutBehaviour;
    IResponseBehaviour      responseBehaviour;
    ILogBehaviour           logBehaviour;

    public void setCredentialBehaviour(ICredentialBehaviour credentialBehaviour)
    {
        this.credentialBehaviour = credentialBehaviour;
    }

    public void setCallOutBehaviour(ICallOutBehaviour callOutBehaviour)
    {
        this.callOutBehaviour = callOutBehaviour;
    }

    public void setResponseBehaviour(IResponseBehaviour responseBehaviour)
    {
        this.responseBehaviour = responseBehaviour;
    }

    public void setLogBehaviour(ILogBehaviour logBehaviour)
    {
        this.responseBehaviour = responseBehaviour;
    }

    public void execute()
    {
        String token = credentialBehaviour.getCredentials();
        Object response = callOutBehaviour.callOut(token);
        responseBehaviour.manageResponse(response);
        logBehaviour.logResponse(response);
    }
}
