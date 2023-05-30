/**
 * @description       : Clase que implementa el patrón Builder para poder construir un registro de evento
 *                      segun las necesidades del desarrollador. Para poder rellenar los campos que se
 *                      necesiten, únicamente hay que llamar al método correspondiente en forma de cadena
 *                      para ir pasandole los valores.
 *                      Finalmente es recomendable llamar al método build() para poder recibir de esta
 *                      forma un registro de tipo Log Event.
 *                      Ejemplo:
 *                          new LogEventBuilder()
 *                          .message('Un Texto')
 *                          .recordID('00138383923')
 *                          .submit();
 * @author            : jgallaga
 * @group             : Seidor
 * @last modified on  : 05-30-2023
 * @last modified by  : Gurkgamer
**/
public with sharing class LogEventBuilder
{

    // Estos campos representan los campos que tiene el evento.
    @TestVisible private String message;
    @TestVisible private String externalId;
    @TestVisible private String sourceClass;
    @TestVisible private String transactionId;
    @TestVisible private String exceptionStackTrace;
    @TestVisible private String exceptionMessage;
    @TestVisible private String exceptionCause;
    @TestVisible private String exceptionType;
    @TestVisible private String dmlExceptionFields;
    @TestVisible private Id userId;
    @TestVisible private Id recordId;
    @TestVisible private EventType type;
    @TestVisible private Datetime eventTime;

    // Añadir nuevos tipos de evento segun necesidad
    public enum EventType
    {
        WARNING,
        INFO,
        ERROR,
        LOG
    }

    /**
     * @description El constructor de esta clase rellenará algunos valores por defecto
     *              sobre el momento en el que ocurre el registro del evento.
     *              Quitando el tipo, el resto de valores no será posible informar
     *              por parte del desarrollador.
     *              El valor por defecto del tipo será INFO, se podrá sobreescribir usando
     *              el método apropiado.
     * @author      jgallaga
     * @date        09/05/2023
     */
    public LogEventBuilder(String message)
    {
        this.message        = message;
        this.transactionId  = System.Request.getCurrent().getRequestId(); // Permite localizar todos los eventos ocurrido en la misma transacción
        this.type           = EventType.LOG;
        this.eventTime      = System.now();
    }

    /**
     * @description Método que lanza el evento al bus de eventos de Salesforce.
     *              Transforma la información recibida hasta este momento al
     *              evento de plataforma LogEvent y después se publica.
     * @author      jgallaga
     * @date        09/05/2023
     * @return      Log__e
     *              Devuelve el resultado de la publicación del evento.
     */
    public Log__e build()
    {
        Log__e logEvent = new Log__e();

        logEvent.DMLExceptionFields__c  = dmlExceptionFields;
        logEvent.EventTime__c           = eventTime;
        logEvent.ExceptionCause__c      = exceptionCause;
        logEvent.ExceptionMessage__c    = exceptionMessage;
        logEvent.ExceptionStackTrace__c = exceptionStackTrace;
        logEvent.ExceptionType__c       = exceptionType;
        logEvent.ExternalId__c          = externalId;
        logEvent.Message__c             = message;
        logEvent.RecordId__c            = recordID;
        logEvent.SourceClass__c         = sourceClass;
        logEvent.TransactionId__c       = transactionId;
        logEvent.Type__c                = type?.name();
        logEvent.UserId__c              = userId;

        return logEvent;
    }

    /**
     * Los siguientes métodos permiten informar los campos de la clase
     * de la forma que el desarrollador necesite. Al devolverse a si mismo
     * el desarrollador podrá llamar al siguiente método directamente para
     * ir construyendo el registro de evento que desee.
     */

    public LogEventBuilder message(String message)
    {
        this.message = message;
        return this;
    }

    public LogEventBuilder recordId(Id recordId)
    {
        this.recordId = recordId;
        return this;
    }

    public LogEventBuilder externalId(String externalId)
    {
        this.externalId = externalId;
        return this;
    }

    public LogEventBuilder sourceClass(String sourceClass)
    {
        this.sourceClass = sourceClass;
        return this;
    }

    public LogEventBuilder type (EventType type)
    {
        if(type == null)
        {
            return this;
        }

        this.type = type;
        return this;
    }

    public LogEventBuilder userId(Id userId)
    {
        this.userId = userId;
        return this;
    }

    /**
     * @description Informa los campos de excepción con los detalles sobre el problema.
     *              El valor de causa puede aparecer como nulo si la excepción
     *              que se está registrando no fue recogida a causa de otra excepción original.
     * @author      jgallaga
     * @date        09/05/2023
     * @param       error
     *              Excepción que se quiere registrar.
     */
    public LogEventBuilder exception(Exception error)
    {
        if(error == null)
        {
            return this;
        }

        this.type                   = EventType.ERROR;
        this.exceptionMessage       = error.getMessage();
        this.exceptionStackTrace    = error.getStackTraceString();
        this.exceptionCause         = String.valueOf(error.getCause());
        this.exceptionType          = error.getTypeName();
        return this;
    }

    /**
     * @description Informa los campos de excepción DML con la información del elemento de la excepción de DML
     *              indicado en el índice que recibe. Utilizar este método para identificar cada error del DML
     *              de forma individual.
     * @author      jgallaga
     * @date        09/05/2023
     * @param       error
     *              La excepción DML que ha ocurrido, necesario para recoger el elemento de excepción DML
     *              que interesa informar.
     * @param       errorIndex
     *              Posición donde esta la información sobre el problema de DML que se quiere informar. No puede
     *              ser mayor a los elementos del error de DML para evitar salirle del índice.
     */
    public LogEventBuilder  dmlFieldsException(DmlException error, Integer errorIndex)
    {
        if(error == null || errorIndex == null || error.getNumDml() < errorIndex || errorIndex < 0)
        {
            return this;
        }

        this.type                   = EventType.ERROR;
        this.exceptionMessage       = error.getDMLMessage(errorIndex);
        this.exceptionStackTrace    = error.getStackTraceString();
        this.exceptionCause         = String.valueOf(error.getCause());
        this.exceptionType          = error.getDmlType(errorIndex).name();
        this.dmlExceptionFields     = error.getDmlFields(errorIndex).toString();

        return this;
    }
}