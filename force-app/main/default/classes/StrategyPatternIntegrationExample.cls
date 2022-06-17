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
        RestDefaultIntegration.Rest parametrosIntegracionAlgo = new RestDefaultIntegration.Rest();
        parametrosIntegracionAlgo.body = '';
        parametrosIntegracionAlgo.nameCredential = '';
        parametrosIntegracionAlgo.serviceEndPoint = '';        
        parametrosIntegracionAlgo.tokenEndPoint = '';

        RestDefaultIntegration configuracionIntegracion = new RestDefaultIntegration(parametrosIntegracionAlgo);
        
        Integrator integracion = new Integrator(configuracionIntegracion);

        integracion.getToken();
        HttpResponse respuesta = integracion.callOut();

        gestionarRespuesta(respuesta);
    }

    private static void gestionarRespuesta(HttpResponse response)
    {
        HttpResponse a = response;
    }
    
}

