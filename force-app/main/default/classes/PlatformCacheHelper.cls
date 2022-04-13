/**
 * @description       : Get, put and parse data from Platform Cache
**/
public with sharing class PlatformCacheHelper {

    private static final String PARTITION_LABEL = 'local.CategoryOperations';
    private static final Cache.OrgPartition ORG_PARTITION = Cache.Org.getPartition(PARTITION_LABEL);
    public static CacheTypeEnum cacheType = new CacheTypeEnum();
    
    public class CacheTypeEnum {
        public String flows = 'Flows';
        public String categories = 'Categories';
    }

    /**
    * @description Store data in Platform Cache
    * @param type 
    * @param data 
    **/
    public static void putCacheData(String type, String data) {
        ORG_PARTITION.put(type, data, 1800);
    }

    /**
    * @description Get data from Platform Cache
    * @param type 
    * @return String 
    **/
    public static String getCacheData(String type) {
        String jsonData = (String)ORG_PARTITION.get(type);
        return jsonData;
    }

    /**
    * @description Parse data from Platform Cache into List<CategoryOperation> for a given SObject
    * @param data 
    * @return Map<String, List<CategoryOperation>> 
    **/
    public static Map<String, List<CategoryOperation>> parseCachedData(String data) {
        Map<String, List<CategoryOperation>> parsedData = (Map<String,List<CategoryOperation>>)JSON.deserialize(data, Map<String,List<CategoryOperation>>.class);
        return parsedData;
    }

    public static void clearCache() {
        ORG_PARTITION.remove(cacheType.categories);
        ORG_PARTITION.remove(cacheType.flows);
    }
}
