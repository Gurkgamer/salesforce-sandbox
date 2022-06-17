/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-17-2022
 * @last modified by  : jgallaga
**/
public without sharing class StrategyPatternIntegrationExample
{
    public static void integrarAlgo()
    {
        RestDefaultCrendentialBehaviour credenciales    = new RestDefaultCrendentialBehaviour('EndPoint');
        RestDefaultCallOutBehaviour envioDatos          = new RestDefaultCallOutBehaviour('EndPoint', 'BodyJSON');
        RestDefaultResponseBehaviour respuesta          = new RestDefaultResponseBehaviour();
        RestDefaultLogBehaviour logIntegracion          = new RestDefaultLogBehaviour();
        
        Integrator integracion = new Integrator();
        integracion.setCredentialBehaviour(credenciales);
        integracion.setCallOutBehaviour(envioDatos);
        integracion.setResponseBehaviour(respuesta);
        integracion.setLogBehaviour(logIntegracion);

        integracion.execute();
    }
   
}

