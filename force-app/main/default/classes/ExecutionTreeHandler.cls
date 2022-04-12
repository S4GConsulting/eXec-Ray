/**
 * @description       : Handler for ExecutionTree to get List of SFObjects and manage to which API should each category goes and sort it.
**/
public without sharing class ExecutionTreeHandler {

    private final Map<String, List<String>> CATEGORY_FETCHER = new Map<String, List<String>> {
        'SOQLFetcher' => new List<String> {'Duplicate Rules','Assignment Rules','Entitlement Rules'},
        'ToolingApiFetcher' => new List<String>{'After Triggers', 'Autoresponse Rules', 'Before Triggers', 'Validation Rules'},
        'MetadataServiceFetcher' => new List<String> {'Sharing Rules', 'Escalation Rules', 'Workflow Rules','Record Before Trigger Flows','Record After Tirgger Flows'}
    };
    /**
    * @description Obtain the list of SObject relevant in the org
    * @return List<SFObject> 
    **/
    public List<SFObject> getObjectList() {
        List<SFObject> sfObjects = new List<SFObject>();
        //We only need those SObjects that are customizable
        List<EntityDefinition> entities = [SELECT QualifiedApiName, MasterLabel FROM EntityDefinition WHERE IsCustomizable = true AND IsCustomSetting = false ORDER BY MasterLabel];
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

    /**
    * @description Obtain the category operations sorted by order of a given SObject
    * @param objectName 
    * @return List<CategoryOperation> 
    **/
    public List<CategoryOperation> getCategoryOperations(String objectName) {
        Map<String, List<CategoryOperation>> operationsByObject = new Map<String, List<CategoryOperation>>();
        
        if(ExecRaySettings__c.getInstance().UsePlatformCache__c) {
            operationsByObject = getCachedOperations();
        }

        if(!operationsByObject?.containsKey(objectName)) {
            MetadataFetcher fetcher;
            for(String fetcherName : CATEGORY_FETCHER.keySet()) {
                
                Map<String, List<CategoryOperation>> fetchedOperationsByObject = new Map<String, List<CategoryOperation>>();
                Type t = Type.forName(fetcherName);
                fetcher = (MetadataFetcher)t.newInstance();
                
                fetchedOperationsByObject = fetcher.requestMetadata(new List<String>{objectName}, new List<String>(CATEGORY_FETCHER.get(fetcherName)));
                //We need to be checking if the SObject already has some categories in it in order to add the new categories instead of replacing them
                if(operationsByObject.containsKey(objectName)) {
                    operationsByObject.get(objectName).addAll(fetchedOperationsByObject.get(objectName));
                } else {
                    operationsByObject.put(objectName, fetchedOperationsByObject.get(objectName));
                }
            }
            PlatformCacheHelper.putCacheData(PlatformCacheHelper.cacheType.categories, JSON.serialize(operationsByObject));
        }

        List<CategoryOperation> sortedCategoryOperations = operationsByObject.get(objectName);
        sortedCategoryOperations.sort();
        return sortedCategoryOperations;
    }

    public Map<String, List<CategoryOperation>> getCachedOperations() {
        String jsonData = PlatformCacheHelper.getCacheData(PlatformCacheHelper.cacheType.categories);
        Map<String, List<CategoryOperation>> operationsByObject = new Map<String, List<CategoryOperation>>();
        if(jsonData != null) {
            operationsByObject = PlatformCacheHelper.parseCachedData(jsonData);
        }
        return operationsByObject;
    }
}