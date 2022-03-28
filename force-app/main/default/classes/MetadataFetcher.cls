/**
 * @description       : Base Fetcher Class. To be extended.
**/
public abstract class MetadataFetcher {
    

    /**
    * @description Executes all metadata request logic
    * @param sobjectNames Names of Salesforce objects to be targeted during request. 
    * @param ; 
    * @return Wrapper? 
    **/
    abstract public List<CategoryOperation> requestMetadata(List<String> sobjectNames);

    /**
    * @description Transforms metadata into a readable structure.
    * @param ; 
    * @return Wrapper? 
    **/
    abstract public List<CategoryOperation> parseMetadata();
}
