# Log Platform Event

## Description

Framework for publishing platform events to log information into the Salesforce Event Bus. The Log Event Builder class implements the Builder pattern, allowing easy creation of log records with customizable field values. Developers can selectively fill the fields that are relevant to their needs. The LogEventBuilderHelper class provides a convenient way to manage and publish batches of log events. Log records are stored until they are ready to be published collectively.

## Apex Class: Log Event Builder Helper

This class will manage the creation and publication of the log events. Every time a new  log record is needed, a builder instance will be created to be able to populate the needed fields by using a Builber pattern. Check the Log Event Builder class section to learn how to use this pattern.

The helper class will keep each record created until they are published. Each time is published, the helper will be cleared to publish the new record created after.

### Methods

- [createLogEventBuilder(message)](#createLogEventBuilder(message))

    Creates a new LogEventBuilder instance with the provided message and adds it to the list of events.

- [publish()](#publish())

    Prepares the accumulated log events for publishing and publishes them. The list of record instances will be cleared.

- [resetLogEvents()](#resetLogEvents())

    Allows to remove the LogEventBuilder instances that are present in the helper.


#### **> createLogEventBuilder(message)**
---

Creates a new LogEventBuilder instance with the provided message and adds it to the list of events.

**Signature**

`public static LogEventBuilder createLogEventBuilder(String message)`

**Parameters**

*message*

Type: String

**Return value**

Type: LogEventBuilder

**Usage**

Call this method to receive a new instance of LogEventBuilder.

    LogEventBuilderHelper.createLogEventBuilder('Log event message');

#### **> publish()**
---

Prepares the accumulated log events for publishing and publishes them to the Event bus. The list of record instances will be cleared.

**Signature**

`public static List<Database.SaveResult> publish()`

**Return value**

Type: List<Database.SaveResult>

A list with the publishing results of the log events records to the Event bus. The list of record instances will be cleared.

#### **> resetLogEvents()**
---

Allows to remove the LogEventBuilder instances that are present in the helper without publishing.

**Signature**

`public static void resetLogEvents()`

**Return value**

Type: void

## Apex Class : Log Event Builder

This class implements the builder pattern. It allows developers to construct event logs according to their needs by calling specific methods in a chain. By using the builder pattern, developers can easily customize and create flexible event logs. The class also includes a print() method for debugging purposes.

For example:

`new LogEventBuilder().message('The value of Account name is: ' + record.Name).sourceClass('AccountHandler').type(LogEventBuilder.EventType.LOG).print()`

Check the Usage section to examine the different approaches it can be taken on.

### Methods

- [LogEventBuilder()]()

    Constructor class. Instantiating a new builder will fill system related fields with default values.

- [build()]()

    Transforms a LogEventBuilder instance and returns a Log__e instance.

- [print()]()

    Prints into the Salesforce debug logs the contents of the instance.

- [message(message)]()

    Add a message to the log.

- [recordId(recordId)]()

    Add a Salesforce Id to the log.

- [externalId(externalId)]()

    Use this method to add an External Id to the log.

- [sourceClass(sourceClass)]()

    Use this method to report from withing which class is the log being added.

- [type(type)]()

    With the EventType enumerator of LogEventBuilder, classify the log.

- [userId(userId)]()

    Add a user Id to the log.

- [exception(error)]()

    This method will save the exception data to the log.

- [dmlFieldsException(dmlError, dmlErrorIndex)]()

    This method can be used to log a DML entry of a DMLException with its details onto a log.

#### **> LogEventBuilder()**
---

Constructor class. Instantiating a new builder will fill system related fields with default values.
The values are:

- transactionId
    Contains the current transaction ID
- type
    By default, a LogEventBuilder will have a "LOG" type
- eventTime
    When a instance is made, this field will hace the current DateTime

**Signature**

`public LogEventBuilder()`

**Return value**

Type: LogEventBuilder

#### **> build()**
---

**Signature**

`public Log__e build()`

*Return Value**

Type: Log__e

This is the platform event entity. You can publish this record to the Event Bus.

#### **> print()**
---

Allows to print into the Salesforce Log files the content of the intance up to that point.
The log lines will be precededd with a "@@@@@@@@" string. Only the values with data will be print.

**Signature**

`public LogEventBuilder print()`

**Return Value**

Type: LogEventBuilder

#### **> message(message)**
---

Add a message to the log.

**Signature**

`public LogEventBuilder message(String message)`

**Parameters**

*message*

Type: String

**Return Value**

Type: LogEventBuilder**

#### **> recordId(recordId)**
---

Add a Salesforce Id to the log.

**Signature**

`public LogEventBuilder recordId(Id recordId)`

**Parameters**

*recordId*

Type: Id

**Return Value**

Type: LogEventBuilder

#### **> externalId(externalId)**
---

Use this method to add an External Id to the log.

**Signature**

`public LogEventBuilder externalId(String externalId)`

**Parameters**

*externalId*

Type: String

**Return Value**

LogEventBuilder

#### **> sourceClass(sourceClass)**
---

Use this method to report from withing which class is the log being added.

**Signature**

`public LogEventBuilder sourceClass(String sourceClass)`

**Parameters**

*sourceClass**

Type: String

**Return Value**

Type: LogEventBuilder

#### **> type(type)**
---

With the EventType enumerator of LogEventBuilder, classify the log.

**Signature**

`public LogEventBuilder type(EventType type)`

**Parameters**

*type*

Type: EventType

Enum atrribute in the LogEventBuilder class.

**Return Value**

Type: LogEventBuilder

**Usage**

`LogEventBuilder event = new LogEventBuilder().type(LogEventBuilder.EventType.LOG);`

#### **> userId(userId)**
---

Add a user Id to the log.

**Signature**

`public LogEventBuilder userId(Id userId)`

**Parameter**

*userId*

Type: Id

**Return Value**

Type: LogEventBuilder

#### **> exception(error)**

This method will save any kind of exception data to the log.

**Signature**

`public LogEventBuilder exception(Exception exceptionError)`

**Parameter**

exceptionError

Type: Exception

This method will accept aky type of Exception. To log each individual error found in DMLException use the *dmlFieldsException* method.

**Return Value**

Type. LogEventBuilder

#### **> dmlFieldsException(dmlError, dmlErrorIndex)**
---

This method can be used to log a DML entry of a DMLException with its details onto a log.

**Signature**

`public LogEventBuilder  dmlFieldsException(DmlException dmlError, Integer dmlErrorIndex)`

**Parameters**

*dmlError*

Type: DMLException

*dmlErrorIndex*

Type: Integer

**Return Value**

Type. LogEventBuilder

# Usage

Each LogEventBuilder instance can be stored in a variable of that type or build it to a Log__e instance to modify directly that record.

The Builder pattern allows the developer to fill only the values necesary but without the need of using multiple overloaded method. Just call the ones that will carry information. Each method will return itself allowing to call the next method right away. Finish the building process with the build method.

Examples:

    Log__e newEvent = new LogEventBuilder()
    .message('Debug message')
    .build();
---
    `Log__e newEvent = new LogEventBuilder()
        .message('Debug message')
        .type(LogEventBuilder.EventType.ERROR)
        .userId(UserInfo.getUserId()
        .build());`
---
    List<Account> nameAccounts = new List<Account>();

    for(Integer i = 0; i<10; i++)
    {
        nameAccounts.add(new Account());
    }

    try
    {
        insert nameAccounts;
    }
    catch(DMLException dmlError)
    {
        List<Log__e> errorEvents = new List<Log__e>();

        errorEvents.add(new LogEventBuilder().exception(dmlError).print().build());

        for(Integer i = 0; i < dmlError.getNumDml(); i++)
        {
            errorEvents.add(new LogEventBuilder().dmlFieldsException(dmlError,i).print().build());
        }

        EventBus.publish(errorEvents);
    }
---
    new LogEventBuilder()
    .message('The value of Account name is: ' + record.Name)
    .sourceClass('AccountHandler')
    .type(LogEventBuilder.EventType.LOG)
    .print();

# Files

This module is composed of the following files:

**Apex Class**
- LogEventBuilderHelper.cls
- LogEventBuilderHelper.cls-meta.xml
- LogEventBuilderHelperTest.cls
- LogEventBuilderHelperTest.cls-meta.xml
- LogEventBuilder.cls
- LogEventBuilder.cls-meta.xml
- LogEventBuilderTest.cls
- LogEventBuilderTest.cls-meta.xml

**Custom Object**
- Log__e
    - Log__e.object-meta.xml
    - fields
        - DMLExceptionFields__c.field-meta.xml
        - EventTime__c.field-meta.xml
        - ExceptionCause__c.field-meta.xml
        - ExceptionMessage__c.field-meta.xml
        - ExceptionStackTrace__c.field-meta.xml
        - ExceptionType__c.field-meta.xml
        - ExternalId__c.field-meta.xml
        - Message__c.field-meta.xml
        - RecordId__c.field-meta.xml
        - SourceClass__c.field-meta.xml
        - TransactionId__c.field-meta.xml
        - Type__c.field-meta.xml
        - UserId__c.field-meta.xml
