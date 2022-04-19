/**
 * @description: helper class to collect information from metadata categories
**/
public without sharing class CategorySettingHelper {
    private static final string TOOLING = 'Tooling';
    private static final string METADATA = 'Metadata';
    private static final string SOQL = 'SOQL';
    private static Map<String,CategorySetting__mdt> categoryTooling {
        get{
            if(categoryTooling == null){
                fillCategory();
            }
            return categoryTooling;
        }
        set;
    }
    
    private static Map<String,CategorySetting__mdt> categoryMetadata {
        get{
            if(categoryMetadata == null){
                fillCategory();
            }
            return categoryMetadata;
        }
        set;
    }
    private static Map<String,CategorySetting__mdt> categorySOQL {
        get{
            if(categorySOQL == null){
                fillCategory();
            }
            return categorySOQL;
        }
        set;
    }
    private static Map<String,CategorySetting__mdt> categorySettingByName {
        get{
            if(categorySettingByName == null){
                fillCategory();
            }
            return categorySettingByName;
        }
        set;
    }
    
    /**
    * @description filling of the attributes of the class corresponding to the category
    *  
    **/
    @SuppressWarnings('PMD.ApexCRUDViolation')
    private static void fillCategory() {
            categoryTooling = new Map<String,CategorySetting__mdt>();
            categoryMetadata = new Map<String,CategorySetting__mdt>();
            categorySOQL = new Map<String,CategorySetting__mdt>();
            categorySettingByName = new Map<String,CategorySetting__mdt>();
            List<CategorySetting__mdt> categories = [Select Id, DeveloperName, Label, ReferenceId__c, QualifiedApiName, Fields__c, FilterObject__c, ApiName__c, Order__c, Fetcher__c, FieldFilter__c, RepeatApi__c FROM CategorySetting__mdt WHERE Active__c = true];
            for(CategorySetting__mdt categorySetting : categories) {
                if(TOOLING.equalsIgnoreCase(categorySetting.Fetcher__c)) {
                    categoryTooling.put(categorySetting.DeveloperName,categorySetting);
                } else if(METADATA.equalsIgnoreCase(categorySetting.Fetcher__c)) {
                    categoryMetadata.put(categorySetting.DeveloperName,categorySetting);
                } else if(SOQL.equalsIgnoreCase(categorySetting.Fetcher__c)) {
                    categorySOQL.put(categorySetting.DeveloperName,categorySetting);
                } 
                categorySettingByName.put(categorySetting.developerName,categorySetting); 
            }
    }
    
    /**
    * @description  get the categories name according to the operation
    * @return  Set<String> 
    *  
    **/
    public static Set<String> getCategoryNamesByOperation(string operation){
        return TOOLING.equalsIgnoreCase(operation) ? categoryTooling.keySet() :
               METADATA.equalsIgnoreCase(operation) ? categoryMetadata.keySet() :
               SOQL.equalsIgnoreCase(operation) ? categorySOQL.keySet():new Set<String>();
    }

    /**
    * @description  get the category setting  by name 
    * @return  CategorySetting__mdt 
    *  
    **/
    public static CategorySetting__mdt getCategorySettingByName(string label) {
        return categorySettingByName.get(label);
    }

    /**
    * @description get the categorysettings according to the operation 
    * @return  List<CategorySetting__mdt> 
    *  
    **/
    public static List<CategorySetting__mdt> getCategorySettingsByOperation(string operation){
        return TOOLING.equalsIgnoreCase(operation) ? categoryTooling.values() :
               METADATA.equalsIgnoreCase(operation) ? categoryMetadata.values() :
               SOQL.equalsIgnoreCase(operation) ? categorySOQL.values():new List<CategorySetting__mdt>();
        
    }
    /**
    * @description get the all category settings
    * @return  List<CategorySetting__mdt> 
    *  
    **/
    public static List<CategorySetting__mdt> getAllCategorySettings(){
        return categorySettingByName.values();
    }  
}