/**
 * @description       : Clase de Test para comprobar el funcionamiento de la clase LogEventBuilder
 * @author            : jgallaga
 * @group             : Seidor
 * @last modified on  : 05-30-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class LogEventBuilderTest
{
    /**
     * @description Este test comprueba que tras utilizar los distintos
     *              métodos disponibles, el método submit permite publicar
     *              el evento en el bus sin problemas.
     *              No nos preocupa el contenido de los valores indicados.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @IsTest
    static void test_LogEventBuilder_Build_OK()
    {
        // Create a new LogEventBuilder instance
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        builder.message('Test message')
            .recordId('7077a00004FVdIXAA1');

        builder.sourceClass('TestClass')
            .type(LogEventBuilder.EventType.WARNING)
            .userId(UserInfo.getUserId());

        // Create and submit the log event
        Test.startTest();
        Log__e logEventInstance = builder.build();
        Test.stopTest();

        // Verify the log event was created successfully
        Assert.areEqual('Test message', logEventInstance.Message__c, 'Algo ha provocado que el evento no se generase con el mensaje');
    }

    /**
     * @description Este test comrpueba que los valores que se le pasan
     *              a la intanciación de un evento se asignan a los
     *              campos correspondientes correctamente.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_LogParameters_Values_OK()
    {
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        String testText = 'TestMessage';
        String recordId = '7077a00004FVdIXAA1';
        String userId   = '7077a00004FVdIXAA2';
        String externalId = 'PAP0001L';
        String sourceClass = 'TestClass';
        LogEventBuilder.EventType type = LogEventBuilder.EventType.INFO;

        Test.startTest();

        builder.message(testText)
            .recordId(recordID)
            .type(LogEventBuilder.EventType.INFO)
            .sourceClass(sourceClass)
            .userId(userId)
            .externalId(externalId);

        Test.stopTest();

        Assert.areEqual(testText,builder.message        , 'El mensaje del evento es diferente al introducido');
        Assert.areEqual(recordId,builder.recordId       , 'El Id del registro no es el introducido');
        Assert.areEqual(userId,builder.userId           , 'El id del usuario no es el introducido');
        Assert.areEqual(externalId,builder.externalId   , 'El id externo no es el introducido');
        Assert.areEqual(sourceClass,builder.sourceClass , 'La clase origen no es el introducido');
        Assert.areEqual(type,builder.type               , 'El tipo de evento no es el introducido');
    }

    /**
     * @description Método que comprueba que con los parametros por defecto,
     *              es decir, solo instanciando la clase sin hacer nada,
     *              la publicación del evento sigue funcionando correctamente.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_DefaultLogParameterValues_Build_OK()
    {
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        Test.startTest();
        Log__e logEventInstance = builder.build();
        Test.stopTest();

        Assert.isTrue(logEventInstance != null);

        String emptyValue = 'Este campo debería estar vacío o nulo';

        Assert.isTrue(String.isNotBlank(logEventInstance.TransactionId__c)      , 'El identificador de la transacción no se rellenó de forma automática');
        Assert.areEqual(LogEventBuilder.EventType.LOG.name(), logEventInstance.Type__c , 'El tipo del evento no ha recibido el valor por defecto esperado');
        Assert.isTrue(logEventInstance.EventTime__c != null                     , 'El momento del evento no puede estar vacío');
        Assert.areEqual('TestMessage',logEventInstance.Message__c              , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExternalId__c)            , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.SourceClass__c)           , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionStackTrace__c)   , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionMessage__c)      , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.ExceptionCause__c)        , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.DMLExceptionFields__c)    , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.UserId__c)                , emptyValue);
        Assert.isTrue(String.isBlank(logEventInstance.RecordId__c)              , emptyValue);
    }

    /**
     * @description Este método de test comprueba que la información referente
     *              a una excepción informa los campos del evento preparados
     *              para almacenar dichos datos.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_ExceptionDataParameters_OK()
    {
        LogEventBuilder builder;

        Test.startTest();
        try
        {
            Integer i = 1/0;
        }
        Catch(Exception error)
        {
            builder = new LogEventBuilder('TestMessage').exception(error);

        }
        Test.stopTest();

        String noDataMessage = 'La información de la excepción no se almacenó correctamente';

        Assert.IsTrue(String.isNotBlank(builder.exceptionMessage)   , noDataMessage);
        Assert.IsTrue(String.isNotBlank(builder.exceptionStackTrace), noDataMessage);
        Assert.IsTrue(String.isNotBlank(builder.exceptionType)      , noDataMessage);
        //La causa en esta situación, estará a nulo
        Assert.IsTrue(String.isBlank(builder.exceptionCause)        , 'Este campo no debería tener ningún dato');
    }


    /**
     * @description Se comprueba que tras insertar una excepción y publicar
     *              el evento, no ocurre ningún problema
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_ExceptionData_Build_OK()
    {
        Log__e publishResult;

        Test.startTest();
        try
        {
            Integer i = 1/0;
        }
        Catch(Exception error)
        {
            publishResult = new LogEventBuilder('TestMessage').exception(error).build();
        }
        Test.stopTest();

        Assert.IsTrue(publishResult != null   , 'La publicación del evento no debería haber dado error');
    }

    /**
     * @description Este test asegura que tras registrar todos los eventos
     *              de error de DML, éstos han sido publicados correctamente.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_DMLExceptionSubmit_OK()
    {
        List<Log__e> dmlsFieldsEventBuilt = new List<Log__e>();

        Test.startTest();
        try
        {
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < 8 ; i++)
            {
                accounts.add(new Account());
            }
            insert accounts;
        }
        Catch(DmlException dmlError)
        {
            dmlsFieldsEventBuilt.add(new LogEventBuilder('TestMessage').exception(dmlError).build());

            for(Integer i = 0; i < dmlError.getNumDml(); i++)
            {
                dmlsFieldsEventBuilt.add(new LogEventBuilder('TestMessage').dmlFieldsException(dmlError, i).build());
            }
        }
        Test.stopTest();

        for(Log__e nextSubmit :dmlsFieldsEventBuilt)
        {
            Assert.isTrue(String.isNotBlank(nextSubmit.ExceptionMessage__c), 'Algo ha provocado que el evento no pudiera publicarse');
        }
    }

    /**
     * @description Método que comprueba que la información sobre la excepción
     *              de DML se rellena correctamente en los registros de evento.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_DMLExceptionData_OK()
    {
        LogEventBuilder mainDMLException = new LogEventBuilder('TestMessage');
        List<LogEventBuilder> dmlMissingFieldExceptions = new List<LogEventBuilder>();

        Test.startTest();
        try
        {
            List<Account> accounts = new List<Account>();
            for(Integer i = 0; i < 8 ; i++)
            {
                accounts.add(new Account());
            }
            insert accounts;
        }
        Catch(DmlException dmlError)
        {
            mainDMLException = new LogEventBuilder('TestMessage').exception(dmlError);

            for(Integer i = 0; i < dmlError.getNumDml(); i++)
            {
                dmlMissingFieldExceptions.add(new LogEventBuilder('TestMessage').dmlFieldsException(dmlError, i));
            }
        }
        Test.stopTest();

        String emptyValue = 'Este campo debería estar vacío o nulo';

        // Se miran que los campos del DML normal se hayan rellenado
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionMessage)      , 'El mensaje de la excepción no debería estar vacío');
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionStackTrace)   , 'El detalle de la excepción no debería estar vacío');
        Assert.isTrue(String.isBlank(mainDMLException.exceptionCause)           , emptyValue); // La causa estará a nulo
        Assert.isTrue(String.isNotBlank(mainDMLException.exceptionType)         , 'La información del tipo de excepción no debería estar vacío');
        Assert.isTrue(String.isNotBlank(mainDMLException.transactionId)         , 'El id de la transacción debería haberse informado');
        Assert.areEqual(LogEventBuilder.EventType.ERROR, mainDMLException.type  , 'El tipo del evento tiene que ser ERROR');
        Assert.isTrue(mainDMLException.eventTime != null                        , 'El constructor debería haber informado este campo');

        Assert.isTrue(String.isNotBlank(mainDMLException.message)           , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.externalId)           , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.sourceClass)          , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.userId)               , emptyValue);
        Assert.isTrue(String.isBlank(mainDMLException.recordId)             , emptyValue);

        for(LogEventBuilder nextDmlEvent :dmlMissingFieldExceptions)
        {
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionMessage)  , 'El mensaje de la excepción DML no debería estar vacío');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionStackTrace), 'El detalle de la excepción DML no debería estar vacío');
            Assert.isTrue(String.isBlank(nextDmlEvent.exceptionCause)       , emptyValue); // La causa estará a nulo
            Assert.isTrue(String.isNotBlank(nextDmlEvent.exceptionType)     , 'El tipo de excepción DMl no debería estar vacío.');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.dmlExceptionFields), 'Los campos de la excepción DML deberían aparecer aquó');
            Assert.isTrue(String.isNotBlank(nextDmlEvent.transactionId)     , 'El Id de la transacción se debería haber informado automáticamente');
            Assert.areEqual(LogEventBuilder.EventType.ERROR,nextDmlEvent.type, 'El tipo de evento no puede estar nulo');
            Assert.isTrue(nextDmlEvent.eventTime != null                    , 'El evento debería tener informado este campo');

            Assert.areEqual('TestMessage',nextDmlEvent.message              , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.externalId)           , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.sourceClass)          , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.userId)               , emptyValue);
            Assert.isTrue(String.isBlank(nextDmlEvent.recordId)             , emptyValue);
        }
    }

    /**
     * @description Método para asegurar que al la funcionalidad de guardar la información
     *              concreta de un indice del DML no recibe valores incorrectos.
     * @author      jgallaga
     * @date        09/05/2023
     */
    @IsTest
    static void test_DMLException_WrongIndex_OK()
    {
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        Test.startTest();
        try
        {
            insert new account();
        }
        catch(DMLException error)
        {
            builder.dmlFieldsException(error,2);
        }
        Test.stopTest();

        String emptyValue = 'Este campo debería estar vacío o nulo';

        Assert.isTrue(String.isBlank(builder.exceptionMessage)      , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionStackTrace)   , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionCause)        , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionType)         , emptyValue);
        Assert.isTrue(String.isBlank(builder.dmlExceptionFields)    , emptyValue);
    }

    /**
     * @description Este test comprueba que si al método de excepción
     *              se les da un valor nulo, no pasará nada. Los
     *              campos no son sobreescritos ni da ningún error.
     */
    @IsTest
    static void test_NullValuesException_OK()
    {
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        Test.startTest();
        builder.exception(null);
        Test.stopTest();

        String emptyValue = 'Este campo debería estar vacío o nulo';

        Assert.isTrue(String.isBlank(builder.exceptionMessage)      , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionStackTrace)   , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionCause)        , emptyValue);
        Assert.isTrue(String.isBlank(builder.exceptionType)         , emptyValue);
    }

        /**
     * @description Este test comprueba que si al método de excepción del DML
     *              se le da valores nulos, no pasará nada. Los
     *              campos no son sobreescritos ni da ningún error.
     */
    @IsTest
    static void test_NullValuesDMLException_OK()
    {
        LogEventBuilder builder1 = new LogEventBuilder('TestMessage');
        LogEventBuilder builder2 = new LogEventBuilder('TestMessage');
        LogEventBuilder builder3 = new LogEventBuilder('TestMessage');

        Test.startTest();
        builder1.dmlFieldsException(null,null);
        builder2.dmlFieldsException(new DmlException(),null);
        builder3.dmlFieldsException(null, 1);
        Test.stopTest();

        String emptyValue = 'Este campo debería estar vacío o nulo';

        Assert.isTrue(String.isBlank(builder1.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder1.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder1.dmlExceptionFields)   , emptyValue);

        Assert.isTrue(String.isBlank(builder2.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder2.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder2.dmlExceptionFields)   , emptyValue);

        Assert.isTrue(String.isBlank(builder3.exceptionMessage)     , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionStackTrace)  , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionCause)       , emptyValue);
        Assert.isTrue(String.isBlank(builder3.exceptionType)        , emptyValue);
        Assert.isTrue(String.isBlank(builder3.dmlExceptionFields)   , emptyValue);
    }

    /**
     * @description Test que asegura que no se puede poner el tipo del evento a nulo
     * @author      jgallaga
     * @date        09/05/2023
     */
    @isTest
    static void test_NullType_OK()
    {
        LogEventBuilder builder = new LogEventBuilder('TestMessage');

        Test.startTest();
        builder.type(null);
        Test.stopTest();

        Assert.areEqual(LogEventBuilder.EventType.LOG, builder.type    , 'El tipo del evento no debería haberse cambiado');
    }
}