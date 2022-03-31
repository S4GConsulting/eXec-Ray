/**
 * @description       : Handler for ExecutionTree to get List of SFObjects and manage to which API should each category goes and sort it.
**/
public with sharing class ExecutionTreeHandler {

    //Remove these types from the list
    private final List<String> IGNORED_TYPES = new List<String> {'Share', 'History','ChangeEvent'};

    /**
    * @description Obtain the list of SObject relevant in the org
    * @return List<SFObject> 
    **/
    public List<SFObject> getObjectList() {
        List<SFObject> sfObjects = new List<SFObject>();
        List<Schema.SObjectType> sObjectTypes = Schema.getGlobalDescribe().values();
        for(Schema.SObjectType sObjectType : sObjectTypes) {
            Schema.DescribeSObjectResult objectDescribe = sObjectType.getDescribe();
            if(!IGNORED_TYPES.contains(objectDescribe.getAssociateEntityType())) {
                sfObjects.add(getObjectWrapper(objectDescribe));
            }
        }
        return sfObjects;
    }

    /**
    * @description Categorize a given SObject in Standard or Custom
    * @param objectDescribe 
    * @return SFObject 
    **/
    private SFObject getObjectWrapper(Schema.DescribeSObjectResult objectDescribe) {
        SFObject sfObjectWrapper = new SFObject();
        sfObjectWrapper.label = objectDescribe.getLabel();
        sfObjectWrapper.apiName = objectDescribe.getName();
        sfObjectWrapper.type = objectDescribe.isCustom() ? 'Custom' : 'Standard';
        return sfObjectWrapper;
    }
}
