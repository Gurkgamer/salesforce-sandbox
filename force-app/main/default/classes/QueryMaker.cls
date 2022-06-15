/**
 * @description       : Query Maker allows to create your own Query by adding the fields and conditions
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-15-2022
 * @last modified by  : jgallaga
 * 
 * Anonymous Usage Example:
    QueryMaker accountQueryMaker = new QueryMaker(Account.getSObjectType());
    accountQueryMaker.addField(Account.Name);
    accountQueryMaker.addField(Account.Phone);
    QueryMaker.QueryCondition multiCondition1 = accountQueryMaker.createCondition(QueryMaker.ConditionOption.STARTSWITH,Account.Name,'R');
    QueryMaker.QueryCondition multiCondition2 = accountQueryMaker.createCondition(QueryMaker.ConditionOption.ENDSWITH,Account.Name,'A');
    QueryMaker.QueryCondition singleCondition = accountQueryMaker.createCondition(QueryMaker.ConditionOption.CONTAINS,Account.Name,'B');
    List<QueryMaker.QueryCondition> myCOnditions = new List<QueryMaker.QueryCondition>();
    myConditions.add(multiCondition1);
    myConditions.add(multiCondition2);
    accountQueryMaker.addCombinedConditions(myConditions,QueryMaker.ConditionConnector.ORCONDITION);
    accountQueryMaker.addCondition(singleCondition);
    List<Account> results = (List<Account>)accountQueryMaker.execute(QueryMaker.ConditionConnector.ANDCONDITION);
    System.debug(results);
**/
public without sharing class QueryMaker
{
    private Schema.SObjectType querySObject;
    private Set<String> objectFields                = new Set<String>();
    private Map<Integer, String> queryConditions    = new Map<Integer, String>(); // TODO - El execute que permita condicionar mediante indice, ej. (1 OR 2) AND 3

    public enum ConditionOption 
    {
        EQUALS,
        NOTEQUALS,
        INLIST,
        NOTINLIST,
        GREATER,
        LESS,
        GREATEREQUAL,
        LESSEQUAL,
        STARTSWITH,
        ENDSWITH,
        CONTAINS
    }

    public enum ConditionConnector
    {
        ORCONDITION,
        ANDCONDITION
    }

    public QueryMaker(Schema.SObjectType objectType)
    {
        if(objectType == null)
        {
            throw new QueryMakerException('Can not start making a query with no SObject');
        }
        
        querySObject = objectType;
    }

    // Si no se añade campo, saca Id
    public void addField(Schema.SObjectField sObjectField)
    {
        if(sObjectField == null)
        {
            throw new QueryMakerException('Can not add a missing field to the query');
        }

        String fieldName = sObjectField.getDescribe().getName();
        objectFields.add(fieldName);
    }

    public void addFields(List<Schema.SObjectField> sObjectFields)
    {
        if(sObjectFields == null)
        {
            throw new QueryMakerException('Can not add a missing list of fields to the query');
        }

        for(SChema.SObjectField nextField : sObjectFields)
        {
            addField(nextField);
        }
    }

    // TODO - Hacer uno por cada tipo de valor, pues sus opciones de condicion varian segun tipo
    // Crea la condicion para agregar despues en addCondition. Usar varias veces por si se quiere generar una condicion combinada y añadirlas de golpe con addCombinedConditions
    public QueryCondition createCondition(ConditionOption option, Schema.SObjectField field, String value)
    {
        if(option == null)
        {
            throw new QueryMakerException('Can not make a condition without the condition option');
        }
        
        if(field == null)
        {
            throw new QueryMakerException('Can not make a condition without the field');
        }        
        
        if(option == ConditionOption.INLIST || option == ConditionOption.NOTINLIST)
        {
            throw new QueryMakerException('This is not a valid option for a single string value condition');
        }

        QueryCondition createdCondition = new QueryCondition(option, field, value);

        return createdCondition;
    }

    public void addCondition(QueryCondition condition)
    {
        if(condition == null)
        {
            throw new QueryMakerException('Can not add an empty condition');
        }

        Integer nextIndex = queryConditions.size() + 1;

        queryConditions.put(nextIndex,condition.getCondition());
    }

    public void addCombinedConditions(List<QueryCondition> conditions, ConditionConnector connector)
    {
        if(conditions == null || conditions.isEmpty())
        {
            throw new QueryMakerException('Can not add an empty collection of conditions');
        }

        if(connector == null)
        {
            throw new QueryMakerException('Can not add an empty collection of conditions');
        }

        List<String> stringyfiedConditions = new List<String>();

        for(QueryCondition nextCondition: conditions)
        {
            stringyfiedConditions.add(nextCondition.getCondition());
        }

        Integer nextIndex           = queryConditions.size() + 1;
        String combinedCondition    = ' ( ' +  String.join(stringyfiedConditions, QueryMakerUtil.getConditionConnectorValue(connector)) + ' ) ';

        queryConditions.put(nextIndex, combinedCondition);
    }

    public List<SObject> execute(ConditionConnector connector)
    {
        String query = '';
        //SELECT 
        query += getSelect();
        //FROM 
        query += getFrom();
        //WHERE
        query += getWhere(connector); // TODO - Permitir condicionar por indice, ej: (1 OR 2) AND 3

        System.debug('### ' + query);

        return Database.query(query);
    }    

    private String getSelect()
    {
        if(objectFields.isEmpty())
        {
            objectFields.add('Id');
        }

        String selectString = 'SELECT ' + String.join((Iterable<String>)objectFields, ', ');

        return selectString;
    }

    private String getFrom()
    {
        return ' FROM ' + querySObject.getDescribe().getName();
    }

    private String getWhere(ConditionConnector connector)
    {
        if(queryConditions.isEmpty())
        {
            return '';
        }

        return ' WHERE ' + String.join(queryConditions.values(),' ' + QueryMakerUtil.getConditionConnectorValue(connector) + ' ');
    }
    
    public class QueryMakerException extends Exception{}

    public class QueryCondition
    {
        private String conditionString;

        public QueryCondition(ConditionOption option, Schema.SObjectField field, String value)
        {
            conditionString = field.getDescribe().getName() + ' ' + QueryMakerUtil.conditionEquivalence(option) + ' ' + QueryMakerUtil.getStringValueCondition(option, value);
        }

        public String getCondition()
        {
            return conditionString;
        }
    }
}
