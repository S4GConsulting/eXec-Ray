/**
 * @description       : Controller for ExecutionTree to get list of SFObjects and CategoryOperations
**/
public without sharing class ExecutionTreeController {

    @TestVisible private static ExecutionTreeHandler handler = new ExecutionTreeHandler();
    
    /**
    * @description Return all the objects from org alredy categorized in Standard or Custom 
    * @return List<SFObject> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<SFObject> init(){
        try {
            List<SFObject> sfObjects = new List<SFObject>();
            sfObjects = ExecutionTreeController.handler.getObjectList();
            return sfObjects;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Get a List with all the Operations for each Category in a given SObject
    * @param objectName 
    * @return List<CategoryOperation> 
    **/
    @AuraEnabled
    public static List<CategoryOperation> getObjectMetadata(String objectName){
        if(String.isBlank(objectName)){
            return null;
        }

        try {            
            List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
            categoryOperations = ExecutionTreeController.handler.getCategoryOperations(objectName);
            return categoryOperations;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Clears Platform Cache for Flows and Object Metadata
    **/
    @AuraEnabled
    public static void refresh(){
        try {
            PlatformCacheHelper.clearCache();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}