@IsTest
public with sharing class ExecutionTreeHandlerTest {
    @IsTest
    private static void test_getObjectList(){
        Test.startTest();
            ExecutionTreeHandler handler = new ExecutionTreeHandler();
            List<SFObject> sfObjects = handler.getObjectList();
        Test.stopTest();

        Map<String, SFObject> sfobjectsByLabel = new Map<String, SFObject>();
        for(SFObject sfobject : sfobjects){
            sfobjectsByLabel.put(sfobject.label, sfobject);
        }

        SFObject account = sfobjectsByLabel.get('Account');
        
        System.assertEquals('Account', account.apiName, 'Account not retrieved.');
        System.assertEquals('Standard', account.type, 'Incorrect account type defined.');        
        System.assertEquals('Account', account.apiName, 'Incorrect account type defined.');
    }

    @IsTest
    private static void test_getCategoryOperations(){
        CategoryOperation categoryOperation = new CategoryOperation();
        categoryOperation.category = 'Validation Rule';
        CategoryOperation.order = 1;
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        categoryOperations.add(categoryOperation);
        Map<String, List<CategoryOperation>> categortiesByObject = new Map<String, List<CategoryOperation>>();
        categortiesByObject.put('Account', categoryOperations);

        Test.startTest();
            MockUtil mock = new MockUtil(MetadataFetcher.class);
            ExecutionTreeHandler handler = new ExecutionTreeHandler();
            handler.testStubFetcher = (MetadataFetcher) mock.instance;
            mock.setReturnValue('requestMetadata', categortiesByObject);
            List<CategoryOperation> sfObjects = handler.getCategoryOperations('Account');
        Test.stopTest();

        System.assertEquals(4, sfObjects.size(), 'Wrong number of operations returned.');
    }

    @IsTest
    private static void test_getCategoryOperationsWithCache(){
        CategoryOperation categoryOperation = new CategoryOperation();
        categoryOperation.category = 'Validation Rule';
        CategoryOperation.order = 1;
        List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
        categoryOperations.add(categoryOperation);
        Map<String, List<CategoryOperation>> categortiesByObject = new Map<String, List<CategoryOperation>>();
        categortiesByObject.put('Account', categoryOperations);

        Cache.OrgPartition orgPartition = Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL);
        orgPartition.put(PlatformCacheHelper.cacheType.categories, JSON.serialize(categortiesByObject), 1800); 

        ExecRaySettings__c execRaySettings = ExecRaySettings__c.getInstance();
        execRaySettings.UsePlatformCache__c = true;
        upsert execRaySettings;

        Test.startTest();
            MockUtil mock = new MockUtil(MetadataFetcher.class);
            ExecutionTreeHandler handler = new ExecutionTreeHandler();
            handler.testStubFetcher = (MetadataFetcher) mock.instance;
            mock.setReturnValue('requestMetadata', categortiesByObject);
            List<CategoryOperation> sfObjects = handler.getCategoryOperations('Account');
        Test.stopTest();

        System.assertEquals(1, sfObjects.size(), 'Wrong number of operations returned.');
    }

    @IsTest
    private static void test_getCachedOperations(){
        CategoryOperation categoryOperation = new CategoryOperation();
        categoryOperation.category = 'testOperation';
        categoryOperation.order = 1;

        Map<String, List<CategoryOperation>> operationsByObject = new Map<String, List<CategoryOperation>>(); 
        operationsByObject.put('Account0', new CategoryOperation[]{categoryOperation});

        Cache.OrgPartition orgPartition = Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL);
        orgPartition.put(PlatformCacheHelper.cacheType.categories, JSON.serialize(operationsByObject), 1800); 

        Test.startTest();
            ExecutionTreeHandler handler = new ExecutionTreeHandler();
            Map<String, List<CategoryOperation>> sfObjects = handler.getCachedOperations();
        Test.stopTest();

        System.assertNotEquals(null, orgPartition.get(PlatformCacheHelper.cacheType.categories), 'Cache is empty');
        System.assertEquals(JSON.serialize(operationsByObject), JSON.serialize(sfObjects), 'Wrong data returned by the cache.');
    }
}
