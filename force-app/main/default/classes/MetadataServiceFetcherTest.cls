/**
 * @description       : Tests for MetadataServiceFetcher class
**/
@isTest
public with sharing class MetadataServiceFetcherTest {

    private static Set<String> categories = CategorySettingHelper.getCategoryNamesByOperation('Metadata');

    @isTest
    static void testRequestMetadataSuccess() {

        MetadataServiceFetcher metadataServiceRequest = new MetadataServiceFetcher();

        Test.startTest();
        Test.setMock(WebServiceMock.class, new MetadataServiceMock());
        Map<String, List<CategoryOperation>> metadataResults = metadataServiceRequest.requestMetadata(new List<String>{'Account'}, MetadataServiceFetcherTest.categories);
        Test.stopTest();

        for(CategoryOperation catOperation : metadataResults.get('Account')) {
            System.assert(catOperation.operations.size() > 0, 'There are no operations for ' + catOperation.category);
        }
    }
}
