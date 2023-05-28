# Trigger Factory

## Description

Class that implements the Factory pattern for managing Salesforce triggers. It allows executing the trigger context in an organized and clear manner, regardless of the originating entity. By using metadata, it is possible to configure the avoidance of executing the Handler class. The trigger should call the public method, passing the instantiation of the Handler class that implements the ITriggerHandler interface, to ensure the execution of the corresponding operation based on the context.

Author: Gurkgamer
Last modified on: 05-28-2023
Last modified by: Gurkgamer

## Apex Class: TriggerFactory

### manageTrigger

Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

#### Method Signature

`public static void manageTrigger(ITriggerHandler handlerInstance)`

#### Parameters

- `handlerInstance` (ITriggerHandler) - The class on which the Trigger functionality should be executed. It must implement the ITriggerHandler interface.

### execute

Method that executes the context of a trigger based on its operation enumerator. It only accepts classes that implement the ITriggerHandler interface as parameters. The TriggerOperation parameter indicates in which context the Trigger Factory will execute.

#### Method Signature

`private static void execute(ITriggerHandler handlerInstance, System.TriggerOperation triggerOperation)`

#### Parameters

- `handlerInstance` (ITriggerHandler) - The class from which the Trigger methods should be executed.
- `triggerOperation` (System.TriggerOperation) - Parameter that indicates the execution context of the Trigger Factory.

### validateParameterNotNull

Validates that the specified parameter is not null. If the parameter is null, an IllegalArgumentException is thrown with the corresponding parameter name and an error message.

#### Method Signature

`private static void validateParameterNotNull(Object parameter, String parameterName)`

#### Parameters

- `parameter` (Object) - The parameter to validate.
- `parameterName` (String) - The name of the parameter.

### TriggerFactoryException

Exception class used by TriggerFactory.

## Metadata

### TriggerSetup__mdt

Custom metadata type used to configure the activation status of the Handler class.

## Test Methods

The following test methods are available for the TriggerFactory class:

- `testManageTrigger_ValidParameters`: Tests the manageTrigger method with valid parameters.
- `testManageTrigger_NullHandlerInstance`: Tests the manageTrigger method with a null handler instance.
- `testExecute_ValidParameters`: Tests the execute method with valid parameters.
- `testExecute_NullHandlerInstance`: Tests the execute method with a null handler instance.
- `testExecute_NullTriggerOperation`: Tests the execute method with a null trigger operation.
- `testIsHandlerEnabledInMetadata_ValidHandler`: Tests the isHandlerEnabledInMetadata method with a valid handler instance and configured metadata.
- `testIsHandlerEnabledInMetadata_InvalidHandler`: Tests the isHandlerEnabledInMetadata method with an invalid handler instance.
- `testGetTriggerSetup_ValidHandler`: Tests the getTriggerSetup method with a valid handler instance and configured metadata.
- `testGetTriggerSetup_InvalidHandler`: Tests the getTriggerSetup method with an invalid handler instance.
- `testSetTriggerSetup_ValidParameters`: Tests the setTriggerSetup method with valid parameters.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
