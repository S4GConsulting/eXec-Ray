/**
 * @description       : 
 * @author            : andres.ortiz@s4g.es
 * @group             : 
 * @last modified on  : 04-04-2022
 * @last modified by  : andres.ortiz@s4g.es
**/
public with sharing class ToolingApiFetcher extends MetadataFetcher{

    private static final string APEXTRIGGERS = 'ApexTriggers';
    private static final string BEFORETRIGGER = 'BeforeTrigger' ;
    private static final string AFTERTRIGGER = 'AfterTrigger';
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
        CategorySettingHelper.fillCategoryTooling();
        String objects = '\''+ String.join(this.sobjectNames, '\',\'') + '\'';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://beehive-dev-dev-ed.my.salesforce.com/services/data/v53.0/tooling/composite');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + Session__c.getInstance().SessionId__c);//UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        CompositeWrapper composite = new CompositeWrapper();
        composite.allOrNone = 'true';
        composite.collateSubrequests = 'true';
        composite.compositeRequest = new List<CompositeWrapper.CompositeUnit>();
        
        for(Category_Setting__mdt category :CategorySettingHelper.getCategorySettingsTooling()){
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
        this.compositeResponseWrapper = (CompositeResponseWrapper) JSON.deserialize(res.getBody(),CompositeResponseWrapper.class);
        this.parseMetadata();
        return this.operationsByObject;
    }

    /**
    * @description Parse each of the entities into a CategoryOperation and stores to the corresponding object
    **/
    protected override void parseMetadata() {
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        for(CompositeResponseWrapper.Bodys bodys : this.compositeResponseWrapper.compositeResponse) {
            Category_Setting__mdt categorySetting;
            for(CompositeResponseWrapper.Records record : bodys.body.records){
                String objectName = String.isNotBlank(record.TableEnumOrId) ? record.TableEnumOrId : record.EntityDefinitionId;
                if(this.isActive(bodys.referenceId, record.status, record.active)){
                    CategoryOperation.Operation newOperation = new CategoryOperation.Operation();
                    newOperation.label =  String.isNotBlank(record.Name) ? record.Name : record.ValidationName;
                    string createDate = record.CreatedDate.replace('T', ' ').left(record.CreatedDate.indexOf('.'));
                    string lastModifiedDate = record.LastModifiedDate.replace('T',' ').left(record.LastModifiedDate.indexOf('.'));
                    newOperation.createdDate = Datetime.valueOf(createDate);
                    newOperation.lastModifiedDate = Datetime.valueOf(lastModifiedDate);
                    newOperation.namespace = record.NamespacePrefix;
                    Boolean isAfter = (APEXTRIGGERS.equalsIgnoreCase(bodys.referenceId) && (record.UsageAfterDelete || record.UsageAfterInsert || record.UsageAfterUndelete || record.UsageAfterUpdate));
                    categorySetting = this.getCategory(bodys.referenceId,isAfter );
                    Integer indexCategory = this.getCategoryIndex(categorySetting.label);
                    this.operationsByObject.get(objectName)[indexCategory].operations.add(newOperation);
                }    
            }
        }
        
    }
    private Category_Setting__mdt  getCategory(string referenceId, boolean isAfter){
        Category_Setting__mdt categorySetting;
        if(APEXTRIGGERS.equalsIgnoreCase(referenceId)){
            if(isAfter){
                categorySetting = CategorySettingHelper.getCategorySetting(AFTERTRIGGER);
            }
            else {
                categorySetting = CategorySettingHelper.getCategorySetting(BEFORETRIGGER);
            }
        }
        else {
            categorySetting = CategorySettingHelper.getCategorySetting(referenceId);
        }
        return  categorySetting;

    }

    private Boolean isActive(string referenceId, string status, boolean act){
        Boolean isActive = false;
        if(APEXTRIGGERS.equalsIgnoreCase(referenceId)) {
            isActive = ACTIVE.equalsIgnoreCase(status);
        } else if(WORKFLOWSRULES.equalsIgnoreCase(referenceId)){		
            isActive = true;
        } else {	
            isActive = act;
        }
        return isActive;
    }

}