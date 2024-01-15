/**
 * @description       : A utility class for comparing SObjects based on a specified field.
 * @author            : Gurkgamer
 * @last modified on  : 01-15-2024
 * @last modified by  : Gurkgamer
**/
public without sharing class RecordComparator implements Comparator<SObject>
{
    private Schema.SObjectField field;
    private Schema.SObjectType sObjectType;
    private Integer orderDirection = 1; // Positive is Ascending

    // Check is multiCurrency is active to enable comparisons between currencies
    private static Boolean multiCurrencyEnabled = Schema.getGlobalDescribe().containsKey('CurrencyType');
    private static Map<String, Decimal> currencyConversions
    {
        get
        {
            if(currencyConversions != null)
            {
                return currencyConversions;
            }

            currencyConversions = new Map<String, Decimal>();
            String queryCurrencyType = 'SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE';

            for(Sobject ct : Database.query(queryCurrencyType))
            {
                currencyConversions.put((String) ct.get('ISOCode'), (Decimal) ct.get('ConversionRate'));
            }

            return currencyConversions;
        }
        private set;
    }

    // #region Constructor

    public RecordComparator(Schema.sObjectField fieldName)
    {
        setupComparator(fieldName);
    }

    public RecordComparator(Schema.sObjectField fieldName, Boolean ascending)
    {
        setupComparator(fieldName);

        orderDirection = ascending == null || ascending ? 1 : -1;
    }

    private void setupComparator(Schema.sObjectField fieldName)
    {
        if(fieldName == null)
        {
            throw new IllegalArgumentException('Null value received. A valid field must be provided');
        }

        field = fieldName;
        sObjectType = fieldName.getDescribe().getSObjectType();
    }

    // #endregion

    // #region Comparator implementation

    public Integer compare(SObject exhibitA, SObject exhibitB)
    {
        if(exhibitA == null || exhibitB == null)
        {
            throw new IllegalArgumentException('Arguments cannot be null.');
        }

        if(exhibitA.getSObjectType() != sObjectType || exhibitB.getSObjectType() != sObjectType)
        {
            throw new IllegalArgumentException('The field provided does not belong to the SObjects that are being compared.');
        }

        Integer nullFieldsResult = checkNullFields(exhibitA, exhibitB);

        if(nullFieldsResult != null)
        {
            return nullFieldsResult * orderDirection;
        }

        // https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_enum_Schema_DisplayType.htm

        Integer comparisonResult;

        switch on field.getDescribe().getType()
        {
            when String, Id, Picklist
            {
                comparisonResult = compareStrings(exhibitA, exhibitB);
            }
            when Integer, Double, Long
            {
                comparisonResult = compareInteger(exhibitA, exhibitB);
            }
            when Currency
            {
                if(multiCurrencyEnabled)
                {
                    comparisonResult = compareCurrencyWithConversion(exhibitA, exhibitB);
                }
                else
                {
                    comparisonResult = compareCurrency(exhibitA,exhibitB);
                }
            }
            when else
            {
                return 0;
            }
        }

        return comparisonResult * orderDirection;
    }

    private Integer checkNullFields(SObject exhibitA, SObject exhibitB)
    {
        if(exhibitA?.get(field) == null && exhibitB?.get(field) == null)
        {
            return 0;
        }
        else if(exhibitA?.get(field) == null)
        {
            return -1;
        }
        else if(exhibitB?.get(field) == null)
        {
            return 1;
        }

        return null;
    }

    // #endregion

    private Integer compareStrings(SObject exhibitA, SObject exhibitB)
    {
        String aField;
        String bField;

        aField = (String) exhibitA.get(field);
        bField = (String) exhibitB.get(field);

        return aField.compareTo(bField);
    }

    private Integer compareInteger(SObject exhibitA, SObject exhibitB)
    {
        Double aField = (Double) exhibitA.get(field);
        Double bField = (Double) exhibitB.get(field);

        if(aField < bField)
        {
            return -1;
        }
        else if(aField > bField)
        {
            return 1;
        }

        return 0;
    }

    private Integer compareCurrency(SObject exhibitA, SObject exhibitB)
    {
        Decimal aField = (Decimal) exhibitA.get(field);
        Decimal bField = (Decimal) exhibitB.get(field);

        if(aField < bField)
        {
            return -1;
        }
        else if(aField > bField)
        {
            return 1;
        }

        return 0;
    }

    private Integer compareCurrencyWithConversion(SObject exhibitA, SObject exhibitB)
    {
        map<string,decimal> queriedcurrencies = new map<string,decimal>();

        String queryCurrencyType = 'SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE';

        String currencyCodeA = (String) exhibitA.get('CurrentIsoCode');
        Decimal convertedValueA = (Decimal) exhibitA.get(field) / currencyConversions.get(currencyCodeA);

        String currencyCodeB = (String) exhibitB.get('CurrentIsoCode');
        Decimal convertedValueB = (Decimal) exhibitB.get(field) / currencyConversions.get(currencyCodeB);

        if(convertedValueA == convertedValueB)
        {
            return 0;
        }
        else if(convertedValueA < convertedValueB)
        {
            return -1;
        }

        return 1;
    }
}