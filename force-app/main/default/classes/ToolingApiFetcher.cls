/**
 * @description  : Extracts and parses the information from Tooling Api.
 *
**/
public with sharing class ToolingApiFetcher extends MetadataFetcher{

    private static final string APEXTRIGGERS = 'ApexTriggers';
    private static final string BEFORETRIGGER = 'BeforeTrigger' ;
    private static final string AFTERTRIGGER = 'AfterTrigger';
    private static final string AUTORESPONSERULES = 'AutoResponseRules';
    private static final string VALIDATIONRULES = 'ValidationRules';
    private static final string WORKFLOWSRULES = 'WorkflowRules';
    private static final string ACTIVE = 'Active';
    private CompositeResponseWrapper compositeResponseWrapper;
     

    /**
    * @description
    * @param sobjectNames 
    * @param categories 
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String, List<CategoryOperation>> requestMetadata(List<String> sobjectNames, List<String> categories) {
        init(sobjectNames, categories);
        CategorySettingHelper.fillCategory();
        String objects = '\''+ String.join(this.sobjectNames, '\',\'') + '\'';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getOrgDomainURL().toExternalForm() + '/services/data/v53.0/tooling/composite');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + Session__c.getInstance().SessionId__c);
        req.setHeader('Content-Type', 'application/json');
        CompositeWrapper composite = new CompositeWrapper();
        composite.allOrNone = 'true';
        composite.collateSubrequests = 'true';
        composite.compositeRequest = new List<CompositeWrapper.CompositeUnit>();
        
        for(Category_Setting__mdt category :CategorySettingHelper.getAllCategorySettingsTooling()){
            if(category.FilterObject__c && !category.RepeatApi__c){
                CompositeWrapper.CompositeUnit unit = new CompositeWrapper.CompositeUnit();
                unit.method = 'GET';
                unit.url = '/services/data/v53.0/tooling/query/?q=SELECT +'+ category.Fields__c.replace(',', ',+') + ' + FROM + ' + category.ApiName__c+ '+ WHERE + ' + category.Field_Filter__c + ' + IN + (' + objects +  ')';
                unit.referenceId = category.referenceId__c;  
                composite.compositeRequest.add(unit);
            }       
        }
        req.setbody(JSON.serialize(composite));
        Http h = new Http();
        HttpResponse res = h.send(req);
        if(res.getStatusCode() == 200){
            this.compositeResponseWrapper = (CompositeResponseWrapper) JSON.deserialize(res.getBody(),CompositeResponseWrapper.class);
            this.parseMetadata();
        }
        else{
            throw new ToolingApiException(res.getStatus());
        }
        
        return this.operationsByObject;
    }

    /**
    * @description Parse each of the entities into a CategoryOperation and stores to the corresponding object
    **/
    protected override void parseMetadata() {
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        for(CompositeResponseWrapper.Bodys bodys : this.compositeResponseWrapper.compositeResponse) {
            Category_Setting__mdt categorySetting;
            if(APEXTRIGGERS.equalsIgnoreCase(bodys.referenceId)){
                this.parseApexTriggerRule(bodys.body.records);
            }else if(AUTORESPONSERULES.equalsIgnoreCase(bodys.referenceId)){
                this.parseAutoResponseRule(bodys.body.records);
            }else if(VALIDATIONRULES.equalsIgnoreCase(bodys.referenceId)){
                this.parseValidationRule(bodys.body.records);
            }else if(WORKFLOWSRULES.equalsIgnoreCase(bodys.referenceId)){
                this.parseWorkflowRule(bodys.body.records);
            }
        }
    }
    private void parseApexTriggerRule(List<CompositeResponseWrapper.Records> rules){
        for(CompositeResponseWrapper.Records record : rules){
            if(ACTIVE.equalsIgnoreCase(record.status)){
                String reference = record.UsageAfterDelete||record.UsageAfterInsert||record.UsageAfterUndelete||record.UsageAfterUpdate? AFTERTRIGGER : BEFORETRIGGER;
                Category_Setting__mdt categorySetting = CategorySettingHelper.getCategorySettingTooling(reference);
                Integer indexCategory = this.getCategoryIndex(categorySetting.label);
                String objectName = record.EntityDefinitionId;
                CategoryOperation.Operation newOperation = this.getNewOperation(record, objectName);
                newOperation.developerName = String.isNotBlank(newOperation.namespace)? newOperation.namespace + '__' + newOperation.label:newOperation.label;
                this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
            }
        }
    }
    private void parseAutoResponseRule(List<CompositeResponseWrapper.Records> rules){
        for(CompositeResponseWrapper.Records record : rules){
            if(record.active){
                Category_Setting__mdt categorySetting = CategorySettingHelper.getCategorySettingTooling(AUTORESPONSERULES);
                Integer indexCategory = this.getCategoryIndex(categorySetting.label);
                String objectName = record.EntityDefinitionId;
                CategoryOperation.Operation newOperation = this.getNewOperation(record, objectName);
                this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
            }
        }
    }
    private void parseValidationRule(List<CompositeResponseWrapper.Records> rules){
        for(CompositeResponseWrapper.Records record : rules){
            if(record.active){
                Category_Setting__mdt categorySetting = CategorySettingHelper.getCategorySettingTooling(VALIDATIONRULES);
                Integer indexCategory = this.getCategoryIndex(categorySetting.label);
                String objectName = record.EntityDefinitionId;
                CategoryOperation.Operation newOperation = this.getNewOperation(record, objectName);
                this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
            }
        }
    }
    private void parseWorkflowRule(List<CompositeResponseWrapper.Records> rules){
        for(CompositeResponseWrapper.Records record : rules){
            Category_Setting__mdt categorySetting = CategorySettingHelper.getCategorySettingTooling(WORKFLOWSRULES);
            Integer indexCategory = this.getCategoryIndex(categorySetting.label);
            String objectName = record.TableEnumOrId;
            CategoryOperation.Operation newOperation = this.getNewOperation(record, objectName);
            this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
        }
    }
    private CategoryOperation.Operation getNewOperation(CompositeResponseWrapper.Records record, string objectName) {
        CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
        newOperation.label =  String.isNotBlank(record.Name) ? record.Name : record.ValidationName;
        newOperation.namespace = record.NamespacePrefix;
        newOperation.createdDate = Datetime.valueOf(this.getDate(record.CreatedDate));
        newOperation.lastModifiedDate = Datetime.valueOf(this.getDate(record.lastModifiedDate));
        newOperation.developerName = String.isNotBlank(newOperation.namespace)? newOperation.namespace + '__' + objectName + '.' + newOperation.label : objectName + '.' + newOperation.label;
        return newOperation;
    }
    
    private String getDate(string dateString){
        return dateString.replace('T', ' ').left(dateString.indexOf('.'));
    }
    public class ToolingApiException extends Exception {
        
    }
}