/**
 * @description       : 
**/
public with sharing class SOQLFetcher extends MetadataFetcher{
    
    private final string SOQL ='SOQL';
    private final Map<String, Map<String, String>> OPERATION_MAPPING = new Map<String, Map<String, String>>{
        'DuplicateRule' => new Map<String, String>{
            'label' => 'MasterLabel',
            'developerName' => 'DeveloperName',
            'namespace' => 'NamespacePrefix',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate',
            'active' => 'IsActive'
        },
        'AssignmentRule' => new Map<String, String>{
            'label' => 'Name',
            'developerName' => 'Name',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate',
            'active' => 'Active'
        },
        'SlaProcess' => new Map<String, String>{
            'label' => 'Name',
            'developerName' => 'NameNorm',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate',
            'active' => 'IsActive'
        }
    };

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
        for(Category_Setting__mdt category : CategorySettingHelper.getCategorySettingsByOperation(SOQL)){
            String query = 'SELECT ' + category.Fields__c+ ' FROM ' + category.ApiName__c + ' WHERE SobjectType IN :sobjectNames';
            metadataObjects.addAll(Database.query(String.escapeSingleQuotes(query)));
        //for(String type : FIELDS_BY_TYPE.keySet()) {
        //    String fields = String.join(FIELDS_BY_TYPE.get(type), ',');
        //    String query = 'SELECT ' + fields + ' FROM ' + type + ' WHERE SobjectType IN :sobjectNames';
        //    metadataObjects.addAll(Database.query(String.escapeSingleQuotes(query)));
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

            if ((Boolean)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('active'))){
                CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
                newOperation.label = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('label'));
                newOperation.developerName = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('developerName'));
                newOperation.namespace = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('namespace'));
                newOperation.createdDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('createdDate')));
                newOperation.lastModifiedDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('lastModifiedDate')));
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