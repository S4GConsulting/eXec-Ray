/**
 * @description       : Extracts and parses the information from MetadataService.
**/

public with sharing class MetadataServiceFetcher extends MetadataFetcher {

    final List<String> METADATA_TYPES = new List<String>{'SharingRules'};
    static List<MetadataService.SharingRules> retrievedSharingRules = new List<MetadataService.SharingRules>();

    public override Map<String,List<CategoryOperation>> requestMetadata(List<String> sobjectNames) {
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        List<MetadataService.SharingRules> sharingRules  = new List<MetadataService.SharingRules>();
        
        
        retrievedSharingRules.addAll((List<MetadataService.SharingRules>) service.readMetadata(METADATA_TYPES, new String[] {sobjectNames}).getRecords());

        return parseMetadata();
    }

    public override Map<String,List<CategoryOperation>> parseMetadata() {

        parseSharingRules(MetadataServiceFetcher.retrievedSharingRules);

    }


    public List<String,List< parseSharingRules(List<MetadataService.SharingRules> unparsedSharingRules) {
        
        Map<String,List<CategoryOperation>> operationList = new Map<String,List<CategoryOperation>>();
        
        for(MetadataService.SharingRules sobjectSharingRule : unparsedSharingRules) {

            parseSObjectSharingRule(sobjectSharingRule);
        }  
    }

    parseSObjectSharingRule(MetadataService.SharingRules sRule) {
        List<CategoryOperation> operationList = new 
        if(sRule.sharingCriteriaRules != null) {
            for(MetadataService.SharingCriteriaRule rule : sRule.sharingCriteriaRules) {
                
            }
        }
        if(sRule.sharingOwnerRules != null) {
            for(MetadataService.SharingOwnerRule rule : sRule.sharingOwnerRules) {
                System.debug(rule.label);
                System.debug(rule.fullName);
            }
        }
        if(sRule.sharingTerritoryRules != null) {
            for(MetadataService.SharingTerritoryRule rule : sRule.sharingTerritoryRules) {
                System.debug(rule.label);
                System.debug(rule.fullName);
            }
        }
        if(sRule.sharingGuestRules != null) {
            for(MetadataService.SharingGuestRule rule : sRule.sharingGuestRules) {
                System.debug(rule.label);
                System.debug(rule.fullName);
            }
        }
    }
    return operationList;
    }
}
