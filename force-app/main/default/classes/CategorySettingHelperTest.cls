/**
 * @description: test class categorySettingHelper
 **/
@IsTest
public with sharing class CategorySettingHelperTest {
    private static final string TOOLING = 'Tooling';
    private static final string METADATA = 'Metadata';
    private static final string SOQL = 'SOQL';
    private static final string SHARINGRULES ='SharingRules';
    
    @IsTest
    public static void getCategorySettingsByToolingTest(){
        Test.startTest();
            List<CategorySetting__mdt> categorySettingResponse = CategorySettingHelper.getCategorySettingsByOperation(TOOLING); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getCategorySettingsByMetadataTest(){
        Test.startTest();
            List<CategorySetting__mdt> categorySettingResponse = CategorySettingHelper.getCategorySettingsByOperation(METADATA); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getCategorySettingsBySOQLTest(){
        Test.startTest();
            List<CategorySetting__mdt> categorySettingResponse = CategorySettingHelper.getCategorySettingsByOperation(SOQL); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getCategoryNamesByToolingTest(){
        Test.startTest();
            Set<String> categorySettingResponse = CategorySettingHelper.getCategoryNamesByOperation(TOOLING); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getCategoryNamesByMetadataTest(){
        Test.startTest();
            Set<String> categorySettingResponse = CategorySettingHelper.getCategoryNamesByOperation(METADATA); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getCategoryNamesBySOQLTest(){
        Test.startTest();
            Set<String> categorySettingResponse = CategorySettingHelper.getCategoryNamesByOperation(SOQL); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }
    @IsTest
    public static void getAllCategorySettingsTest(){
        Test.startTest();
            List<CategorySetting__mdt> categorySettingResponse = CategorySettingHelper.getAllCategorySettings(); 
        Test.stopTest();

        System.assertEquals(False,categorySettingResponse.isEmpty() , 'categorySettingResponse is empty.');
    }

    @IsTest
    public static void getCategorySettingByNameTest(){
        Test.startTest();
            CategorySetting__mdt categorySettingResponse = CategorySettingHelper.getCategorySettingByName(SHARINGRULES); 
        Test.stopTest();

        System.assertEquals(SHARINGRULES,categorySettingResponse.developerName , 'categorySettingResponse.developerName is not equals');
    }
}