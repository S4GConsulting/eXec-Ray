/**
 * @description       : Base Fetcher Class. To be extended.
**/
public abstract class MetadataFetcher {
    
    protected Map<String, List<CategoryOperation>> operationsByObject = new Map<String, List<CategoryOperation>>();
    protected List<String> sobjectNames = new List<String>();

    /**
    * @description Class constructor, every class that extends this class needs to call init() in requestMetadata();
    * @param sobjectNames 
    * @param categories 
    **/
    protected void init(List<String> sobjectNames, Set<String> categories) {
        this.sobjectNames = sobjectNames;
        for(String sobjectName : sobjectNames) {
            List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
            for(String categoryName : categories) {
                CategorySetting__mdt category = CategorySettingHelper.getCategorySettingByName(categoryName);
                CategoryOperation catOperation = new CategoryOperation();
                catOperation.category = category.Label;
                catOperation.order = Integer.valueOf(category.Order__c);
                catOperation.operations = new List<CategoryOperation.Operation>();
                categoryOperations.add(catOperation);
            }
            this.operationsByObject.put(sobjectName, categoryOperations);
        }
    }

    /**
    * @description Executes all metadata request logic
    * @param sobjectNames Names of Salesforce objects to be targeted during request. 
    * @param categories
    * @return Map containing List<CategoryOperation> per SFObject name. 
    **/
    abstract public Map<String, List<CategoryOperation>> requestMetadata(List<String> sobjectNames, Set<String> categories);

    /**
    * @description Transforms metadata into a readable structure.
    **/
    abstract protected void parseMetadata();
    
    /**
    * @description indicates the position of the category in the list
    * @param categoryName. 
    * @return Integer. 
    **/
    protected Integer getCategoryIndex(String categoryName) {
        Integer index;
        List<CategoryOperation> categoryOperations = this.operationsByObject.get(new List<String>(this.operationsByObject.keySet())[0]);
        // Get the first element that matches the category
        for(Integer i = 0; i <= categoryOperations.size(); i++) {
            if(categoryOperations[i].category == categoryName) {
                index = i;
                break;
            }
        }
        return index;
    }
}