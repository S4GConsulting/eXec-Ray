/**
 * @description       : Operations that ocurrs during a DML execution grouped for each of the categories
**/
public class CategoryOperation implements Comparable {

    @AuraEnabled
    public String category;
    @AuraEnabled
    public Integer order;
    @AuraEnabled
    public List<Operation> operations;

    public class Operation {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String developerName;
        @AuraEnabled
        public Integer order;
        @AuraEnabled
        public String url;
        @AuraEnabled
        public String namespace;
        @AuraEnabled
        public Datetime createdDate;
        @AuraEnabled
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