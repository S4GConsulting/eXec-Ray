/**
 * @description       : 
 * @author            : andres.ortiz@s4g.es
 * @group             : 
 * @last modified on  : 04-01-2022
 * @last modified by  : andres.ortiz@s4g.es
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