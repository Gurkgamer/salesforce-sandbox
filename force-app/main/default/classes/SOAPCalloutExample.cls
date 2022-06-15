// https://trailhead.salesforce.com/en/content/learn/modules/apex_integration_services/apex_integration_soap_callouts
public with sharing class SOAPCalloutExample 
{
    //Hay que añadir la pagina destino como Remote Site para permitir hacer llamadas (https://th-apex-soap-service.herokuapp.com )

    public static Double addNumers(Double value1, Double value2)
    {
        SOAPCalculatorServices.CalculatorImplPort calculator = new  SOAPCalculatorServices.CalculatorImplPort();
        Double x = value1;
        Double y = value2;
        Double result = calculator.doAdd(x,y);
        return result;
    }
    
    public static Double subtractNumers(Double value1, Double value2)
    {
        SOAPCalculatorServices.CalculatorImplPort calculator = new  SOAPCalculatorServices.CalculatorImplPort();
        Double x = value1;
        Double y = value2;
        Double result = calculator.doSubtract(x,y);
        return result;
    }

    public static Double multiplyNumers(Double value1, Double value2)
    {
        SOAPCalculatorServices.CalculatorImplPort calculator = new  SOAPCalculatorServices.CalculatorImplPort();
        Double x = value1;
        Double y = value2;
        Double result = calculator.doMultiply(x,y);
        return result;
    }

    public static Double divideNumers(Double value1, Double value2)
    {
        SOAPCalculatorServices.CalculatorImplPort calculator = new  SOAPCalculatorServices.CalculatorImplPort();
        Double x = value1;
        Double y = value2;
        Double result = calculator.doDivide(x,y);
        return result;
    }
}
