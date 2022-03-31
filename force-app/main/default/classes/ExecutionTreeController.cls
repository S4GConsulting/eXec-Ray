/**
 * @description       : Controller for ExecutionTree to get list of SFObjects and CategoryOperations
**/
public with sharing class ExecutionTreeController {
    
    /**
    * @description Return all the objects from org alredy categorized in Standard or Custom 
    * @return List<SFObject> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<SFObject> init(){
        try {
            ExecutionTreeHandler handler = new ExecutionTreeHandler();
            List<SFObject> sfObjects = new List<SFObject>();
            sfObjects = handler.getObjectList();
            return sfObjects;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
