# Trigger Factory

## Description

Class that implements the Factory pattern for managing Salesforce triggers. It allows executing the trigger context in an organized and clear manner, regardless of the originating entity. By using metadata, it is possible to configure the avoidance of executing the Handler class. The trigger should call the public method, passing the instantiation of the Handler class that implements the ITriggerHandler interface, to ensure the execution of the corresponding operation based on the context.

## Apex Class: TriggerFactory

### manageTrigger

Executes trigger functionality for a specified handler class implementing the ITriggerHandler interface.

#### Method Signature

`public static void manageTrigger(ITriggerHandler handlerInstance)`

### TriggerSetup__mdt

Custom metadata type used to configure the activation status of the Handler class.