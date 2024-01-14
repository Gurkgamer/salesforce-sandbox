/**
 * @description       : A utility class for comparing SObjects based on a specified field.
 * @author            : Gurkgamer
 * @last modified on  : 01-14-2024
 * @last modified by  : Gurkgamer
**/
public without sharing class RecordComparator implements Comparator<SObject>
{
    private Schema.SObjectField field;
    private Schema.SObjectType sObjectType;

    public RecordComparator(Schema.sObjectField fieldName)
    {
        if(fieldName == null)
        {
            throw new IllegalArgumentException('Null value received. A valid field must be provided');
        }

        field = fieldName;
        sObjectType = fieldName.getDescribe().getSObjectType();
    }

    public Integer compare(SObject exhibitA, SObject exhibitB)
    {

        if(exhibitA.getSObjectType() != sObjectType || exhibitB.getSObjectType() != sObjectType)
        {
            throw new IllegalArgumentException('The field provided does not belong to the SObjects that are being compared.');
        }

        Integer nullFieldsResult = checkNullFields(exhibitA, exhibitB);

        if(nullFieldsResult != null)
        {
            return nullFieldsResult;
        }

        // https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_enum_Schema_DisplayType.htm

        switch on field.getDescribe().getType()
        {
            when String
            {
                return new CompareStrings(field).compare(exhibitA, exhibitB);
            }
            when Integer, Double
            {
                return new CompareIntegers(field).compare(exhibitA, exhibitB);
            }
            when else
            {
                return 0;
            }
        }
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

    private class CompareStrings
    {
        private Schema.sObjectField field;

        /**
         * @param schemaField The field to be used for comparison.
         */
        public CompareStrings(Schema.sObjectField schemaField)
        {
            field = schemaField;
        }

        /**
         * @param exhibitA The first SObject to compare.
         * @param exhibitB The second SObject to compare.
         * @return 0 if both fields are null, -1 if exhibitA is null, 1 if exhibitB is null, or the lexicographical comparison result.
         * @throws IllegalArgumentException if the SObject types do not match the expected type.
         * @throws SObjectException if an error occurs during field retrieval.
         */
        public Integer compare(SObject exhibitA, SObject exhibitB)
        {
            String aField;
            String bField;

            try
            {
                aField = (String) exhibitA.get(field);
                bField = (String) exhibitB.get(field);
            }
            catch(SObjectException error)
            {
                throw new SObjectException('The field ' + field + ' could not be retrieved. ' + error.getStackTraceString());
            }

            return aField.compareTo(bField);
        }
    }

    public class CompareIntegers
    {
        private Schema.sObjectField field;

        public CompareIntegers(Schema.SObjectField schemaField)
        {
            field = schemaField;
        }

        public Integer compare(SObject exhibitA, SObject exhibitB)
        {
            try
            {
                Double aField = (Double) exhibitA.get(field);
                Double bField = (Double) exhibitB.get(field);

                if(aField == bField)
                {
                    return 0;
                }
                else if(aField < bField)
                {
                    return -1;
                }

                return 1;
            }
            catch(SObjectException error)
            {
                throw new SObjectException('The field ' + field + ' could not be retrieved. ' + error.getStackTraceString());
            }
        }

    }

}