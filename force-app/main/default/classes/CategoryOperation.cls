/**
 * @description       : Operations that ocurrs during a DML execution grouped for each of the categories
**/
public class CategoryOperation {

    public String category;
    public List<Operation> operations;

    public class Operation {
        public String label;
        public String developerName;
        public Integer order;
        public String url;
        public String namespace;
        public Datetime createdDate;
        public Datetime lastModifiedDate;
    }
}