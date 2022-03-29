/**
 * @description       : Extracts and parses the information from MetadataService.
**/

public with sharing class MetadataServiceFetcher extends MetadataFetcher {

    final private List<String> METADATA_TYPES = new List<String>{'SharingRules'};
    
    private List<MetadataService.SharingRules> retrievedSharingRules = new List<MetadataService.SharingRules>();

    /**
    * @description Class constructor
    * @param sobjectNames 
    * @param categories 
    **/
    public MetadataServiceFetcher(List<String> sobjectNames, List<String> categories) {
        super(sobjectNames,categories);
    }

    /**
    * @description Executes all metadata request logic
    * @return Map<String, List<CategoryOperation>> 
    **/
    public override Map<String,List<CategoryOperation>> requestMetadata() {
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        List<MetadataService.SharingRules> sharingRules  = new List<MetadataService.SharingRules>();
        
        this.retrievedSharingRules.addAll((List<MetadataService.SharingRules>) service.readMetadata(METADATA_TYPES[0], new List<String>(this.sobjectNames)).getRecords());
 
        this.parseMetadata();

        return this.operationsByObject;
    }

    /**
    * @description Transforms metadata into a readable structure.
    **/
    private void parseMetadata() {
        this.parseSharingRules(this.retrievedSharingRules);
    }


    /**
    * @description Transforms SharingRules metadata into a readable structure (operationsByObject).
    * @param unparsedSharingRules 
    **/
    private void parseSharingRules(List<MetadataService.SharingRules> unparsedSharingRules) {
        Integer categoryIndex = this.getCategoryIndex(METADATA_TYPES[0]);
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
            tempSharingRule.label = rule.label;
            tempSharingRule.developerName = rule.fullName;
            ruleList.add(tempSharingRule);
        }
        return ruleList;
    }
}
