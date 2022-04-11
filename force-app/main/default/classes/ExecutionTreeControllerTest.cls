@IsTest
public with sharing class ExecutionTreeControllerTest {
    
    @IsTest
    private static void test_init(){
        Test.startTest();
            List<SFObject> sfobjects = ExecutionTreeController.init();
        Test.stopTest();

        Map<String, SFObject> sfobjectsByLabel = new Map<String, SFObject>();
        for(SFObject sfobject : sfobjects){
            sfobjectsByLabel.put(sfobject.label, sfobject);
        }

        SFObject account = sfobjectsByLabel.get('Account');
        SFObject caseDefinition = sfobjectsByLabel.get('Case');
        System.assertEquals('Account', account.apiName, 'Account not retrieved.');
        System.assertEquals('Standard', account.type, 'Incorrect account type defined.');
        System.assertEquals('Case', caseDefinition.apiName, 'Case not retrieved.');
        System.assertEquals('Standard', caseDefinition.type, 'Incorrect case type defined.');
    }

    @IsTest
    private static void test_initError(){
        Boolean exceptionThrown = false;

        Test.startTest();
            MockUtil mock = new MockUtil(ExecutionTreeHandler.class);
            ExecutionTreeController.handler = (ExecutionTreeHandler) mock.instance;
            mock.setException('getObjectList');
            try{
                ExecutionTreeController.init();
            } catch(Exception e){
                exceptionThrown = true;
            }
        Test.stopTest();
        
        mock.assertInvoked('getObjectList');
        System.assert(exceptionThrown, 'Exception not throw.');   
    }

    @IsTest
    private static void test_getObjectMetadata(){
        CategoryOperation categoryOperation = new CategoryOperation();
        categoryOperation.category = 'Validation Rule';

        Test.setMock(HttpCalloutMock.class, new ToolingApiMock('OK'));
        Test.startTest();
            MockUtil mock = new MockUtil(ExecutionTreeHandler.class);
            ExecutionTreeController.handler = (ExecutionTreeHandler) mock.instance;
            mock.setReturnValue('getCategoryOperations', new CategoryOperation[]{categoryOperation});
            List<CategoryOperation> returnedCategories = ExecutionTreeController.getObjectMetadata('Account');
        Test.stopTest();

        mock.assertInvoked('getCategoryOperations');
        System.assertEquals(1, returnedCategories.size(), 'Incorrect number of categories returned.');        
    }

    @IsTest
    private static void test_getEmptyObjectMetadata(){
        Test.startTest();
            List<CategoryOperation> returnedCategories = ExecutionTreeController.getObjectMetadata('');
        Test.stopTest();

        System.assertEquals(null, returnedCategories, 'Unexpected response.');        
    }

    @IsTest
    private static void test_getObjectMetadataError(){
        Boolean exceptionThrown = false;

        Test.setMock(HttpCalloutMock.class, new ToolingApiMock('ERROR'));
        Test.startTest();
            MockUtil mock = new MockUtil(ExecutionTreeHandler.class);
            ExecutionTreeController.handler = (ExecutionTreeHandler) mock.instance;
            mock.setException('getCategoryOperations');
            try{
                ExecutionTreeController.getObjectMetadata('ExecRayIncorrectObject');
            } catch(Exception e){
                exceptionThrown = true;
            }
        Test.stopTest();
        
        mock.assertInvoked('getCategoryOperations');
        System.assert(exceptionThrown, 'Exception not throw.');   
    }

    @IsTest
    private static void test_refresh(){
        Cache.OrgPartition orgPartition = Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL);
        orgPartition.put(PlatformCacheHelper.cacheType.categories, 'data', 1800);        
        orgPartition.put(PlatformCacheHelper.cacheType.flows, 'data', 1800);
        System.assertEquals('data', orgPartition.get(PlatformCacheHelper.cacheType.categories), 'Cache is empty');
        System.assertEquals('data', orgPartition.get(PlatformCacheHelper.cacheType.flows), 'Cache is empty');

        Test.startTest();
            ExecutionTreeController.refresh();
        Test.stopTest();

        System.assertEquals(null, orgPartition.get(PlatformCacheHelper.cacheType.categories), 'Cache is not empty');
        System.assertEquals(null, orgPartition.get(PlatformCacheHelper.cacheType.flows), 'Cache is not empty');     
    }
}