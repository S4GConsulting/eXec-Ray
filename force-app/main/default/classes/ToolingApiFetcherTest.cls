/**
 * @description       : 
 * @last modified on  : 04-18-2022
**/
@IsTest
public with sharing class ToolingApiFetcherTest {

    private static Set<String> categories = CategorySettingHelper.getCategoryNamesByOperation('Tooling');
    
    @IsTest
    static void testRequestMetadataSuccessResponse() {

        ToolingApiFetcher toolingApiRequest = new ToolingApiFetcher();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ToolingApiMock('OK'));
            Map<String, List<CategoryOperation>> toolingResults = toolingApiRequest.requestMetadata(new List<String>{'Account'}, ToolingApiFetcherTest.categories);
        Test.stopTest();

        System.assert(!toolingResults.isEmpty());
        
        for(CategoryOperation categoryOperationRecord : toolingResults.get('Account')){

            if(categoryOperationRecord.category.equals('Validation Rules')){
                System.assertEquals(2, categoryOperationRecord.operations.size(), 'The expected ValidationRules number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('APXTConga4__Account.CET_Count_Validator') || operationRecord.developerName.equals('CMTD__Account.Colour_Populated_For_Badge'), 'The expected ValidationRules developerName is incorrect');
                    if(operationRecord.developerName.equals('APXTConga4__Account.CET_Count_Validator')){
                        System.assertEquals(String.valueOf(operationRecord.createdDate), '2020-02-15 08:03:05', 'The VR createdDate is incorrect');
                        System.assertEquals(String.valueOf(operationRecord.lastModifiedDate), '2020-02-15 08:03:05', 'The VR lastModifyDate is incorrect');
                        System.assertEquals(operationRecord.label, 'CET_Count_Validator', 'The VR label is incorrect');
                        System.assertEquals(operationRecord.namespace, 'APXTConga4', 'The VR namespace is incorrect');
                    }else if(operationRecord.developerName.equals('CMTD__Account.Colour_Populated_For_Badge')){
                        System.assertEquals(String.valueOf(operationRecord.createdDate), '2020-02-15 08:03:05', 'The VR createdDate is incorrect');
                        System.assertEquals(String.valueOf(operationRecord.lastModifiedDate), '2020-02-15 08:03:05', 'The VR lastModifyDate is incorrect');
                        System.assertEquals(operationRecord.label, 'Colour_Populated_For_Badge', 'The VR label is incorrect');
                        System.assertEquals(operationRecord.namespace, 'CMTD', 'The VR namespace is incorrect');
                    }
                }
            }else if(categoryOperationRecord.category.equals('Before Triggers')){
                System.assertEquals(1, categoryOperationRecord.operations.size(), 'The expected BeforeTrigger number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('APXTConga4__CleanUpRecords2') , 'The expected BeforeTrigger developerName is incorrect');
                    System.assertEquals(operationRecord.label, 'CleanUpRecords2', 'The BeforeTrigger label is incorrect');
                    System.assertEquals(operationRecord.namespace, 'APXTConga4', 'The BeforeTrigger namespace is incorrect');
                }
            }else if(categoryOperationRecord.category.equals('After Triggers')){
                System.assertEquals(1, categoryOperationRecord.operations.size(), 'The expected AfterTrigger number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('APXTConga4__TestEmailTemplateTrigger') , 'The expected AfterTrigger developerName is incorrect');
                    System.assertEquals(operationRecord.label, 'TestEmailTemplateTrigger', 'The AfterTrigger label is incorrect');
                    System.assertEquals(operationRecord.namespace, 'APXTConga4', 'The AfterTrigger namespace is incorrect');
                }
            }
        }
    }

    @IsTest
    static void testRequestMetadataErrorResponse() {

        String errorMessage = '';

        ToolingApiFetcher toolingApiRequest = new ToolingApiFetcher();
        Map<String, List<CategoryOperation>> toolingResults = new Map<String, List<CategoryOperation>>();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ToolingApiMock('ERROR'));

            try{
                toolingResults = toolingApiRequest.requestMetadata(new List<String>{'Account'}, ToolingApiFetcherTest.categories);
            }catch(Exception e){
                errorMessage = e.getMessage();
            } 
        Test.stopTest();

        System.assert(toolingResults.isEmpty(), 'Incorrect operation results');
        System.assertEquals('GENERIC ERROR', errorMessage, 'The expected exception has not been launched');
    }


    @IsTest
    static void testRequestMetadataInvalidSessionResponse() {

        String errorMessage = '';

        ToolingApiFetcher toolingApiRequest = new ToolingApiFetcher();
        Map<String, List<CategoryOperation>> toolingResults = new Map<String, List<CategoryOperation>>();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new ToolingApiMock('INVALID SESSION'));

            try{
                toolingResults = toolingApiRequest.requestMetadata(new List<String>{'Account'}, ToolingApiFetcherTest.categories);
            }catch(Exception e){
                errorMessage = e.getMessage();
            } 
        Test.stopTest();

        System.assert(toolingResults.isEmpty(), 'Incorrect operation results');
        System.assertEquals('INVALID SESSION', errorMessage, 'The expected exception has not been launched');
    }
}