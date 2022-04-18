/**
 * @description       : Tests for MetadataServiceFetcher class
**/
@isTest
public with sharing class MetadataServiceFetcherTest {

    private static Set<String> categories = CategorySettingHelper.getCategoryNamesByOperation('Metadata');

    @isTest
    static void test_requestMetadataSuccess() {

        MetadataServiceFetcher metadataServiceRequest = new MetadataServiceFetcher();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Map<String, List<CategoryOperation>> metadataResults = metadataServiceRequest.requestMetadata(new List<String>{'Account'}, MetadataServiceFetcherTest.categories);
        Test.stopTest();
    }
}
