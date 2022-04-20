/**
* @description:  wrapper used for tooling response
**/
public class CompositeResponseWrapper {

    public List<Bodys> compositeResponse;

    public class  Bodys{ 
        public Body body;
        public string referenceId;
    }

    public class Body{
        public integer totalSize;
        public boolean done;
        public List<Records> records;
        
    }

    public class Records{
        public Attribute attributes;
        public string Id;
        public string Name;
        public string Label;
        public string DeveloperName;
        public string TableEnumOrId;
        public boolean UsageBeforeInsert;
        public boolean UsageAfterInsert;
        public boolean UsageBeforeUpdate;
        public boolean UsageAfterUpdate;
        public boolean UsageBeforeDelete;
        public boolean UsageAfterDelete;
        public boolean UsageIsBulk;
        public boolean UsageAfterUndelete;
        public string Status;
        public boolean IsValid;
        public string Body;
        public string EntityDefinitionId;
        public boolean Active;
        public string ErrorDisplayField;
        public string ErrorMessage;
        public string ValidationName;
        public string CreatedDate;
        public string LastModifiedDate;
        public string NamespacePrefix;
        public string DataType;
        public EntityDefinition EntityDefinition;
		public String QualifiedApiName;
    }

    public class Attribute{
        public string type;
        public string url;
    }
    
    public class EntityDefinition {
        public string DeveloperName;
		public string QualifiedApiName;
    }

}