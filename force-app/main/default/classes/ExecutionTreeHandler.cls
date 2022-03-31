/**
 * @description       : Handler for ExecutionTree to get List of SFObjects and manage to which API should each category goes and sort it.
**/
public with sharing class ExecutionTreeHandler {

    /**
    * @description Obtain the list of SObject relevant in the org
    * @return List<SFObject> 
    **/
    public List<SFObject> getObjectList() {
        List<SFObject> sfObjects = new List<SFObject>();
        List<EntityDefinition> entities = [SELECT QualifiedApiName, MasterLabel FROM EntityDefinition WHERE IsCustomizable = true];
        for(EntityDefinition entity : entities) {
            sfObjects.add(getObjectWrapper(entity));
        }
        return sfObjects;
    }

    /**
    * @description Categorize a given SObject in Standard or Custom
    * @param objectDescribe 
    * @return SFObject 
    **/
    private SFObject getObjectWrapper(EntityDefinition objectDescribe) {
        SFObject sfObjectWrapper = new SFObject();
        sfObjectWrapper.label = objectDescribe.MasterLabel;
        sfObjectWrapper.apiName = objectDescribe.QualifiedApiName;
        sfObjectWrapper.type = objectDescribe.QualifiedApiName.contains('__c') ? 'Custom' : 'Standard';
        return sfObjectWrapper;
    }
}
