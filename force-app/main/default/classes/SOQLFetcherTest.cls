/**
 * @description       : 
 * @author            : andres.ortiz@s4g.es
 * @group             : 
 * @last modified on  : 04-19-2022
 * @last modified by  : andres.ortiz@s4g.es
**/

@IsTest
public with sharing class SOQLFetcherTest {

    
    @IsTest
    static void requestMetadataTest() {
        Map<String,CategorySetting__mdt> categorySettingByLabels = new Map<String,CategorySetting__mdt>();
        Set<String> categoryDeveloperName = new Set<String>(); 
        SOQLFetcher soqlFetcher = new SOQLFetcher();
        List<CategorySetting__mdt> categorySettings = [SELECT Id, DeveloperName, Label, Order__c FROM CategorySetting__mdt where Fetcher__c = 'SOQL'];
        for(CategorySetting__mdt category :categorySettings){
            categorySettingByLabels.put(category.Label,category);
            categoryDeveloperName.add(category.DeveloperName);
        }
        String JSONparse = '{"Name":"PruebaRequestMetadata", "LastModifiedDate" : "2012-04-23", "CreatedDate" : "2012-04-23", "Active" : true, "SobjectType": "Case"}';
        AssignmentRule rule = (AssignmentRule) JSON.deserialize(JSONparse, AssignmentRule.class);
        soqlFetcher.metadataObjects.add(rule);
        Test.startTest();
            Map<String, List<CategoryOperation>> soqlResults = soqlFetcher.requestMetadata(new List<String>{'Case'}, categoryDeveloperName);
        Test.stopTest();
        System.assertEquals(true,!soqlResults.isEmpty(), 'The category response is not empty');
        
        for(CategoryOperation categoryOperationRecord : soqlResults.get('Case')){
            System.assertEquals(true, categorySettingByLabels.keySet().contains(categoryOperationRecord.category), 'The category is in response');
            System.assertEquals(Integer.valueOf(categorySettingByLabels.get(categoryOperationRecord.category).Order__c), categoryOperationRecord.order, 'The category order is correct');
            if(categoryOperationRecord.category.equalsIgnoreCase('Assignment Rules')){
                System.assertEquals(False, categoryOperationRecord.operations.isEmpty(), 'The record is not empty');
            }
        }
    }
}