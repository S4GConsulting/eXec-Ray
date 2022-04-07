/**
 * @description       : 
**/
public with sharing class SOQLFetcher extends MetadataFetcher{

    private final Map<String, List<String>> FIELDS_BY_TYPE = new Map<String, List<String>>{
        'DuplicateRule' => new List<String>{'DeveloperName', 'MasterLabel', 'NamespacePrefix', 'CreatedDate', 'LastModifiedDate','SobjectType', 'IsActive'},
        'AssignmentRule' => new List<String>{'Name','CreatedDate','LastModifiedDate','SobjectType', 'Active'},
        'SlaProcess' => new List<String>{'Name','NameNorm','CreatedDate','LastModifiedDate','SobjectType','IsActive' }
    };

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
    public override Map<String, List<CategoryOperation>> requestMetadata(List<String> sobjectNames, List<String> categories) {
        init(sobjectNames, categories);
        // Need to do 3 different queries depending the object passed
        // For each object, launch a query.
        for(String type : FIELDS_BY_TYPE.keySet()) {
            String fields = String.join(FIELDS_BY_TYPE.get(type), ',');
            String query = 'SELECT ' + fields + ' FROM ' + type + ' WHERE SobjectType IN :sobjectNames';
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
            if ((Boolean)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('active'))){
                CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
                newOperation.label = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('label'));
                newOperation.developerName = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('developerName'));
                newOperation.namespace = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('namespace'));
                newOperation.createdDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('createdDate')));
                newOperation.lastModifiedDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('lastModifiedDate')));
                Integer indexCategory = this.getCategoryIndex(CATEGORIES_MAPPING.get(objectName));
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