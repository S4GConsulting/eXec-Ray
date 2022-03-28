/**
 * @description       : Base Fetcher Class. To be extended.
**/
public abstract class MetadataFetcher {
    

    /**
    * @description Executes all metadata request logic
    * @param sobjectName Name of Salesforce object to be targeted during request. 
    * @param ; 
    * @return abstract 
    **/
    abstract public String requestMetadata(String sobjectName);

    /**
    * @description Transforms metadata into a readable structure.
    * @param ; 
    * @return Wrapper? 
    **/
    abstract public String parseMetadata();
}
