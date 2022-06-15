/**
 * @description       : 
 * @author            : jgallaga
 * @group             : 
 * @last modified on  : 06-14-2022
 * @last modified by  : jgallaga
**/
public without sharing class QueryMakerUtil 
{
    public static String conditionEquivalence(QueryMaker.ConditionOption option)
    {
        if(option == null)
        {
            throw new QueryMaker.QueryMakerException('Can not return the equivalence of a null option');
        }

        switch on option 
        {
            when INLIST
            {
                return 'IN';
            }
            when NOTINLIST
            {
                return 'NOT IN';
            }
            when EQUALS
            {
                return '=';
            }
            when NOTEQUALS
            {
                return '!=';
            }
            when GREATER
            {
                return '>';
            }
            when GREATEREQUAL
            {
                return '>=';
            }
            when LESS
            {
                return '<';
            }
            when LESSEQUAL
            {
                return '<=';
            }
            when STARTSWITH, ENDSWITH, CONTAINS
            {
                return 'LIKE';
            }
            when else 
            {
                throw new QueryMaker.QueryMakerException('There is no condition value defined for this option: ' + option.name());
            }
        }
    }

    public static String getStringValueCondition(QueryMaker.ConditionOption option, String value)
    {
        switch on option 
        {
            when STARTSWITH
            {
                return ' \'' + value + '%\'';
            }
            when ENDSWITH
            {
                return ' \'%' + value + '\'';
            }
            when CONTAINS
            {
                return ' \'%' + value + '%\'';
            }
            when else 
            {
                return '\'' + value + '\'';
            }
        }
    }

    public static String getConditionConnectorValue(QueryMaker.ConditionConnector connector)
    {
        switch on connector 
        {
            when  ORCONDITION
            {
                return ' OR ';
            }
            when ANDCONDITION
            {
                return ' AND ';
            }
            when else 
            {
                throw new QueryMaker.QueryMakerException('There is no condition value defined for this connector: ' + connector.name());
            }
        }
    }
}
