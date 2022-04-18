/**
 * @description : wrapper used for tooling request
**/
public class CompositeWrapper {
    public String allOrNone;
    public String collateSubrequests;
    public List<CompositeUnit> compositeRequest;
    
    public class CompositeUnit{
        public String method;
        public String url;
        public String referenceId;
    }
}