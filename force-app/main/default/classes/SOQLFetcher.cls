/**
 * @description: Extracts and parses the information from SOQL. 
**/
public with sharing class SOQLFetcher extends MetadataFetcher{
    
    private final string SOQL ='SOQL';
    private List<SObject> metadataObjects = new List<SObject>();

    /**
    * @description Query each object dinamically for each supported type
    * @param sobjectNames 
    * @param categories 
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String, List<CategoryOperation>> requestMetadata(List<String> sobjectNames, Set<String> categories) {
        init(sobjectNames, categories);
        // Need to do 3 different queries depending the object passed
        // For each object, launch a query.
        for(CategorySetting__mdt category : CategorySettingHelper.getCategorySettingsByOperation(SOQL)){
            String query = 'SELECT ' + category.Fields__c+ ' FROM ' + category.ApiName__c + ' WHERE SobjectType IN :sobjectNames';
            metadataObjects.addAll(Database.query(String.escapeSingleQuotes(query)));
        }

        parseMetadata();

        return this.operationsByObject;
    }

    /**
    * @description Parse each of the entities into a CategoryOperation and stores to the corresponding object
    **/
    protected override void parseMetadata() {
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();

        for(SObject metadataObject : metadataObjects) {
            //For each SObject need to know which mapping apply
            String objectName = metadataObject.getSObjectType().getDescribe().getName();
            Type t = Type.forName('OperationMapping.' + objectName);
            OperationMapping opMapping = (OperationMapping)t.newInstance();
            if ((Boolean)getFieldValue(metadataObject, opMapping.active)){
                CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
                newOperation.label = (String)getFieldValue(metadataObject, opMapping.label);
                newOperation.developerName = (String)getFieldValue(metadataObject, opMapping.developerName);
                newOperation.namespace = (String)getFieldValue(metadataObject, opMapping.namespace);
                newOperation.createdDate = (Datetime)(getFieldValue(metadataObject, opMapping.createdDate));
                newOperation.lastModifiedDate = (Datetime)(getFieldValue(metadataObject, opMapping.lastModifiedDate));
                Integer indexCategory = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(objectName).label);
                //Each record needs to be added to the map with the corresponding SObjectType that it belongs to
                this.operationsByObject.get((String)metadataObject.get('SobjectType'))[indexCategory].operations.add(newOperation);
            }
                
        }
    }

    /**
    * @description Get field value regardless of type
    * @param metadataObject 
    * @param fieldName 
    * @return Object 
    **/
    private Object getFieldValue(SObject metadataObject, String fieldName) {
        Object fieldValue = fieldName != null ? metadataObject.get(fieldName) : null;
        return fieldValue;
    }
}