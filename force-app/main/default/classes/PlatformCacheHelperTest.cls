/**
 * @description       : Test for PlatformCacheHelper
**/
@isTest
public with sharing class PlatformCacheHelperTest {

    @IsTest
    static void putPlatformCacheTest(){
        
        Test.startTest();
        String data = 'Test data';
        PlatformCacheHelper.putCacheData(PlatformCacheHelper.cacheType.flows, data);
        Test.stopTest();

       
        Cache.OrgPartition orgPartition = Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL);
        String cachedData = (String)orgPartition.get(PlatformCacheHelper.cacheType.flows);
        System.assertEquals(data, cachedData, 'Platform Cache is empty');
        
    }

    @IsTest
    static void getCacheDataTest(){
        String data = 'Test data';
        Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL).put(PlatformCacheHelper.cacheType.categories, data, 1800);

        Test.startTest();
        String dataCache = PlatformCacheHelper.getCacheData(PlatformCacheHelper.cacheType.categories);
        Test.stopTest();

        System.assertEquals(data, dataCache, 'Platform Cache is empty');
        
    }

    @IsTest
    static void parseCachedDataTest(){
        Map<String, List<CategoryOperation>> objectCategory = new Map<String, List<CategoryOperation>>();
        CategoryOperation categoryOp = new CategoryOperation();
        categoryOp.category = 'Test category';
        categoryOp.order = 0;
        categoryOp.operations = new List<CategoryOperation.Operation>();
        objectCategory.put('Account', new List<CategoryOperation>{categoryOp});
        String data = JSON.serialize(objectCategory);
        Cache.Org.getPartition(PlatformCacheHelper.PARTITION_LABEL).put(PlatformCacheHelper.cacheType.categories, data, 1800);

        
        Test.startTest();
        Map<String, List<CategoryOperation>> cachedJson = PlatformCacheHelper.parseCachedData(data);
        Test.stopTest();

        System.assert(cachedJson.get('Account') != null, 'Account is null');
        System.assertEquals('Test category', cachedJson.get('Account')[0].category, 'Category doesn\'t match');
        
    }

    @IsTest
    private static void clearCacheTest(){
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
