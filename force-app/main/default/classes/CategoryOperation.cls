/**
 * @description       : Operations that ocurrs during a DML execution grouped for each of the categories
**/
public class CategoryOperation implements Comparable {

    public String category;
    public Integer order;
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

    /**
    * @description Implements Comparable interface in order to sort by order of CategoryOperation
    * @param compareTo 
    * @return Integer 
    **/
    public Integer compareTo(Object compareTo) {
        CategoryOperation compareToCategory = (CategoryOperation)compareTo;
        if(order > compareToCategory.order) {return 1;}
        else if(order < compareToCategory.order) {return -1;}
        return 0;
    }
}