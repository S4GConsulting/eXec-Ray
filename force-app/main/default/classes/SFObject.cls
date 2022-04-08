/**
 * @description       : Stores the SObject info, categorizing them as Standard or Custom.
**/

public class SFObject {
    @AuraEnabled
    public String label;

    @AuraEnabled
    public String apiName;

    @AuraEnabled
    public String type;

}