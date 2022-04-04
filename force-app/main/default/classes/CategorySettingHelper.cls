/**
 * @description       : 
 * @author            : andres.ortiz@s4g.es
 * @group             : 
 * @last modified on  : 04-01-2022
 * @last modified by  : andres.ortiz@s4g.es
**/
public with sharing class CategorySettingHelper {
    private static Map<String,Category_Setting__mdt> categorySettingToolingByName;
    public static void fillCategoryTooling(){
        if(categorySettingToolingByName == null){
            categorySettingToolingByName = new Map<String,Category_Setting__mdt>();
            for(Category_Setting__mdt categorySetting :[Select Id, DeveloperName, Label, ReferenceId__c, QualifiedApiName, Fields__c, FilterObject__c, ApiName__c, Order__c, Fetcher__c, Field_Filter__c, RepeatApi__c FROM Category_Setting__mdt Where Fetcher__c = 'Tooling']){
                categorySettingToolingByName.put(categorySetting.DeveloperName, categorySetting);
            }
        }
    }
    public static Category_Setting__mdt getCategorySetting(string label) {
        return categorySettingToolingByName.get(label);
    }

    public static List<Category_Setting__mdt> getCategorySettingsTooling(){
        return categorySettingToolingByName.values();
    }
}