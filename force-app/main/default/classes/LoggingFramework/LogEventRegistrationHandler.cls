/**
 * @description       : Clase que gestiona la insercción de eventos de log como entidad
 *                      Log. Por cada registros que llegue, se vuelcan todos los campos
 *                      a un nuevo registro que se insertará en el sistema.
 *                      Los eventos de plataforma solo tienen el contexto de "After Insert"
 *                      por lo que la clase simula una clase Handler pero solo con los dos
 *                      métodos que puede utilizar. Es por ello que no necesita implementar
 *                      la interfaz ITriggerHandler.
 * @author            : jgallaga
 * @group             : Seidor
 * @last modified on  : 06-02-2023
 * @last modified by  : Gurkgamer
**/
public without sharing class LogEventRegistrationHandler
{
    public static List<LogRecord__c> logsToInsert;

    public static void afterinsert(List<Log__e> newList)
    {
        if(newList == null)
        {
            return;
        }

        logsToInsert = LogEventRegistrationUtil.createLogginRecords(newList);
    }

    public static void finalDMLAfter()
    {
        if(logsToInsert != null && ! logsToInsert.isEmpty())
        {
            insert logsToInsert;
        }
    }
}