/**
 * @description       : Base Fetcher Class. To be extended.
**/
public abstract class MetadataFetcher {
    
    private Map<String, Integer> categoriesOrder = new Map<String, Integer>{
        'Record Before Trigger Flows' => 0,
        'Before Triggers' => 1,
        'Validation rules' => 2,
        'Duplicate rules' => 3,
        'After Triggers' => 4,
        'Assignment Rules' => 5,
        'Autoresponse Rules' => 6,
        'Workflow Rules' => 7,
        'Process Builders' => 8,
        'Escalation Rules' => 9,
        'Record After Tirgger Flows' => 10,
        'Entitlement Rules' => 11
    };

    protected Map<String, List<CategoryOperation>> operationsByObject = new Map<String, List<CategoryOperation>>();
    protected List<String> sobjectNames = new List<String>();

    /**
    * @description Class constructor
    * @param sobjectNames 
    * @param categories 
    **/
    public MetadataFetcher(List<String> sobjectNames, List<String> categories) {
        this.sobjectNames = sobjectNames;
        for(String sobjectName : sobjectNames) {
            List<CategoryOperation> categoryOperations = new List<CategoryOperation>();
            for(String categoryName : categories) {
                CategoryOperation catOperation = new CategoryOperation();
                catOperation.category = categoryName;
                catOperation.order = this.categoriesOrder.get(categoryName);
                catOperation.operations = new List<CategoryOperation.Operation>();
                categoryOperations.add(catOperation);
            }
            this.operationsByObject.put(sobjectName, categoryOperations);
        }
    }

    /**
    * @description Executes all metadata request logic
    * @param sobjectNames Names of Salesforce objects to be targeted during request. 
    * @param ; 
    * @return Map containing List<CategoryOperation> per SFObject name. 
    **/
    abstract public Map<String, List<CategoryOperation>> requestMetadata();

    /**
    * @description Transforms metadata into a readable structure.
    **/
    abstract private void parseMetadata();
}