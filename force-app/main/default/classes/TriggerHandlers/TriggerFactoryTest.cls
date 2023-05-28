/**
 * @description       : Test class to verify the correct functioning of the Trigger Factory class.
 * @author            : Gurkgamer
 * @group             :
 * @last modified on  : 05-28-2023
 * @last modified by  : Gurkgamer
**/
@isTest
public with sharing class TriggerFactoryTest
{

    // This mock class will allow verifying the execution of the Trigger factory in each execution context of a trigger.
    private class MockHandlerClass implements ITriggerHandler
    {
        public Boolean beforeInsertExecuted = false;
        public Boolean beforeUpdateExecuted = false;
        public Boolean beforeDeleteExecuted = false;
        public Boolean afterInsertExecuted  = false;
        public Boolean afterUpdateExecuted  = false;
        public Boolean afterDeleteExecuted  = false;

        public void beforeInsert(List<SObject> newList)                         { beforeInsertExecuted  = true; }
        public void beforeUpdate(List<SObject> newList, Map<Id,SObject> oldMap) { beforeUpdateExecuted  = true; }
        public void beforeDelete(List<SObject> oldList)                         { beforeDeleteExecuted  = true; }
        public void afterInsert(List<SObject> newList)                          { afterInsertExecuted   = true; }
        public void afterUpdate(List<SObject> newList, Map<Id,SObject> oldMap)  { afterUpdateExecuted   = true; }
        public void afterDelete(List<SObject> oldList)                          { afterDeleteExecuted   = true; }
    }

    /**
     * @description This test verifies that the public method of the Trigger Factory throws an exception when a null handler class is passed.
     */
    @isTest
    static void test_manageTrigger_NullHandler_ThrowsException()
    {
        Test.startTest();
        try
        {
            TriggerFactory.manageTrigger(null);
            Assert.fail('Trigger Factory should throw an exception if a null parameter is used');
        }
        Catch(IllegalArgumentException handlerError)
        {
            // This is the expected exception
            Assert.areEqual('Parameter handlerInstance can not be null', handlerError.getMessage());
        }
        Catch(Exception unexpectedError)
        {
            Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }

    /**
     * @description Verifies that Trigger Factory throws an exception if it does not find the metadata record
     *              for the received Handler class.
     */
    @isTest
    static void test_manageTrigger_Handler_NoMetadata_ThrowsException()
    {
        MockHandlerClass mockClass = new MockHandlerClass();
        String className = String.valueOf(mockClass).split(':').get(0);
        String testExceptionMessage = 'There is no configuration for this handler ' + className;

        Test.startTest();
        try
        {
            TriggerFactory.manageTrigger(mockClass);
            Assert.fail('Trigger Factory debería dar una excepción si no se le pasa una clase Handler');
        }
        Catch(TriggerFactory.TriggerFactoryException handlerError)
        {
            // This is the expected exception
            Assert.areEqual(testExceptionMessage, handlerError.getMessage());
        }
        Catch(Exception unexpectedError)
        {
            Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the Before Insert and Final DML methods are executed for the Before context.
     */
    @isTest
    static void test_execute_BeforeInsertContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.BEFORE_INSERT);
        Test.stopTest();

        Assert.isTrue(mockClass.beforeInsertExecuted,   'Expected Before Insert method to be executed');
        Assert.isFalse(mockClass.beforeUpdateExecuted,  'Before Update method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeDeleteExecuted,  'Before Delete method should not have been executed in this context');
        Assert.isFalse(mockClass.afterInsertExecuted,   'After Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterUpdateExecuted,   'After Update method should not have been executed in this context');
        Assert.isFalse(mockClass.afterDeleteExecuted,   'After Delete method should not have been executed in this context');
    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the After Insert and Final DML methods are executed for the After context.
    */
    @isTest
    static void test_execute_AfterInsertContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.AFTER_INSERT);
        Test.stopTest();

        Assert.isTrue(mockClass.afterInsertExecuted,    'Expected After Insert method to be executed');
        Assert.isFalse(mockClass.beforeUpdateExecuted,  'Before Update method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeDeleteExecuted,  'Before Delete method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeInsertExecuted,  'Before Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterUpdateExecuted,   'After Update method should not have been executed in this context');
        Assert.isFalse(mockClass.afterDeleteExecuted,   'After Delete method should not have been executed in this context');
    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the Before Update and Final DML methods are executed for the Before context.
     */
    @isTest
    static void test_execute_BeforeUpdateContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.BEFORE_UPDATE);
        Test.stopTest();

        Assert.isTrue(mockClass.beforeUpdateExecuted,   'Expected Before Update method to be executed');
        Assert.isFalse(mockClass.beforeInsertExecuted,  'Before Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeDeleteExecuted,  'Before Delete method should not have been executed in this context');
        Assert.isFalse(mockClass.afterInsertExecuted,   'After Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterUpdateExecuted,   'After Update method should not have been executed in this context');
        Assert.isFalse(mockClass.afterDeleteExecuted,   'After Delete method should not have been executed in this context');

    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the After Update and Final DML methods are executed for the After context.
     */
    @isTest
    static void test_execute_AfterUpdateContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.AFTER_UPDATE);
        Test.stopTest();

        Assert.isTrue(mockClass.afterUpdateExecuted,    'Expected After Update method to be executed');
        Assert.isFalse(mockClass.beforeInsertExecuted,  'Before Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeUpdateExecuted,  'Before Update method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeDeleteExecuted,  'Before Delete method should not have been executed in this context');
        Assert.isFalse(mockClass.afterInsertExecuted,   'After Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterDeleteExecuted,   'After Delete method should not have been executed in this context');

    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the Before Delete and Final DML methods are executed for the Before context.
     */
    @isTest
    static void test_execute_BeforeDeleteContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.BEFORE_DELETE);
        Test.stopTest();

        Assert.isTrue(mockClass.beforeDeleteExecuted,   'Expected Before Delete method to be executed');
        Assert.isFalse(mockClass.beforeInsertExecuted,  'Before Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeUpdateExecuted,  'Before Update method should not have been executed in this context');
        Assert.isFalse(mockClass.afterInsertExecuted,   'After Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterUpdateExecuted,   'After Update method should not have been executed in this context');
        Assert.isFalse(mockClass.afterDeleteExecuted,   'After Delete method should not have been executed in this context');

    }

    /**
     * @description Verifies that Trigger Factory executes the expected trigger context methods of the received handler class.
     *              For this case, it checks that the After Delete and Final DML methods are executed for the After context.
    */
    @isTest
    static void test_execute_AfterDeleteContext_ExecutesExpectedMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();

        Test.startTest();
        TriggerFactory.execute(mockClass, System.TriggerOperation.AFTER_DELETE);
        Test.stopTest();

        Assert.isTrue(mockClass.afterDeleteExecuted,    'Expected After Delete method to be executed');
        Assert.isFalse(mockClass.beforeInsertExecuted,  'Before Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeUpdateExecuted,  'Before Update method should not have been executed in this context');
        Assert.isFalse(mockClass.beforeDeleteExecuted,  'Before Delete method should not have been executed in this context');
        Assert.isFalse(mockClass.afterInsertExecuted,   'After Insert method should not have been executed in this context');
        Assert.isFalse(mockClass.afterUpdateExecuted,   'After Update method should not have been executed in this context');
    }

    /**
     * @description Verifies that Trigger Factory executes the trigger context methods when the handler class has its metadata record enabled.
     *              Since these tests are not actually running a trigger due to a DML operation, it will not be able to invoke the execute method
     *              as there is no real Trigger context. Therefore, it checks that the expected exception is thrown for this situation.
     *              The test is correct as the metadata record is instructing Trigger Factory to invoke the execute method.
    */
    @isTest
    static void test_HandlerClassEnabled_ExecutesContextMethods()
    {
        MockHandlerClass mockClass = new MockHandlerClass();
        TriggerFactory.setTriggerSetup(mockClass, true);

        Test.startTest();
        try
        {
            TriggerFactory.manageTrigger(mockClass);
            Assert.fail('An exception should be thrown as it is not executed as a DML');
        }
        Catch(IllegalArgumentException error)
        {
            // Al no ser una ejecución de trigger, no tendrá contexto para el método execute
            // Este es el error que se espera recibir en este test
            Assert.areEqual('Parameter triggerOperation can not be null', error.getMessage());
        }
        Catch(Exception unexpectedError)
        {
            Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }



    /**
     * @description Verifies that Trigger Factory does not execute anything when the handler class is disabled in its metadata record.
    */
    @isTest
    static void test_HandleClassDisabled_NoExecution()
    {
        MockHandlerClass mockClass = new MockHandlerClass();
        TriggerFactory.setTriggerSetup(mockClass, false);

        Test.startTest();
        try
        {
            TriggerFactory.manageTrigger(mockClass);
        }
        Catch(Exception unexpectedError)
        {
            Assert.fail('This test should not have thorwn an exception: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }

    /**
     * @description Unit test to ensure that null parameters are handled properly. If null values are received, a controlled exception will be thrown.
     */
    @isTest
    static void test_GetMetadataParameters_Null_ThrowsException()
    {
        Test.startTest();
        try
        {
            TriggerFactory.getTriggerSetup(null);
        }
        Catch(IllegalArgumentException error)
        {
            // Este es el error que se espera recibir en este test
            Assert.areEqual('Parameter handlerInstance can not be null', error.getMessage());
        }
        Catch(Exception unexpectedError)
        {
            Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }

    /**
     * @description Unit test to ensure that null parameters are properly handled.
     *              If null parameters are received, a controlled exception is thrown.
     *              This test is used to combine all possible null parameter combinations
     *              that the tested method could receive.
     */
    @isTest
    static void test_SetMetadataParameters_NULL_KO()
    {
        List<List<Object>> parameterCombinations = new List<List<Object>>{
            new List<Object>{null, null},
            new List<Object>{new MockHandlerClass(), null},
            new List<Object>{null, true}
        };

        Test.startTest();

        for (List<Object> parameters : parameterCombinations)
        {
            try
            {
                TriggerFactory.setTriggerSetup((ITriggerHandler) parameters[0], (Boolean) parameters[1]);
                Assert.fail('Tiene que dar una excepción al pasar parámetros a NULL');
            }
            catch (IllegalArgumentException error)
            {
                Assert.isTrue(error.getMessage().contains('Parameter'));
                Assert.isTrue(error.getMessage().contains('can not be null'));
            }
            catch (Exception unexpectedError)
            {
                Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
            }
        }

        Test.stopTest();
    }

    /**
     * @description Unit test to ensure that null parameters are properly handled in the isHandlerEnabled method.
     *              If a null class is passed as a parameter, a controlled exception is thrown.
     */
    @isTest
    static void test_IsHandlerEnabled_NullClass_KO()
    {
        Test.startTest();
        try
        {
            TriggerFactory.isHandlerEnabledInMetadata(null);
            Assert.fail('Tiene que dar una excepcion al pasar parametros a NULL');
        }
        catch(IllegalArgumentException error)
        {
            // Este es el error que se espera recibir en este test
            Assert.areEqual('Parameter handlerInstance can not be null', error.getMessage());

        }
        catch(Exception unexpectedError)
        {
            Assert.fail('The exception that has occurred is not the expected one: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }


    /**
     * Test method to validate the behavior of the validateParameterNotNull method
     * when a valid parameter is provided.
     */
    @isTest
    static void testValidateParameterNotNull_ValidParameter() {
        // Arrange
        String parameter = 'value';
        String parameterName = 'parameter';

        // Act & Assert
        Test.startTest();
        try
        {
            TriggerFactory.validateParameterNotNull(parameter, parameterName);
        }
        catch(Exception unexpectedError)
        {
            Assert.fail('This test should not have thorwn an exception: ' + unexpectedError.getMessage() + ' -- ' + unexpectedError.getStackTraceString());
        }
        Test.stopTest();
    }

    /**
     * Test method to validate the behavior of the validateParameterNotNull method
     * when a null parameter is provided.
     */
    @isTest
    static void testValidateParameterNotNull_NullParameter() {
        // Arrange
        Object parameter = null;
        String parameterName = 'parameter';

        // Act & Assert
        Test.startTest();
        try
        {
            TriggerFactory.validateParameterNotNull(parameter, parameterName);
            Assert.fail('Expected exception IllegalArgumentException was not thrown.');
        }
        catch (IllegalArgumentException error)
        {
            // Assert
            String expectedErrorMessage = 'Parameter parameter can not be null';
            String actualErrorMessage = error.getMessage();
            System.assertEquals(expectedErrorMessage, actualErrorMessage, 'Incorrect error message.');
        }
        Test.stopTest();
    }
}