/**
 * @description  : Extracts and parses the information from Tooling Api.
 *
**/
public with sharing class ToolingApiFetcher extends MetadataFetcher{

    private static final string TOOLING ='Tooling';
    private static final string APEXTRIGGERS = 'ApexTriggers';
    private static final string BEFORETRIGGER = 'BeforeTrigger' ;
    private static final string AFTERTRIGGER = 'AfterTrigger';
    private static final String SUMMARY_FIELDS  = 'FieldDefinitions';
    private static final string ACTIVE = 'Active';
    private Boolean newComposite =  true; 
    private Integer countComposite = 0;
    private Map<String, String> objectsByLabel = new Map<String, String>();
    private Map<Integer,CompositeWrapper> compositesByCall = new Map<Integer,CompositeWrapper>();
    private List<compositeResponseWrapper> compositeResponses = new List<compositeResponseWrapper>();
    
    /**
    * @description main method that performs the API call together with the parsing of the response according to the categories and objects to filter
    * @param sobjectNames 
    * @param categories 
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String, List<CategoryOperation>> requestMetadata(List<String> sobjectNames, Set<String> categories) {
        init(sobjectNames, categories);

        String objects = '\''+ String.join(sobjectNames, '\',\'') + '\'';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:eXec_Ray/services/data/v53.0/tooling/composite');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Integer countCompositeUnit = 0;
        String filterObjects;
        String additionalFilter;
        String query;
        newComposite();
        Set<String> objectReferenceNames = getReferenceObjects(sobjectNames);
        for(CategorySetting__mdt category :CategorySettingHelper.getCategorySettingsByOperation(TOOLING)){
            CompositeWrapper composite = compositesByCall.get(this.countComposite);
            if(category.FilterObject__c &&!category.RepeatApi__c && 
            ((SUMMARY_FIELDS.equalsIgnoreCase(category.referenceId__c) && !objectReferenceNames.isEmpty()) ||
             !SUMMARY_FIELDS.equalsIgnoreCase(category.referenceId__c))) {
                CompositeWrapper.CompositeUnit unit = new CompositeWrapper.CompositeUnit();
                unit.method = 'GET';
                filterObjects = objects;
                additionalFilter = '';
                if(SUMMARY_FIELDS.equalsIgnoreCase(category.referenceId__c)) {
                    filterObjects = '\''+ String.join(new List<String>(objectReferenceNames), '\',\'') + '\'';
                     additionalFilter = ' AND DataType LIKE' + '\''+'%Summary%'+'\'';
                }
                query = 'SELECT '+ category.Fields__c + ' FROM ' +  category.ApiName__c + ' WHERE ' + category.FieldFilter__c + ' IN (' + filterObjects + ') ' + additionalFilter;
                unit.url = '/services/data/v53.0/tooling/query/?q='+ EncodingUtil.urlEncode(query, 'UTF-8');
                unit.referenceId = category.referenceId__c; 
                composite.compositeRequest.add(unit);
            }       
        }

        for(CompositeWrapper composite :compositesByCall.values()){
            req.setbody(JSON.serialize(composite));
            Http h = new Http();
            HttpResponse res = h.send(req);
            if(res.getStatusCode() == 200){
                CompositeResponseWrapper compositeResponseWrapper = (CompositeResponseWrapper) JSON.deserialize(res.getBody(),CompositeResponseWrapper.class);
                compositeResponses.add(compositeResponseWrapper);
            } else {
                throw new ToolingApiException(res.getStatus());
            }
        }
        this.parseMetadata();
        return this.operationsByObject;
    }

    /**
    * @description helper method that initializes the composite wrapper and saves it to the corresponding map
    **/
    private void newComposite(){
        if(this.newComposite){
            this.countComposite +=1;
            this.newComposite = false;
            CompositeWrapper composite = new CompositeWrapper();
            composite.allOrNone = 'true';
            composite.collateSubrequests = 'true';
            composite.compositeRequest = new List<CompositeWrapper.CompositeUnit>();
            compositesByCall.put(countComposite, composite);
        }
    }
    /**
    * @description initializes the parsing of the api response by looping through the compositeResponse
    **/
    protected override void parseMetadata() {
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        for(compositeResponseWrapper compositeResponse : compositeResponses){
            for(CompositeResponseWrapper.Bodys bodys : compositeResponse.compositeResponse) {
                if(bodys.body != null){
                    this.parseBaseMetadata(bodys.body.records, bodys.referenceId);
                }
            }
        }
        
    }
    /**
    * @description auxiliary method to parse the metadata, verifying if the rule corresponds to its parsing
    * @param rules 
    * @param reference 
    **/
    private void parseBaseMetadata(List<CompositeResponseWrapper.Records> rules, string reference){
        for(CompositeResponseWrapper.Records record : rules){
            if(SUMMARY_FIELDS.equalsIgnoreCase(reference)) {
                for(String objectLabel : objectsByLabel.keySet()) {
                    if(record.DataType.contains(objectLabel)) {
                        this.newParseMetadata(record, reference,objectLabel);
                    }
                }
            } else if(this.isActive(record.status, record.active)){
                this.newParseMetadata(record, reference, null);
            }
        }    
    }

    /**
    * @description helper method to create the new operation and add it in the corresponding category and object
    * @param record 
    * @param reference 
    * @param objectLabel
    **/
    private void newParseMetadata(CompositeResponseWrapper.Records record, String reference, string objectLabel){
        String  objectName = String.isNotBlank(objectLabel) ?objectsByLabel.get(objectLabel):record.EntityDefinition.QualifiedApiName;
        CategoryOperation.Operation newOperation = this.getNewOperation(record, objectName);
        if(APEXTRIGGERS.equalsIgnoreCase(reference)){
            reference = record.UsageAfterDelete||record.UsageAfterInsert||record.UsageAfterUndelete||record.UsageAfterUpdate? AFTERTRIGGER : BEFORETRIGGER;
            newOperation.developerName = String.isNotBlank(newOperation.namespace)? newOperation.namespace + '__' + newOperation.label: newOperation.label;
        }
        CategorySetting__mdt categorySetting = CategorySettingHelper.getCategorySettingByName(reference);
        Integer indexCategory = this.getCategoryIndex(categorySetting.label);
        this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
    }
    
    /**
    * @description method that based on a list of objects finds if there is a reference to other objects
    * @param sobjectNames 
    * @return Set<String> objectReferenceNames 
    **/
    private Set<String> getReferenceObjects(List<String> sobjectNames) {
        Set<String> objectReferenceNames = new Set<String>();
        for(String objectName : sobjectNames) {
            Schema.DescribeSObjectResult objectResult = Schema.getGlobalDescribe().get(objectName).getDescribe();
            objectsByLabel.put(objectResult.getLabel(), objectName);
            Map<String, Schema.SObjectField> objectFields = objectResult.fields.getMap();
            for(String fieldName : objectFields.keySet()) {
                String objectReferenceName = getReferenceFields(objectFields.get(fieldName).getDescribe());
                if(String.isNotBlank(objectReferenceName)) {
                    objectReferenceNames.add(objectReferenceName);
                }
            }
        }
        return objectReferenceNames;
    }

    /**
    * @description method that, depending on the field of the object, verifies if it is a reference to another object and returns the name of this referenced object
    * @param fieldResult 
    * @return String objectReferenceName
    **/
    private String getReferenceFields(Schema.DescribeFieldResult fieldResult) {
        Schema.DisplayType dType = fieldResult.getType();
        String objectReferenceName;
        if(dType == Schema.DisplayType.REFERENCE && fieldResult.getRelationshipOrder() == 0) {
            List<SObjectType> objects = fieldResult.getReferenceTo();
            for(SObjectType o : objects) {
                objectReferenceName = o.getDescribe().getName();
            }
        }
        return objectReferenceName;
    }
    /**
    * @description method that indicates if the rule is active or not
    * @param activeString
    * @param activeBoolean 
    * @return Boolean
    **/
    private Boolean isActive(String activeString, Boolean activeBoolean ){
        return String.isNotBlank(activeString) ? activeString.equalsIgnoreCase(ACTIVE): activeBoolean;
    }

    /**
    * @description method that instantiates a new operation
    * @param record
    * @param objectName 
    * @return CategoryOperation.Operation
    **/
    private CategoryOperation.Operation getNewOperation(CompositeResponseWrapper.Records record, string objectName) {
        CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
        if(String.isNotBlank(record.Label)){ // SummaryFields
            newOperation.label = record.Label + ' ('+ record.EntityDefinition.QualifiedApiName + ')' ;
            newOperation.developerName = record.QualifiedApiName;
        } else if(String.isNotBlank(record.Name)){
            newOperation.label = record.Name;
        } else {
            newOperation.label = record.ValidationName;
        }
        newOperation.namespace = record.NamespacePrefix;
        newOperation.createdDate =record.CreatedDate != null ? Datetime.valueOf(this.getDate(record.CreatedDate)):null;
        newOperation.lastModifiedDate = record.LastModifiedDate != null ?Datetime.valueOf(this.getDate(record.lastModifiedDate)): null;
        newOperation.developerName = String.isBlank(newOperation.developerName)? String.isNotBlank(newOperation.namespace)? newOperation.namespace + '__' + objectName + '.' + newOperation.label :objectName + '.' + newOperation.label: newOperation.developerName;
        return newOperation;
    }
    /**
    * @description method that transforms a GMT date from string to datetime
    * @param dateString
    * @return String
    **/
    private String getDate(string dateString){
        return dateString.replace('T', ' ').left(dateString.indexOf('.'));
    }
     /**
    * @description class Exception
    **/
    public class ToolingApiException extends Exception {
        
    }
}