/**
 * Copyright (c) 2012, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * This is a dummy test class to obtain 100% coverage for the generated WSDL2Apex code, it is not a funcitonal test class
 **/ 
@isTest  
private class MetadataServiceTest
{    
    /**
     * Dummy Metadata API web service mock class (see MetadataCreateJobTest.cls for a better example)
     **/
	private class WebServiceMockImpl implements WebServiceMock 
	{
		public void doInvoke(
			Object stub, Object request, Map<String, Object> response,
			String endpoint, String soapAction, String requestName,
			String responseNS, String responseName, String responseType) 
		{
			if(request instanceof MetadataService.retrieve_element)
				response.put('response_x', new MetadataService.retrieveResponse_element());
			else if(request instanceof MetadataService.checkDeployStatus_element)
				response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
			else if(request instanceof MetadataService.listMetadata_element)
				response.put('response_x', new MetadataService.listMetadataResponse_element());
			else if(request instanceof MetadataService.checkRetrieveStatus_element)
				response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
			else if(request instanceof MetadataService.describeMetadata_element)
				response.put('response_x', new MetadataService.describeMetadataResponse_element());
			else if(request instanceof MetadataService.deploy_element)
				response.put('response_x', new MetadataService.deployResponse_element());
            else if(request instanceof MetadataService.updateMetadata_element)
                response.put('response_x', new MetadataService.updateMetadataResponse_element());
            else if(request instanceof MetadataService.renameMetadata_element)
                response.put('response_x', new MetadataService.renameMetadataResponse_element());
            else if(request instanceof  MetadataService.cancelDeploy_element)
                response.put('response_x', new MetadataService.cancelDeployResponse_element());
            else if(request instanceof  MetadataService.deleteMetadata_element)
                response.put('response_x', new MetadataService.deleteMetadataResponse_element());
            else if(request instanceof  MetadataService.upsertMetadata_element)
                response.put('response_x', new MetadataService.upsertMetadataResponse_element());
            else if(request instanceof  MetadataService.createMetadata_element)
                response.put('response_x', new MetadataService.createMetadataResponse_element());
            else if(request instanceof  MetadataService.deployRecentValidation_element)
                response.put('response_x', new MetadataService.deployRecentValidationResponse_element());
            else if(request instanceof MetadataService.describeValueType_element)
                response.put('response_x', new MetadataService.describeValueTypeResponse_element());
            else if(request instanceof MetadataService.checkRetrieveStatus_element)
                response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
			return;
		}
	}    
		
	@IsTest
	private static void coverGeneratedCodeCRUDOperations()
	{	
    	// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations     
        Test.startTest();    
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        Test.stopTest();
	}
	
	@IsTest
    private static void coverGeneratedCodeFileBasedOperations1()
    {    	
    	// Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations    
        Test.startTest();     
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.retrieve(null);
        metaDataPort.checkDeployStatus(null, false);
        metaDataPort.listMetadata(null, null);
        metaDataPort.describeMetadata(null);
        metaDataPort.deploy(null, null);
        metaDataPort.checkDeployStatus(null, false);
        metaDataPort.updateMetadata(null);
        metaDataPort.renameMetadata(null, null, null);
        metaDataPort.cancelDeploy(null);
        Test.stopTest();
    }

    @IsTest
    private static void coverGeneratedCodeFileBasedOperations2()
    {       
        // Null Web Service mock implementation
        System.Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService metaDataService = new MetadataService();
        // Invoke operations     
        Test.startTest();    
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.deleteMetadata(null, null);
        metaDataPort.upsertMetadata(null);
        metaDataPort.createMetadata(null);
        metaDataPort.deployRecentValidation(null);
        metaDataPort.describeValueType(null);
        metaDataPort.checkRetrieveStatus(null, null);
        Test.stopTest();
    }
        
	@IsTest
    private static void coverGeneratedCodeTypes()
    {    	       
        // Reference types
        Test.startTest();
        new MetadataService();
        new MetadataService.listMetadataResponse_element();
        new MetadataService.WorkflowRule();
        new MetadataService.checkDeployStatus_element();
        new MetadataService.CodeCoverageWarning();
        new MetadataService.FlowApexPluginCall();
        new MetadataService.FlowInputValidationRule();
        new MetadataService.FlowFormula();
        new MetadataService.WorkflowEmailRecipient();
        new MetadataService.DescribeMetadataResult();
        new MetadataService.FilterItem();
        new MetadataService.LogInfo();
        new MetadataService.FlowElement();
        new MetadataService.FlowInputFieldAssignment();
        new MetadataService.CallOptions_element();
        new MetadataService.FlowRule();
        new MetadataService.FlowRecordUpdate();
        new MetadataService.describeMetadataResponse_element();
        new MetadataService.DeployMessage();
        new MetadataService.FlowSubflowInputAssignment();
        new MetadataService.CodeCoverageResult();
        new MetadataService.WorkflowKnowledgePublish();
        new MetadataService.Workflow();
        new MetadataService.describeMetadata_element();
        new MetadataService.FlowChoice();
        new MetadataService.FlowStep();
        new MetadataService.FlowApexPluginCallInputParameter();
        new MetadataService.WorkflowActionReference();
        new MetadataService.ProfileObjectPermissions();
        new MetadataService.RetrieveResult();
        new MetadataService.WorkflowTimeTrigger();
        new MetadataService.retrieve_element();
        new MetadataService.DescribeMetadataObject();
        new MetadataService.WorkflowOutboundMessage();
        new MetadataService.RunTestSuccess();
        new MetadataService.CustomField();
        new MetadataService.WorkflowTask();
        new MetadataService.deployResponse_element();
        new MetadataService.FlowOutputFieldAssignment();
        new MetadataService.FileProperties();
        new MetadataService.Flow();
        new MetadataService.FlowSubflowOutputAssignment();
        new MetadataService.FlowRecordCreate();
        new MetadataService.AsyncResult();
        new MetadataService.checkRetrieveStatus_element();
        new MetadataService.FlowTextTemplate();
        new MetadataService.FlowNode();
        new MetadataService.RetrieveRequest();
        new MetadataService.ListMetadataQuery();
        new MetadataService.FlowConnector();
        new MetadataService.FlowRecordLookup();
        new MetadataService.DebuggingHeader_element();
        new MetadataService.FlowRecordDelete();
        new MetadataService.FlowDecision();
        new MetadataService.FlowApexPluginCallOutputParameter();
        new MetadataService.SharingRules();
        //new MetadataService.DomainWhitelist
        new MetadataService.RunTestFailure();
        new MetadataService.SharedTo();
        new MetadataService.FlowRecordFilter();
        new MetadataService.FlowScreen();
        new MetadataService.WorkflowAlert();
        new MetadataService.listMetadata_element();
        new MetadataService.ValidationRule();
        new MetadataService.MetadataWithContent();
        new MetadataService.Metadata();
        new MetadataService.FlowSubflow();
        new MetadataService.FlowScreenField();
        new MetadataService.RetrieveMessage();
        new MetadataService.SessionHeader_element();
        new MetadataService.FlowCondition();
        new MetadataService.DeployOptions();
        new MetadataService.FlowAssignment();
        //new MetadataService.CustomApplicationComponents
        new MetadataService.FlowElementReferenceOrValue();
        new MetadataService.EntitlementTemplate();
        //new MetadataService.WorkspaceMappings
        new MetadataService.WorkflowAction();
        new MetadataService.ApexTrigger();
        new MetadataService.FlowAssignmentItem();
        new MetadataService.PackageTypeMembers();
        new MetadataService.deploy_element();
        new MetadataService.retrieveResponse_element();
        new MetadataService.WorkflowFieldUpdate();
        new MetadataService.FlowChoiceUserInput();
        new MetadataService.FlowConstant();
        new MetadataService.PackageVersion();
        new MetadataService.checkRetrieveStatusResponse_element();
        new MetadataService.RunTestsResult();
        new MetadataService.FlowVariable();
        new MetadataService.CodeLocation();
        new MetadataService.FlowDynamicChoiceSet();
        new MetadataService.DebuggingInfo_element();
        new MetadataService.Package_x();
        new MetadataService.DeployResult();
        new MetadataService.checkDeployStatusResponse_element();
        new MetadataService.EscalationRules();
        new MetadataService.EntitlementProcess();
        new MetadataService.EscalationAction();
        new MetadataService.AssignmentRule();
        new MetadataService.AutoResponseRule();
        new MetadataService.EntitlementProcessMilestoneItem();
        new MetadataService.AssignmentRules();
        new MetadataService.AutoResponseRules();
        new MetadataService.RuleEntry();
        new MetadataService.EntitlementSettings();
        new MetadataService.WorkflowSend();
        new MetadataService.EntitlementProcessMilestoneTimeTrigger();
        new MetadataService.EscalationRule();
        //new MetadataService.Branding
        //new MetadataService.PushNotifications
        //new MetadataService.PagesToOpen
        new MetadataService.WorkflowFlowActionParameter();
        new MetadataService.FlowLoop();
        new MetadataService.renameMetadata_element();
        new MetadataService.deleteMetadataResponse_element();
        new MetadataService.Error();
        new MetadataService.SaveResult();
        new MetadataService.readMetadataResponse_element();
        new MetadataService.deleteMetadata_element();
        new MetadataService.WorkflowFlowAction();
        new MetadataService.createMetadataResponse_element();
        new MetadataService.updateMetadata_element();
        new MetadataService.LookupFilter();
        new MetadataService.updateMetadataResponse_element();
        new MetadataService.createMetadata_element();
        new MetadataService.readMetadata_element();
        new MetadataService.ReadWorkflowRuleResult();
        new MetadataService.readWorkflowRuleResponse_element();
        new MetadataService.ReadSharingRulesResult();
        new MetadataService.readSharingRulesResponse_element();
        new MetadataService.ReadEscalationRulesResult();
        new MetadataService.readEscalationRulesResponse_element();
        new MetadataService.ReadEntitlementProcessResult();
        new MetadataService.readEntitlementProcessResponse_element();
        new MetadataService.ReadValidationRuleResult();
        new MetadataService.readValidationRuleResponse_element();
        new MetadataService.ReadAssignmentRulesResult();
        new MetadataService.readAssignmentRulesResponse_element();
        new MetadataService.ReadEscalationRuleResult();
        new MetadataService.readEscalationRuleResponse_element();
        new MetadataService.ReadEntitlementTemplateResult();
        new MetadataService.readEntitlementTemplateResponse_element();
        new MetadataService.ReadWorkflowResult();
        new MetadataService.readWorkflowResponse_element();
        new MetadataService.ReadWorkflowActionResult();
        new MetadataService.readWorkflowActionResponse_element();
        new MetadataService.ReadApexTriggerResult();
        new MetadataService.readApexTriggerResponse_element();
        new MetadataService.ReadEntitlementSettingsResult();
        new MetadataService.readEntitlementSettingsResponse_element();
        new MetadataService.ReadCustomFieldResult();
        new MetadataService.readCustomFieldResponse_element();
        new MetadataService.ReadAssignmentRuleResult();
        new MetadataService.readAssignmentRuleResponse_element();
        new MetadataService.ReadFlowResult();
        new MetadataService.readFlowResponse_element();
        new MetadataService.ReadAutoResponseRuleResult();
        new MetadataService.readAutoResponseRuleResponse_element();
        new MetadataService.ReadPackageResult();
        new MetadataService.readPackageResponse_element();
        new MetadataService.ReadAutoResponseRulesResult();
        new MetadataService.readAutoResponseRulesResponse_element();
        new MetadataService.ReadResult();
        new MetadataService.DeployDetails();
        new MetadataService.renameMetadataResponse_element();
        new MetadataService.cancelDeploy_element();
        new MetadataService.CancelDeployResult();
        new MetadataService.cancelDeployResponse_element();
        new MetadataService.DeleteResult();
        new MetadataService.FlowActionCallInputParameter();
        new MetadataService.FlowActionCallOutputParameter();
        new MetadataService.FlowActionCall();
        new MetadataService.upsertMetadata_element();
        new MetadataService.upsertMetadataResponse_element();
        new MetadataService.ReadWorkflowAlertResult();
        new MetadataService.readWorkflowAlertResponse_element();
        new MetadataService.ReadEscalationRuleResult();
        new MetadataService.ReadWorkflowKnowledgePublishResult();
        new MetadataService.readWorkflowKnowledgePublishResponse_element();
        new MetadataService.ReadWorkflowSendResult();
        new MetadataService.readWorkflowSendResponse_element();
        new MetadataService.ReadWorkflowOutboundMessageResult();
        new MetadataService.readWorkflowOutboundMessageResponse_element();
        new MetadataService.ReadWorkflowFieldUpdateResult();
        new MetadataService.readWorkflowFieldUpdateResponse_element();
        new MetadataService.ReadWorkflowTaskResult();
        new MetadataService.readWorkflowTaskResponse_element();
        new MetadataService.FlowMetadataValue();
        new MetadataService.UpsertResult();
        new MetaDataService.FlowWaitEventInputParameter();
        new MetadataService.FlowWait();
        new MetadataService.FlowWaitEventOutputParameter();
        new MetadataService.FlowWaitEvent();
        new MetadataService.FlowBaseElement();
        new MetaDataService.deployRecentValidationResponse_element();
        new MetaDataService.SharingCriteriaRule();
        new MetaDataService.describeValueType_element();
        new MetaDataService.SharingBaseRule();
        new MetaDataService.deployRecentValidation_element();
        new MetaDataService.SharingTerritoryRule();
        new MetaDataService.AccountSharingRuleSettings();
        new MetaDataService.DescribeValueTypeResult();
        new MetaDataService.ReadSharingTerritoryRuleResult();
        new MetaDataService.readSharingTerritoryRuleResponse_element();
        new MetaDataService.ReadSharingCriteriaRuleResult();
        new MetaDataService.readSharingCriteriaRuleResponse_element();
        new MetaDataService.ReadSharingOwnerRuleResult();
        new MetaDataService.readSharingOwnerRuleResponse_element();
        new MetaDataService.ReadSharingBaseRuleResult();
        new MetaDataService.readSharingBaseRuleResponse_element();
        new MetaDataService.SharingOwnerRule();
        new MetaDataService.PicklistEntry();
        new MetaDataService.ValueTypeField();
        new MetaDataService.AllOrNoneHeader_element();
        new MetaDataService.FlowDefinition();
        new MetadataService.DuplicateRuleFilterItem();
        new MetadataService.DuplicateRule();
        new MetadataService.ValueSetValuesDefinition();
        new MetadataService.DuplicateRuleFilter();
        new MetadataService.DuplicateRuleMatchRule();
        new MetadataService.FlowScreenRuleAction();
        new MetadataService.ObjectMappingField();
        new MetadataService.ValueSet();
        new MetadataService.ObjectMapping();
        new MetadataService.FlowScreenRule();
        new MetadataService.ValueSettings();
        Test.stopTest();
    }

    @IsTest
    private static void elfMissingGetRecordsTest() { // elf patch
        Test.startTest();
        new MetadataService.ReadFlowResult().getRecords();
        new MetadataService.ReadWorkflowResult().getRecords();
        new MetadataService.ReadWorkflowRuleResult().getRecords();
        new MetadataService.ReadAssignmentRulesResult().getRecords();
        new MetadataService.ReadAssignmentRuleResult().getRecords();
        new MetadataService.ReadAutoResponseRulesResult().getRecords();
        new MetadataService.ReadAutoResponseRuleResult().getRecords();
        new MetadataService.ReadEscalationRulesResult().getRecords();
        new MetadataService.ReadEscalationRuleResult().getRecords();
        new MetadataService.ReadPackageResult().getRecords();
        new MetadataService.ReadEntitlementProcessResult().getRecords();
        new MetadataService.ReadEntitlementTemplateResult().getRecords();
        new MetadataService.ReadEntitlementSettingsResult().getRecords();
        new MetadataService.ReadWorkflowActionResult().getRecords();
        new MetadataService.ReadWorkflowTaskResult().getRecords();
        new MetadataService.ReadWorkflowSendResult().getRecords();
        new MetadataService.ReadWorkflowOutboundMessageResult().getRecords();
        new MetadataService.ReadWorkflowKnowledgePublishResult().getRecords();
        new MetadataService.ReadWorkflowFieldUpdateResult().getRecords();
        new MetadataService.ReadWorkflowAlertResult().getRecords();
        new MetadataService.ReadSharingRulesResult().getRecords();
        new MetadataService.ReadSharingBaseRuleResult().getRecords();
        new MetadataService.ReadSharingCriteriaRuleResult().getRecords();
        new MetadataService.ReadSharingOwnerRuleResult().getRecords();
        new MetadataService.ReadSharingTerritoryRuleResult().getRecords();
        new MetadataService.ReadMetadataWithContentResult().getRecords();
        new MetadataService.ReadCustomFieldResult().getRecords();
        new MetadataService.ReadApexTriggerResult().getRecords();
        new MetadataService.ReadValidationRuleResult().getRecords();
        new MetadataService.ReadFlowResult().getRecords();
        new MetadataService.ReadFlowResult().getRecords();
        new MetadataService.ReadCustomValueResult().getRecords();
        Test.stopTest();
    }

    @IsTest
    private static void elfMissingGetResultTest() { // elf patch
        Test.startTest();
        new MetadataService.readWorkflowRuleResponse_element().getResult();
        new MetadataService.readSharingRulesResponse_element().getResult();
        new MetadataService.readEscalationRulesResponse_element().getResult();
        new MetadataService.readEntitlementProcessResponse_element().getResult();
        new MetadataService.readValidationRuleResponse_element().getResult();
        new MetadataService.readAssignmentRulesResponse_element().getResult();
        new MetadataService.readEscalationRuleResponse_element().getResult();
        new MetadataService.readEntitlementTemplateResponse_element().getResult();
        new MetadataService.readWorkflowResponse_element().getResult();
        new MetadataService.readWorkflowActionResponse_element().getResult();
        new MetadataService.readApexTriggerResponse_element().getResult();
        new MetadataService.readEntitlementSettingsResponse_element().getResult();
        new MetadataService.readCustomFieldResponse_element().getResult();
        new MetadataService.readAssignmentRuleResponse_element().getResult();
        new MetadataService.readFlowResponse_element().getResult();
        new MetadataService.readAutoResponseRuleResponse_element().getResult();
        new MetadataService.readPackageResponse_element().getResult();
        new MetadataService.readAutoResponseRulesResponse_element().getResult();
        new MetadataService.readFlowResponse_element().getResult();
        new MetadataService.readFlowResponse_element().getResult();
        new MetadataService.readWorkflowTaskResponse_element().getResult();
        new MetadataService.readWorkflowSendResponse_element().getResult();
        new MetadataService.readWorkflowOutboundMessageResponse_element().getResult();
        new MetadataService.readWorkflowKnowledgePublishResponse_element().getResult();
        new MetadataService.readWorkflowFieldUpdateResponse_element().getResult();
        new MetadataService.readWorkflowAlertResponse_element().getResult();
        new MetadataService.readSharingBaseRuleResponse_element().getResult();
        new MetadataService.readSharingCriteriaRuleResponse_element().getResult();
        new MetadataService.readSharingOwnerRuleResponse_element().getResult();
        new MetadataService.readSharingTerritoryRuleResponse_element().getResult();
        new MetadataService.readMetadataWithContentResponse_element().getResult();
        new MetadataService.readCustomValueResponse_element().getResult();
        Test.stopTest();
    }    
}