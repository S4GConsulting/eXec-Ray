/**
 * @description       : Extracts and parses the information from MetadataService.
**/

public with sharing class MetadataServiceFetcher extends MetadataFetcher {

    //final private List<String> METADATA_TYPES = new List<String>{'SharingRules'};
    private static final string SHARINGRULES ='SharingRules';
    private static final string ESCALATIONRULES = 'EscalationRules';
    private static final string FLOWS = 'Flow';
    private static final string WORKFLOWS = 'WorkflowRules'; 
    private static final string BEFORETRIGGERFLOW ='RecordBeforeSave';
    private static final string AFTERTRIGGERFLOW ='RecordAfterSave';
    private static final string ACTIVE ='Active';

    private Map<String,List<MetadataService.Metadata>> retrievedResponse = new Map<String,List<MetadataService.Metadata>>();
    
    private Map<String,MetadataService.FileProperties> flowByFullName = new Map<String,MetadataService.FileProperties>();
    private List<MetadataService.SharingRules> retrievedSharingRules = new List<MetadataService.SharingRules>();

    /**
    * @description Executes all metadata request logic
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String,List<CategoryOperation>> requestMetadata(List<String> sobjectNames, List<String> categories) {
        init(sobjectNames, categories);
        CategorySettingHelper.fillCategory();
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = Session__c.getInstance().SessionId__c;// UserInfo.getSessionId();
        //List<MetadataService.SharingRules> sharingRules  = new List<MetadataService.SharingRules>();
        for(Category_Setting__mdt category :CategorySettingHelper.getAllCategorySettingsMetadata()){
            if(!FLOWS.equalsIgnoreCase(category.ApiName__c)){
                this.retrievedResponse.put(category.DeveloperName , service.readMetadata(category.ApiName__c, new List<String>(this.sobjectNames)).getRecords());
            }else if(!category.RepeatApi__c) {
                MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
                query.type_x= category.ApiName__c;
	            double asOfVersion = 50.0;
                MetadataService.FileProperties[] propeties = service.listMetadata(new List<MetadataService.ListMetadataQuery>{query}, asOfVersion);
                for(MetadataService.FileProperties fileProperty : propeties){
                    flowByFullName.put(fileProperty.fullName, fileProperty);
                }
                this.retrievedResponse.put(category.ApiName__c , service.readMetadata(category.ApiName__c, new List<String>(flowByFullName.keySet())).getRecords());
            }
        }

        this.parseMetadata();
        return this.operationsByObject;
    }

    /**
    * @description Transforms metadata into a readable structure.
    **/
    protected override void parseMetadata() {
        //this.parseSharingRules(this.retrievedSharingRules);
        this.parseSharingRules((List<MetadataService.SharingRules>) this.retrievedResponse.get(SHARINGRULES));
        this.parseEscalationRules((List<MetadataService.EscalationRules>)this.retrievedResponse.get(ESCALATIONRULES));
        this.parseWorkflowRules((List<MetadataService.Workflow>)this.retrievedResponse.get(WORKFLOWS));
        this.parseFlows((List<MetadataService.Flow>) this.retrievedResponse.get(FLOWS));
    }


    /**
    * @description Transforms SharingRules metadata into a readable structure (operationsByObject).
    * @param unparsedSharingRules 
    **/
    private void parseSharingRules(List<MetadataService.SharingRules> unparsedSharingRules) {
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingMetadata(SHARINGRULES).label);
        for(MetadataService.SharingRules rule : unparsedSharingRules) {
            if(rule.sharingCriteriaRules != null) {
                // Updates operationsByObject map, this map is returned by requestMetadata, class public method 
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(this.parseBaseSharingRule(rule.sharingCriteriaRules));
            }
            if(rule.sharingOwnerRules != null) {
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(this.parseBaseSharingRule(rule.sharingOwnerRules));
            }
            if(rule.sharingTerritoryRules != null) {
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(this.parseBaseSharingRule(rule.sharingTerritoryRules));
            }
            if(rule.sharingGuestRules != null) {
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(this.parseBaseSharingRule(rule.sharingGuestRules));
            }       
        }
    }

    /**
    * @description Parses each different type of MetadataService.SharingRules class into the proper data structure of Operation.
    * @param rules SharingBaseRule list. Virtual class behind the differente types of sharing rules from MetadataService class.
    * @return List<CategoryOperation.Operation> 
    **/
    private List<CategoryOperation.Operation> parseBaseSharingRule(List<MetadataService.SharingBaseRule> rules) {
        List<CategoryOperation.Operation> ruleList = new List<CategoryOperation.Operation>();
        for(MetadataService.SharingBaseRule rule : rules) {
            CategoryOperation.Operation tempSharingRule= new CategoryOperation.Operation();
            if(rule instanceof MetadataService.SharingCriteriaRule){
                MetadataService.SharingCriteriaRule ruleCriteria = (MetadataService.SharingCriteriaRule) rule;
                tempSharingRule.label = ruleCriteria.label;
                tempSharingRule.developerName = ruleCriteria.fullName;   
            } else if(rule instanceof MetadataService.SharingTerritoryRule){
                MetadataService.SharingTerritoryRule ruleTerritory = (MetadataService.SharingTerritoryRule) rule;
                tempSharingRule.label = ruleTerritory.label;
                tempSharingRule.developerName = ruleTerritory.fullName;   
            }else if(rule instanceof MetadataService.SharingGuestRule){
                MetadataService.SharingGuestRule ruleGuest = (MetadataService.SharingGuestRule) rule;
                tempSharingRule.label = ruleGuest.label;
                tempSharingRule.developerName = ruleGuest.fullName;   
            }else if(rule instanceof MetadataService.SharingOwnerRule){
                MetadataService.SharingOwnerRule ruleOwner = (MetadataService.SharingOwnerRule) rule;
                tempSharingRule.label = ruleOwner.label;
                tempSharingRule.developerName = ruleOwner.fullName;   
            }
           
            ruleList.add(tempSharingRule);
        }
        return ruleList;
    }

    private void parseEscalationRules(List<MetadataService.EscalationRules> unparsedEscalationRules){
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingMetadata(ESCALATIONRULES).label);
        for(MetadataService.EscalationRules rule : unparsedEscalationRules) {
            List<CategoryOperation.Operation> operations = this.parseBaseEscalationRule(rule.escalationRule);
            if(!operations.isEmpty()){
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(operations);
            }
        }
    }

    private List<CategoryOperation.Operation> parseBaseEscalationRule(List<MetadataService.EscalationRule> rules) {
        List<CategoryOperation.Operation> ruleList = new List<CategoryOperation.Operation>();
        if(rules != null){
            for(MetadataService.EscalationRule rule : rules) {
                if(rule.active){
                    CategoryOperation.Operation operation = new CategoryOperation.Operation();
                    operation.label = rule.fullName;
                    operation.developerName = rule.fullName;
                    ruleList.add(operation);
                }
            }
        }
        return ruleList;
    }

    private void parseWorkflowRules(List<MetadataService.Workflow> unparsedWorkflowRules){
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingMetadata(WORKFLOWS).label);
        for(MetadataService.Workflow rule : unparsedWorkflowRules) {
            List<CategoryOperation.Operation> operations = this.parseBaseWorkflowRule(rule.rules);
            if(!operations.isEmpty()){
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(operations);
            }
        }
    }

    private List<CategoryOperation.Operation> parseBaseWorkflowRule(List<MetadataService.WorkflowRule> rules) {
        List<CategoryOperation.Operation> ruleList = new List<CategoryOperation.Operation>();
        if(rules != null){
            for(MetadataService.WorkflowRule rule : rules) {
                if(rule.active){
                    CategoryOperation.Operation operation = new CategoryOperation.Operation();
                    operation.label = rule.fullName;
                    operation.developerName = rule.fullName;
                    ruleList.add(operation);
                }
            }
        }
        return ruleList;
    }

    private void parseFlows(List<MetadataService.Flow> unparsedFlows){
        Integer categoryIndexBefore = this.getCategoryIndex(CategorySettingHelper.getCategorySettingMetadata(BEFORETRIGGERFLOW).Label);
        Integer categoryIndexAfter = this.getCategoryIndex(CategorySettingHelper.getCategorySettingMetadata(AFTERTRIGGERFLOW).Label);
        for(MetadataService.Flow rule : unparsedFlows) {
            if(ACTIVE.equalsIgnoreCase(rule.status) && this.operationsByObject.containsKey(rule.start.object_x)){
                if(BEFORETRIGGERFLOW.equalsIgnoreCase(rule.start.triggerType)){
                    this.operationsByObject.get(rule.start.object_x)[categoryIndexBefore].operations.add(this.parseBaseFlow(rule));
                }else if(AFTERTRIGGERFLOW.equalsIgnoreCase(rule.start.triggerType)) {
                    this.operationsByObject.get(rule.start.object_x)[categoryIndexAfter].operations.add(this.parseBaseFlow(rule));
                }
            }
        }
    }

    private CategoryOperation.Operation parseBaseFlow(MetadataService.Flow flow) {
        CategoryOperation.Operation operation = new CategoryOperation.Operation();
        MetadataService.FileProperties fileProperty = flowByFullName.get(flow.fullName);
        operation.label = flow.label;
        operation.developerName = flow.fullName;
        operation.createdDate = fileProperty.lastModifiedDate;
        operation.lastModifiedDate = fileProperty.createdDate;
        operation.namespace = fileProperty.namespacePrefix;
        return operation;

    }    
}