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
                result.records = new MetadataService.SharingRules[] {
                };
                MetadataService.readSharingRulesResponse_element responseElement = new MetadataService.readSharingRulesResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else if (r.type_x == 'EscalationRules') {
    
                MetadataService.ReadEscalationRulesResult result = new MetadataService.ReadEscalationRulesResult();
                result.records = new MetadataService.EscalationRules[] {
                };
    
                MetadataService.readEscalationRulesResponse_element responseElement = new MetadataService.readEscalationRulesResponse_element();
                responseElement.result = result;
    
                return responseElement;
    
            } else if (r.type_x == 'Flow') {
    
                MetadataService.ReadFlowResult result = new MetadataService.ReadFlowResult();
                result.records = new MetadataService.Flow[] {
                };
    
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

        MetadataService.FileProperties [] result =  new List<MetadataService.FileProperties>();


        MetadataService.listMetadataResponse_element responseElement = new MetadataService.listMetadataResponse_element();
        responseElement.result = result;

        return responseElement;
    }
}