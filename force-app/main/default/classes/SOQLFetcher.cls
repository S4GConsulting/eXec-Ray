/**
 * @description       : 
**/
public with sharing class SOQLFetcher extends MetadataFetcher{

    private final Map<String, List<String>> FIELDS_BY_TYPE = new Map<String, List<String>>{
        'DuplicateRule' => new List<String>{'DeveloperName', 'MasterLabel', 'NamespacePrefix', 'CreatedDate', 'LastModifiedDate','SobjectType'},
        'AssignmentRule' => new List<String>{'Name','CreatedDate','LastModifiedDate','SobjectType'},
        'SlaProcess' => new List<String>{'Name','NameNorm','CreatedDate','LastModifiedDate','SobjectType'}
    };

    // TODO: Remove category, should be in the MetadataFetcher.
    private final Map<String, Map<String, String>> OPERATION_MAPPING = new Map<String, Map<String, String>>{
        'DuplicateRule' => new Map<String, String>{
            'label' => 'MasterLabel',
            'developerName' => 'DeveloperName',
            'namespace' => 'NamespacePrefix',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate'
        },
        'AssignmentRule' => new Map<String, String>{
            'label' => 'Name',
            'developerName' => 'Name',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate'
        },
        'SlaProcess' => new Map<String, String>{
            'label' => 'Name',
            'developerName' => 'NameNorm',
            'createdDate' => 'CreatedDate',
            'lastModifiedDate' => 'LastModifiedDate'
        }
    };

    private List<SObject> metadataObjects = new List<SObject>();

    public SOQLFetcher(List<String> sobjectNames, List<String> categories) {
        super(sobjectNames, categories);
    }

    public override Map<String, List<CategoryOperation>> requestMetadata() {
        // Need to do 3 different queries depending the object passed
        // For each object, launch a query.
        for(String type : FIELDS_BY_TYPE.keySet()) {
            String fields = String.join(FIELDS_BY_TYPE.get(type), ',');
            String objects = String.join(this.sobjectNames, '\',\'');
            String query = 'SELECT ' + String.escapeSingleQuotes(fields) + ' FROM ' + String.escapeSingleQuotes(type) + ' WHERE SobjectType IN (\'' + objects + '\')';
            metadataObjects.addAll(Database.query(query));
        }

        parseMetadata();

        return this.operationsByObject;
    }

    protected override void parseMetadata() {
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();

        for(SObject metadataObject : metadataObjects) {
            //For each SObject need to know which mapping apply
            String objectName = metadataObject.getSObjectType().getDescribe().getName();
            CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
            newOperation.label = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('label'));
            newOperation.developerName = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('developerName'));
            newOperation.namespace = (String)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('namespace'));
            newOperation.createdDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('createdDate')));
            newOperation.lastModifiedDate = (Datetime)(getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('lastModifiedDate')));
            //System.debug((Datetime)getFieldValue(metadataObject, OPERATION_MAPPING.get(objectName).get('createdDate')));
            Integer indexCategory = this.getCategoryIndex(CATEGORIES_MAPPING.get(objectName));
            //Each record needs to be added to the map with the corresponding SObjectType that it belongs to
            this.operationsByObject.get((String)metadataObject.get('SobjectType'))[indexCategory].operations.add(newOperation);
        }
    }

    private Object getFieldValue(SObject metadataObject, String fieldName) {
        Object fieldValue = fieldName != null ? metadataObject.get(fieldName) : null;
        return fieldValue;
    }
}
