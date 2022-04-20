/**
 * @description       : Basic mock for the operations used from MetadataService class
**/
public class MetadataServiceMock implements WebServiceMock {

    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType
            ) {

        if (request instanceof MetadataService.readMetadata_element) {
            response.put('response_x', readResponse(request));
        } else if (request instanceof MetadataService.listMetadata_element) {
            response.put('response_x', listResponse(request));
        } else {
            System.assert(false, 'Unexpected request ' + request);
        }
    }

        // Implements couple of requests
        private MetadataService.IReadResponseElement readResponse(Object request) {

            MetadataService.readMetadata_element r = (MetadataService.readMetadata_element) request;
    
            if (r.type_x == 'SharingRules') {
                MetadataService.ReadSharingRulesResult result = new MetadataService.ReadSharingRulesResult();
                result.records = new List<MetadataService.SharingRules>(generateSharingRules());
                MetadataService.readSharingRulesResponse_element responseElement = new MetadataService.readSharingRulesResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else if (r.type_x == 'EscalationRules') {
    
                MetadataService.ReadEscalationRulesResult result = new MetadataService.ReadEscalationRulesResult();
                result.records = new List<MetadataService.EscalationRules>(generateEscalationRules());
    
                MetadataService.readEscalationRulesResponse_element responseElement = new MetadataService.readEscalationRulesResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else if (r.type_x == 'Workflow') {
    
                MetadataService.ReadWorkflowResult result = new MetadataService.ReadWorkflowResult();
                result.records = new List<MetadataService.Workflow>(generateWorkflowRules());
    
                MetadataService.readWorkflowResponse_element responseElement = new MetadataService.readWorkflowResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else if (r.type_x == 'Flow') {
    
                MetadataService.ReadFlowResult result = new MetadataService.ReadFlowResult();
                result.records = new List<MetadataService.Flow>(generateFlows());
    
                MetadataService.readFlowResponse_element responseElement = new MetadataService.readFlowResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else {
    
                System.assert(false, 'Unexpected read type ' + r.type_x);
                return null;
            }
        }

    // Returns query flows
    private MetadataService.listMetadataResponse_element listResponse(Object request) {
        MetadataService.listMetadata_element r = (MetadataService.listMetadata_element) request;

        MetadataService.FileProperties [] result =  new List<MetadataService.FileProperties>(generateFileProperties());


        MetadataService.listMetadataResponse_element responseElement = new MetadataService.listMetadataResponse_element();
        responseElement.result = result;

        return responseElement;
    }

    private List<MetadataService.SharingRules> generateSharingRules() {
        MetadataService.SharingRules [] sharingRules = new List<MetadataService.SharingRules>();

        //SharingCriteriaRule
        MetadataService.SharingRules sharingCriteriaRule = new MetadataService.SharingRules();
        sharingCriteriaRule.fullName = 'Account';
        MetadataService.SharingCriteriaRule sharingCriteriaRuleElement = new MetadataService.SharingCriteriaRule();
        sharingCriteriaRuleElement.label = 'sharingCriteriaRule';
        sharingCriteriaRule.sharingCriteriaRules = new List<MetadataService.SharingCriteriaRule>{sharingCriteriaRuleElement};
        sharingRules.add(sharingCriteriaRule);

        //SharingOwnerRule
        MetadataService.SharingRules sharingOwnerRule = new MetadataService.SharingRules();
        sharingOwnerRule.fullName = 'Account';
        MetadataService.SharingOwnerRule sharingOwnerRuleElement = new MetadataService.SharingOwnerRule();
        sharingOwnerRuleElement.label = 'sharingOwnerRule';
        sharingOwnerRule.sharingOwnerRules = new List<MetadataService.SharingOwnerRule>{sharingOwnerRuleElement};
        sharingRules.add(sharingOwnerRule);

        //SharingTerritoryRule
        MetadataService.SharingRules sharingTerritoryRule = new MetadataService.SharingRules();
        sharingTerritoryRule.fullName = 'Account';
        MetadataService.SharingTerritoryRule sharingTerritoryRuleElement = new MetadataService.SharingTerritoryRule();
        sharingTerritoryRuleElement.label = 'sharingTerritoryRule';
        sharingTerritoryRule.sharingTerritoryRules = new List<MetadataService.SharingTerritoryRule>{sharingTerritoryRuleElement};
        sharingRules.add(sharingTerritoryRule);

        //SharingGuestRule
        MetadataService.SharingRules sharingGuestRule = new MetadataService.SharingRules();
        sharingGuestRule.fullName = 'Account';
        MetadataService.SharingGuestRule sharingGuestRuleElement = new MetadataService.SharingGuestRule();
        sharingGuestRuleElement.label = 'sharingGuestRule';
        sharingGuestRule.sharingGuestRules = new List<MetadataService.SharingGuestRule>{sharingGuestRuleElement};
        sharingRules.add(sharingGuestRule);

        return sharingRules;
    }

    private List<MetadataService.EscalationRules> generateEscalationRules() {
        MetadataService.EscalationRules [] escalationRules = new List<MetadataService.EscalationRules>();
        MetadataService.EscalationRules escalationRule = new MetadataService.EscalationRules();
        escalationRule.fullName = 'Account';
        MetadataService.EscalationRule escalationRuleElement = new MetadataService.EscalationRule();
        escalationRuleElement.active = true;
        escalationRuleElement.fullName = 'escalationRule';
        escalationRule.escalationRule = new List<MetadataService.EscalationRule>{escalationRuleElement};
        escalationRules.add(escalationRule);
        return escalationRules;
    }

    private List<MetadataService.Workflow> generateWorkflowRules() {
        List<MetadataService.Workflow> workflows = new List<MetadataService.Workflow>();
        MetadataService.Workflow workflow = new MetadataService.Workflow();
        workflow.fullName = 'Account';
        MetadataService.WorkflowRule workflowRule = new MetadataService.WorkflowRule();
        workflowRule.fullName = 'WorkflowRule';
        workflowRule.active = true;
        workflow.rules = new List<MetadataService.WorkflowRule>{workflowRule};
        workflows.add(workflow);
        return workflows;
    }

    private List<MetadataService.Flow> generateFlows() {
        List<MetadataService.Flow> flows = new List<MetadataService.Flow>();
        MetadataService.Flow processBuilder =  new MetadataService.Flow();
        MetadataService.FlowMetadataValue metadataValue = new MetadataService.FlowMetadataValue();
        MetadataService.FlowElementReferenceOrValue referenceOrValue = new MetadataService.FlowElementReferenceOrValue();
        referenceOrValue.stringValue ='Account';
        metadataValue.name = 'ObjectType';
        metadataValue.value = referenceOrValue;
        processBuilder.status = 'Active';
        processBuilder.processType = 'Workflow';
        processBuilder.label = 'ProcessBuilder';
        processBuilder.fullName = 'ProcessBuilder';
        processBuilder.processMetadataValues = new List<MetadataService.FlowMetadataValue>{metadataValue};
        flows.add(processBuilder);

        MetadataService.Flow beforeFlow = new MetadataService.Flow();
        beforeFlow.status = 'Active';
        beforeFlow.processType = 'AutoLaunchedFlow';
        beforeFlow.label = 'BeforeFlow';
        beforeFlow.fullName = 'BeforeFlow';
        MetadataService.FlowStart startBeforeFlow = new MetadataService.FlowStart();
        startBeforeFlow.object_x = 'Account';
        startBeforeFlow.triggerType = 'RecordBeforeSave';
        beforeFlow.start = startBeforeFlow;
        beforeFlow.recordUpdates = new List<MetadataService.FlowRecordUpdate>();
        flows.add(beforeFlow);

        
        MetadataService.Flow afterFlow = new MetadataService.Flow();
        afterFlow.status = 'Active';
        afterFlow.processType = 'AutoLaunchedFlow';
        afterFlow.label = 'AfterFlow';
        afterFlow.fullName = 'AfterFlow';
        MetadataService.FlowStart startAfterFlow = new MetadataService.FlowStart();
        startAfterFlow.object_x = 'Account';
        startAfterFlow.triggerType = 'RecordAfterSave';
        afterFlow.start = startAfterFlow;
        afterFlow.recordUpdates = new List<MetadataService.FlowRecordUpdate>();
        flows.add(afterFlow);

        return flows;
    }

    private List<MetadataService.FileProperties> generateFileProperties() {
        List<MetadataService.FileProperties> fileProperties = new List<MetadataService.FileProperties>();
        MetadataService.FileProperties processBuilderProperties = new MetadataService.FileProperties();
        processBuilderProperties.fullName = 'ProcessBuilder';
        processBuilderProperties.createdDate = System.now();
        processBuilderProperties.lastModifiedDate = System.now();
        processBuilderProperties.namespacePrefix = null;
        fileProperties.add(processBuilderProperties);

        MetadataService.FileProperties beforeFlowProperties = new MetadataService.FileProperties();
        beforeFlowProperties.fullName = 'BeforeFlow';
        beforeFlowProperties.createdDate = System.now();
        beforeFlowProperties.lastModifiedDate = System.now();
        beforeFlowProperties.namespacePrefix = null;
        fileProperties.add(beforeFlowProperties);

        MetadataService.FileProperties afterFlowProperties = new MetadataService.FileProperties();
        afterFlowProperties.fullName = 'AfterFlow';
        afterFlowProperties.createdDate = System.now();
        afterFlowProperties.lastModifiedDate = System.now();
        afterFlowProperties.namespacePrefix = null;
        fileProperties.add(afterFlowProperties);
        
        return fileProperties;
    }

}