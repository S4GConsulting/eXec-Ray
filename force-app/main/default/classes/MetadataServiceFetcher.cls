/**
 * @description       : Extracts and parses the information from MetadataService.
**/

public with sharing class MetadataServiceFetcher extends MetadataFetcher {

    private static final string METADATA ='Metadata';
    private static final string SHARINGRULES ='SharingRules';
    private static final string ESCALATIONRULES = 'EscalationRules';
    private static final string FLOWS = 'Flow';
    private static final string WORKFLOWS = 'WorkflowRules'; 
    private static final string BEFORETRIGGERFLOW ='RecordBeforeSave';
    private static final string AFTERTRIGGERFLOW ='RecordAfterSave';
    private static final string PROCESSTYPE_WORKFLOW ='Workflow';
    private static final string PROCESSTYPE_AUTOLAUNCHEDFLOW='AutoLaunchedFlow';
    private static final string PROCESSBUILDER ='ProcessBuilder';
    private static final string ACTIVE ='Active';

    private Map<String,List<MetadataService.Metadata>> retrievedResponse = new Map<String,List<MetadataService.Metadata>>();
    private Map<String,MetadataService.FileProperties> flowByFullName = new Map<String,MetadataService.FileProperties>();

       
    @TestVisible
    private MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    /**
    * @description Executes all metadata request logic
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String,List<CategoryOperation>> requestMetadata(List<String> sobjectNames, Set<String> categories) {
        init(sobjectNames, categories);
        this.service.SessionHeader = new MetadataService.SessionHeader_element();
        this.service.SessionHeader.sessionId ='{!$Credential.OAuthToken}';
        this.service.timeout_x = 120000;
        try{
            for(CategorySetting__mdt category :CategorySettingHelper.getCategorySettingsByOperation(METADATA)){
                if(!FLOWS.equalsIgnoreCase(category.ApiName__c)){
                    this.retrievedResponse.put(category.DeveloperName , this.service.readMetadata(category.ApiName__c, new List<String>(this.sobjectNames)).getRecords());
                }else if(!category.RepeatApi__c) {
                    MetadataService.ListMetadataQuery query = new MetadataService.ListMetadataQuery();
                    query.type_x= category.ApiName__c;
                    double asOfVersion = 54.0;
                    MetadataService.FileProperties[] properties = this.service.listMetadata(new List<MetadataService.ListMetadataQuery>{query}, asOfVersion);
                    List<MetadataService.Metadata> responsesMetadata = new List<MetadataService.Metadata>();
                    Integer count = 1;
                    List<String> fullNames = new List<String>();
                    for(MetadataService.FileProperties fileProperty : properties){
                        flowByFullName.put(fileProperty.fullName, fileProperty);
                        fullNames.add(fileProperty.fullName);
                        if(count == 10){
                            responsesMetadata.addAll(this.service.readMetadata(category.ApiName__c, fullNames).getRecords());
                            count=1;
                            fullNames.clear();
                        }else {
                            count ++;
                        }
                    }
                    if(count>1){
                        responsesMetadata.addAll(this.service.readMetadata(category.ApiName__c, fullNames).getRecords());
                    }
                    this.retrievedResponse.put(category.ApiName__c ,responsesMetadata);
                    
                }
            }
            this.parseMetadata();
        }catch(Exception e){
           throw new MetadataServiceException('Exception'+ e.getMessage() + ' ' + e.getLineNumber());
        }
        
        return this.operationsByObject;
    }

    /**
    * @description Transforms metadata into a readable structure.
    **/
    protected override void parseMetadata() {
        if(this.retrievedResponse.containsKey(SHARINGRULES)){
            this.parseSharingRules((List<MetadataService.SharingRules>) this.retrievedResponse.get(SHARINGRULES));
        }
        if(this.retrievedResponse.containsKey(ESCALATIONRULES)){
            this.parseEscalationRules((List<MetadataService.EscalationRules>)this.retrievedResponse.get(ESCALATIONRULES));
        }
        if(this.retrievedResponse.containsKey(WORKFLOWS)){
            this.parseWorkflowRules((List<MetadataService.Workflow>)this.retrievedResponse.get(WORKFLOWS));
        }
        if(this.retrievedResponse.containsKey(FLOWS)){
            this.parseFlows(this.retrievedResponse.get(FLOWS));
        }
    }


    /**
    * @description Transforms SharingRules metadata into a readable structure (operationsByObject).
    * @param unparsedSharingRules 
    **/
    private void parseSharingRules(List<MetadataService.SharingRules> unparsedSharingRules) {
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(SHARINGRULES).label);
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

    /**
    * @description Transforms EscalationRules metadata into a readable structure (operationsByObject).
    * @param unparsedEscalationRules 
    **/
    private void parseEscalationRules(List<MetadataService.EscalationRules> unparsedEscalationRules){
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(ESCALATIONRULES).label);
        for(MetadataService.EscalationRules rule : unparsedEscalationRules) {
            List<CategoryOperation.Operation> operations = this.parseBaseEscalationRule(rule.escalationRule);
            if(!operations.isEmpty()){
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(operations);
            }
        }
    }

    /**
    * @description Parser MetadataService.EscalationRule class into the proper data structure of Operation.
    * @param rules EscalationRule list
    * @return List<CategoryOperation.Operation> 
    **/
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

    /**
    * @description Transforms Workflow metadata into a readable structure (operationsByObject).
    * @param unparsedWorkflowRules 
    **/
    private void parseWorkflowRules(List<MetadataService.Workflow> unparsedWorkflowRules){
        Integer categoryIndex = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(WORKFLOWS).label);
        for(MetadataService.Workflow rule : unparsedWorkflowRules) {
            List<CategoryOperation.Operation> operations = this.parseBaseWorkflowRule(rule.rules);
            if(!operations.isEmpty()){
                this.operationsByObject.get(rule.fullName)[categoryIndex].operations.addAll(operations);
            }
        }
    }

    /**
    * @description Parser MetadataService.WorkflowRule class into the proper data structure of Operation.
    * @param rules WorkflowRule list
    * @return List<CategoryOperation.Operation> 
    **/
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

    /**
    * @description Transforms Flow metadata into a readable structure (operationsByObject).
    * @param unparsedFlows 
    **/
    private void parseFlows(List<MetadataService.Metadata> unparsedFlows){
        Integer categoryIndexBefore = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(BEFORETRIGGERFLOW)?.Label);
        Integer categoryIndexAfter = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(AFTERTRIGGERFLOW)?.Label);
        Integer categoryIndexProcess = this.getCategoryIndex(CategorySettingHelper.getCategorySettingByName(PROCESSBUILDER)?.Label);
        for(MetadataService.Metadata metadata : unparsedFlows) {
            MetadataService.Flow rule = (MetadataService.Flow) metadata;
            String objectX = rule.processMetadataValues != null ? this.getObjectByProcessBuilder(rule): null;
            if(ACTIVE.equalsIgnoreCase(rule.status) && PROCESSTYPE_AUTOLAUNCHEDFLOW.equalsIgnoreCase(rule.processType) && rule.start != null && this.operationsByObject.containsKey(rule.start.object_x)){
                if(BEFORETRIGGERFLOW.equalsIgnoreCase(rule.start.triggerType)){
                    this.operationsByObject.get(rule.start.object_x)[categoryIndexBefore].operations.add(this.parseBaseFlow(rule));
                }else if(AFTERTRIGGERFLOW.equalsIgnoreCase(rule.start.triggerType)) {
                    this.operationsByObject.get(rule.start.object_x)[categoryIndexAfter].operations.add(this.parseBaseFlow(rule));
                }
            } else if(ACTIVE.equalsIgnoreCase(rule.status) && PROCESSTYPE_WORKFLOW.equalsIgnoreCase(rule.processType) && String.isNotBlank(objectX) && this.operationsByObject.containsKey(objectX)){
                this.operationsByObject.get(objectX)[categoryIndexProcess].operations.add(this.parseBaseFlow(rule));
            }
            
        }
    }

    /**
    * @description return object name from Flow of process builder.
    * @param rule
    * @return string 
    **/
    private string getObjectByProcessBuilder(MetadataService.Flow rule){
        String objectX;
        for(MetadataService.FlowMetadataValue flowValue :rule.processMetadataValues){
            if('ObjectType'.equalsIgnoreCase(flowValue?.name)){
                objectX = flowValue.value.stringValue;
                break;
            }
        }
        return objectX;
    }
    /**
    * @description Parser MetadataService.Flow class into the proper data structure of Operation.
    * @param flow Flow class
    * @return List<CategoryOperation.Operation> 
    **/
    private CategoryOperation.Operation parseBaseFlow(MetadataService.Flow flow) {
        CategoryOperation.Operation operation = new CategoryOperation.Operation();
        MetadataService.FileProperties fileProperty = flowByFullName.get(flow.fullName);
        operation.label = flow.label;
        operation.developerName = flow.fullName;
        operation.createdDate = fileProperty.createdDate;
        operation.lastModifiedDate = fileProperty.lastModifiedDate;
        operation.namespace = fileProperty.namespacePrefix;
        return operation;
    }    

    public class MetadataServiceException extends Exception {
        
    }
}