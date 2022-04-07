/**
 * @description       : 
**/
public with sharing class CategorySettingHelper {
    private static final string TOOLING = 'Tooling';
    private static final string METADATA = 'Metadata' ;
    private static final string SOQL = 'SOQL';
    private static Map<String,Category_Setting__mdt> categoryToolingByName;
    private static Map<String,Category_Setting__mdt> categoryMetadataByName;
    private static Map<String,Category_Setting__mdt> categorySOQLByName;
    //private static Map<String,Category_Setting__mdt> categoryWithoutFilterByName;

    public static void fillCategory() {
        if(categoryToolingByName == null){
            categoryToolingByName = new Map<String,Category_Setting__mdt>();
            categoryMetadataByName = new Map<String,Category_Setting__mdt>();
            categorySOQLByName = new Map<String,Category_Setting__mdt>();
            //categoryWithoutFilterByName = new Map<String,Category_Setting__mdt>();
            for(Category_Setting__mdt categorySetting :[Select Id, DeveloperName, Label, ReferenceId__c, QualifiedApiName, Fields__c, FilterObject__c, ApiName__c, Order__c, Fetcher__c, Field_Filter__c, RepeatApi__c FROM Category_Setting__mdt]){
                if(TOOLING.equalsIgnoreCase(categorySetting.Fetcher__c)){
                    categoryToolingByName.put(categorySetting.DeveloperName, categorySetting);
                } else if(METADATA.equalsIgnoreCase(categorySetting.Fetcher__c)){
                    categoryMetadataByName.put(categorySetting.DeveloperName, categorySetting);
               // } else if(METADATA.equalsIgnoreCase(categorySetting.Fetcher__c) && !categorySetting.FilterObject__c) {
               //     categoryWithoutFilterByName.put(categorySetting.DeveloperName, categorySetting);
                } else if(SOQL.equalsIgnoreCase(categorySetting.Fetcher__c)){
                    categorySOQLByName.put(categorySetting.DeveloperName, categorySetting);
                }   
            }
        }
    }
    
    public static Category_Setting__mdt getCategorySettingTooling(string label) {
        return categoryToolingByName.get(label);
    }

    public static List<Category_Setting__mdt> getAllCategorySettingsTooling(){
        return categoryToolingByName.values();
    }
    public static Category_Setting__mdt getCategorySettingMetadata(string label) {
        return categoryMetadataByName.get(label);
    }

    public static List<Category_Setting__mdt> getAllCategorySettingsMetadata(){
        return categoryMetadataByName.values();
    }
    //public static Category_Setting__mdt getCategoryMetadataWithoutFilter(string label) {
    //    return categoryWithoutFilterByName.get(label);
    //}
    //public static List<Category_Setting__mdt> getAllCategoryMetadataWithoutFilter(){
    //    return categoryWithoutFilterByName.values();
    //}
}