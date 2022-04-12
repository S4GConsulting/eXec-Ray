/**
 * @description       : 
 * @author            : andres.ortiz@s4g.es
 * @group             : 
 * @last modified on  : 04-12-2022
 * @last modified by  : Raúl Iglesias
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
    }

    public class Attribute{
        public string type;
        public string url;
    }
    
    public class EntityDefinition {
        public string DeveloperName;
    }
    
    
    /**
    * @description : return a string JSON format to serialize.
    * @return String 
    **/
    public static String getExampleCompositeResponseString(){
        return 	'{'+
		'  "compositeResponse": ['+
		'    {'+
		'      "body": {'+
		'        "totalSize": 319,'+
		'        "done": true,'+
		'        "records": ['+
		'          {'+
		'            "attributes": {'+
		'              "type": "Flow",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/Flow/3011l000000UZ85AAG"'+
		'            },'+
		'            "Id": "3011l000000UZ85AAG",'+
		'            "MasterLabel": "AP - Acciones iniciales"'+
		'          }'+
		'        ]'+
		'      },'+
		'      "httpHeaders": {},'+
		'      "httpStatusCode": 200,'+
		'      "referenceId": "Flows"'+
		'    },'+
		'    {'+
		'      "body": {'+
		'        "totalSize": 2,'+
		'        "done": true,'+
		'        "records": ['+
		'          {'+
		'            "attributes": {'+
		'              "type": "ApexTrigger",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/ApexTrigger/01q2o000000IfijAAC"'+
		'            },'+
		'            "Id": "01q2o000000IfijAAC",'+
		'            "TableEnumOrId": "APXTConga4__Conga_Email_Staging__c",'+
		'            "UsageAfterDelete": false,'+
		'            "UsageAfterInsert": true,'+
		'            "UsageAfterUndelete": false,'+
		'            "UsageAfterUpdate": false,'+
		'            "UsageBeforeDelete": false,'+
		'            "UsageBeforeInsert": true,'+
		'            "UsageBeforeUpdate": false,'+
		'            "Name": "CleanUpRecords2",'+
		'            "NamespacePrefix": "APXTConga4"'+
		'          },'+
		'          {'+
		'            "attributes": {'+
		'              "type": "ApexTrigger",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/ApexTrigger/01q2o000000IfikAAC"'+
		'            },'+
		'            "Id": "01q2o000000IfikAAC",'+
		'            "TableEnumOrId": "APXTConga4__Conga_Email_Template__c",'+
		'            "UsageAfterDelete": false,'+
		'            "UsageAfterInsert": true,'+
		'            "UsageAfterUndelete": false,'+
		'            "UsageAfterUpdate": false,'+
		'            "UsageBeforeDelete": false,'+
		'            "UsageBeforeInsert": false,'+
		'            "UsageBeforeUpdate": true,'+
		'            "Name": "CongaEmailTemplateTrigger",'+
		'            "NamespacePrefix": "APXTConga4"'+
		'          }'+
		'        ]'+
		'      },'+
		'      "httpHeaders": {},'+
		'      "httpStatusCode": 200,'+
		'      "referenceId": "ApexTriggers"'+
		'    },'+
		'    {'+
		'      "body": {'+
		'        "totalSize": 3,'+                         
		'        "done": true,'+
		'        "records": ['+
		'          {'+
		'            "attributes": {'+
		'              "type": "ValidationRule",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/ValidationRule/03d2o000000N0MUAA0"'+
		'            },'+
		'            "ValidationName": "CET_Count_Validator",'+
		'            "EntityDefinition": {'+
		'              "attributes": {'+
		'                "type": "EntityDefinition",'+
		'                "url": "/services/data/v53.0/tooling/sobjects/EntityDefinition/01I2o000001QVSE"'+
		'              },'+
		'              "DeveloperName": "Test_VR_1"'+
		'            },'+
		'            "NamespacePrefix": "APXTConga4",'+
        '            "Active": true,'+
        '            "CreatedDate": "2020-02-15T08:03:05.000+0000",'+
		'            "lastModifiedDate": "2020-02-15T08:03:05.000+0000",'+
        '            "EntityDefinitionId": "ServiceTerritoryMemberTest"'+
		'          },'+
		'          {'+
		'            "attributes": {'+
		'              "type": "ValidationRule",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/ValidationRule/03d2o000000N08hAAC"'+
		'            },'+
		'            "ValidationName": "Colour_Populated_For_Badge",'+
		'            "EntityDefinition": {'+
		'              "attributes": {'+
		'                "type": "EntityDefinition",'+
		'                "url": "/services/data/v53.0/tooling/sobjects/EntityDefinition/01I2o000001QUqG"'+
		'              },'+
		'              "DeveloperName": "Test_VR_2"'+
		'            },'+
		'            "NamespacePrefix": "CMTD",'+
        '            "Active": true,'+
        '            "CreatedDate": "2020-02-15T08:03:05.000+0000",'+
		'            "lastModifiedDate": "2020-02-15T08:03:05.000+0000",'+
        '            "EntityDefinitionId": "ServiceTerritoryMemberTest2"'+
		'          }'+
		'        ]'+
		'      },'+
		'      "httpHeaders": {},'+
		'      "httpStatusCode": 200,'+
		'      "referenceId": "ValidationRules"'+
		'    },'+
		'    {'+
		'      "body": {'+
		'        "totalSize": 1,'+
		'        "done": true,'+
		'        "records": ['+
		'          {'+
		'            "attributes": {'+
		'              "type": "AutoResponseRule",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/AutoResponseRule/01Q2o000000JhS9EAK"'+
		'            },'+
        '            "EntityDefinition": {'+
		'              "attributes": {'+
		'                "type": "EntityDefinition",'+
		'                "url": "/services/data/v53.0/tooling/sobjects/EntityDefinition/01I2o000001QVSE"'+
		'              },'+
		'              "DeveloperName": "Test_AR"'+
		'            },'+
		'            "Name": "Conga Envio Email",'+
		'            "TableEnumOrId": "Send_email__c",'+
        '            "Active": true,'+
        '            "CreatedDate": "2020-02-15T08:03:05.000+0000",'+
		'            "lastModifiedDate": "2020-02-15T08:03:05.000+0000",'+
        '            "EntityDefinitionId": "ServiceTerritoryMemberTest2"'+
		'          }'+
		'        ]'+
		'      },'+
		'      "httpHeaders": {},'+
		'      "httpStatusCode": 200,'+
		'      "referenceId": "AutoResponseRules"'+
		'    },'+
		'    {'+
		'      "body": {'+
		'        "totalSize": 1,'+
		'        "done": true,'+
		'        "records": ['+
		'          {'+
		'            "attributes": {'+
		'              "type": "WorkflowRule",'+
		'              "url": "/services/data/v53.0/tooling/sobjects/WorkflowRule/01Q2o000000JhS9EAK"'+
		'            },'+
		'            "Name": "Conga Envio Email",'+
		'            "TableEnumOrId": "Envio_email__c",'+
		'            "NamespacePrefix": null'+
		'          }'+
		'        ]'+
		'      },'+
		'      "httpHeaders": {},'+
		'      "httpStatusCode": 200,'+
		'      "referenceId": "WorkFlowRules"'+
		'    }'+
		'  ]'+
		'}';
    }
}