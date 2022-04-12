/**
 * @description: helper class to collect information from metadata categories
**/
public without sharing class CategorySettingHelper {
    private static final string TOOLING = 'Tooling';
    private static final string METADATA = 'Metadata';
    private static final string SOQL = 'SOQL';
    private static Map<String,Category_Setting__mdt> categoryTooling;
    
    private static Map<String,Category_Setting__mdt> categoryMetadata;
    private static Map<String,Category_Setting__mdt> categorySOQL;
    private static Map<String,Category_Setting__mdt> categorySettingByName;
    
    /**
    * @description filling of the attributes of the class corresponding to the category
    *  
    **/
    private static void fillCategory() {
        if(categorySettingByName == null){
            categoryTooling = new Map<String,Category_Setting__mdt>();
            categoryMetadata = new Map<String,Category_Setting__mdt>();
            categorySOQL = new Map<String,Category_Setting__mdt>();
            categorySettingByName = new Map<String,Category_Setting__mdt>();
            List<Category_Setting__mdt> categories = [Select Id, DeveloperName, Label, ReferenceId__c, QualifiedApiName, Fields__c, FilterObject__c, ApiName__c, Order__c, Fetcher__c, Field_Filter__c, RepeatApi__c FROM Category_Setting__mdt];
            for(Category_Setting__mdt categorySetting : categories) {
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
    }
    
    /**
    * @description  get the categories name according to the operation
    * @return  Set<String> 
    *  
    **/
    public static Set<String> getCategoryNamesByOperation(string operation){
        fillCategory();
        return TOOLING.equalsIgnoreCase(operation) ? categoryTooling.keySet() :
               METADATA.equalsIgnoreCase(operation) ? categoryMetadata.keySet() :
               SOQL.equalsIgnoreCase(operation) ? categorySOQL.keySet():new Set<String>();
    }

    /**
    * @description  get the category setting  by name 
    * @return  Category_Setting__mdt 
    *  
    **/
    public static Category_Setting__mdt getCategorySettingByName(string label) {
        fillCategory();
        return categorySettingByName.get(label);
    }

    /**
    * @description get the categorysettings according to the operation 
    * @return  List<Category_Setting__mdt> 
    *  
    **/
    public static List<Category_Setting__mdt> getCategorySettingsByOperation(string operation){
        fillCategory();
        return TOOLING.equalsIgnoreCase(operation) ? categoryTooling.values() :
               METADATA.equalsIgnoreCase(operation) ? categoryMetadata.values() :
               SOQL.equalsIgnoreCase(operation) ? categorySOQL.values():new List<Category_Setting__mdt>();
        
    }
    /**
    * @description get the all category settings
    * @return  List<Category_Setting__mdt> 
    *  
    **/
    public static List<Category_Setting__mdt> getAllCategorySettings(){
        fillCategory();
        return categorySettingByName.values();
    }
    
}