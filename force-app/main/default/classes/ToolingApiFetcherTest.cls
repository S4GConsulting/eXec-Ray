/**
 * @description       : 
 * @author            : Raúl Iglesias
 * @group             : 
 * @last modified on  : 04-12-2022
 * @last modified by  : Raúl Iglesias
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
        //TO DO :PENDING REVIEW ASSERTS UNTIL ToolingApiFetcher class is finished
        for(CategoryOperation categoryOperationRecord : toolingResults.get('Account')){
            if(categoryOperationRecord.category.equals('ValidationRules')){
                System.assertEquals(2, categoryOperationRecord.operations.size(), 'The expected ValidationRules number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('Test_VR_1') || operationRecord.developerName.equals('Test_VR_2'), 'The expected ValidationRules developerName is incorrect');
                    if(operationRecord.developerName.equals('Test_VR_1')){
                        System.assertEquals(operationRecord.createdDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The VR createdDate is incorrect');
                        System.assertEquals(operationRecord.lastModifiedDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The VR lastModifyDate is incorrect');
                        System.assertEquals(operationRecord.label, 'CET_Count_Validator', 'The VR label is incorrect');
                        System.assertEquals(operationRecord.namespace, 'CMTD', 'The VR namespace is incorrect');
                        System.assertEquals(operationRecord.developerName, 'TBD', 'The VR developerName is incorrect');
                    }else if(operationRecord.developerName.equals('Test_VR_2')){
                        System.assertEquals(operationRecord.createdDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The VR createdDate is incorrect');
                        System.assertEquals(operationRecord.lastModifiedDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The VR lastModifyDate is incorrect');
                        System.assertEquals(operationRecord.label, 'Colour_Populated_For_Badge', 'The VR label is incorrect');
                        System.assertEquals(operationRecord.namespace, 'CMTD', 'The VR namespace is incorrect');
                        System.assertEquals(operationRecord.namespace, 'TBD', 'The VR developerName is incorrect');
                    }
                }
            }else if(categoryOperationRecord.category.equals('AutoResponseRules')){
                System.assertEquals(1, categoryOperationRecord.operations.size(), 'The expected AutoResponseRules number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('Test_AR'), 'The expected AutoResponseRule developerName is incorrect');
                    System.assertEquals(operationRecord.createdDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The AutoResponseRule createdDate is incorrect');
                    System.assertEquals(operationRecord.lastModifiedDate, Date.valueOf('2020-02-15T08:03:05.000+0000'), 'The AutoResponseRule lastModifyDate is incorrect');
                    System.assertEquals(operationRecord.label, 'Test_AR', 'The AutoResponseRule label is incorrect');
                    System.assertEquals(operationRecord.namespace, '', 'The AutoResponseRule namespace is incorrect');
                    System.assertEquals(operationRecord.developerName, 'Test_AR', 'The AutoResponseRule developerName is incorrect');
                }
            }else if(categoryOperationRecord.category.equals('BeforeTrigger')){
                System.assertEquals(2, categoryOperationRecord.operations.size(), 'The expected BeforeTrigger number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('CleanUpRecords2') , 'The expected BeforeTrigger developerName is incorrect');
                    System.assertEquals(operationRecord.label, 'CleanUpRecords2', 'The BeforeTrigger label is incorrect');
                    System.assertEquals(operationRecord.namespace, 'APXTConga4', 'The BeforeTrigger namespace is incorrect');
                    System.assertEquals(operationRecord.developerName, 'CleanUpRecords2', 'The BeforeTrigger developerName is incorrect');
                }
            }else if(categoryOperationRecord.category.equals('AfterTrigger')){
                System.assertEquals(2, categoryOperationRecord.operations.size(), 'The expected AfterTrigger number is incorrect');
                for(CategoryOperation.Operation operationRecord : categoryOperationRecord.operations){
                    System.assert( operationRecord.developerName.equals('TestEmailTemplateTrigger'), 'The expected AfterTrigger developerName is incorrect');
                    System.assertEquals(operationRecord.label, 'TestEmailTemplateTrigger', 'The AfterTrigger label is incorrect');
                    System.assertEquals(operationRecord.namespace, 'APXTConga4', 'The AfterTrigger namespace is incorrect');
                    System.assertEquals(operationRecord.developerName, 'TestEmailTemplateTrigger', 'The AfterTrigger developerName is incorrect');
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