/**
 * @description       : Handler for ExecutionTree to get List of SFObjects and manage to which API should each category goes and sort it.
**/
public without sharing class ExecutionTreeHandler {

    @TestVisible private MetadataFetcher testStubFetcher;

    private final Map<String, String> CATEGORY_FETCHER = new Map<String,String> {
        'SOQLFetcher' => 'SOQL',
        'ToolingApiFetcher' => 'Tooling',
        'MetadataServiceFetcher' => 'Metadata'
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
            if(!entity.QualifiedApiName.contains('__mdt')) {
                sfObjects.add(getObjectWrapper(entity));
            }
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
            for(String fetcherName : CATEGORY_FETCHER.keySet()) {
                MetadataFetcher fetcher;
                Map<String, List<CategoryOperation>> fetchedOperationsByObject = new Map<String, List<CategoryOperation>>();
                Type t = Type.forName(fetcherName);
                // We need to set stub data in test or add the correct fetcher.
                fetcher = this.testStubFetcher == null ? (MetadataFetcher)t.newInstance() : this.testStubFetcher;
                
                fetchedOperationsByObject = fetcher.requestMetadata(new List<String>{objectName}, CategorySettingHelper.getCategoryNamesByOperation(CATEGORY_FETCHER.get(fetcherName)));
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