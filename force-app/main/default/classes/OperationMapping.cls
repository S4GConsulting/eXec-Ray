/**
 * @description       : Mapping for each tipe of SObject in SOQLFetcher
**/
public virtual class OperationMapping {
    public String label {get; protected set;}
    public String developerName {get; protected set;}
    public String namespace {get; protected set;}
    public String createdDate {get; protected set;}
    public String lastModifiedDate {get; protected set;}
    public String active {get; protected set;}

    public class DuplicateRule extends OperationMapping {
        public DuplicateRule() {
            label = 'MasterLabel';
            developerName = 'DeveloperName';
            namespace = 'NamespacePrefix';
            createdDate = 'CreatedDate';
            lastModifiedDate = 'LastModifiedDate';
            active = 'IsActive';
        }
    }

    public class AssignmentRule extends OperationMapping {
        public AssignmentRule() {
            label = 'Name';
            developerName = 'Name';
            createdDate = 'CreatedDate';
            lastModifiedDate = 'LastModifiedDate';
            active = 'Active';
        }
    }

    public class SlaProcess extends OperationMapping {
        public SlaProcess() {
            label = 'Name';
            developerName = 'NameNorm';
            createdDate = 'CreatedDate';
            lastModifiedDate = 'LastModifiedDate';
            active = 'IsActive';
        }
    }
}
