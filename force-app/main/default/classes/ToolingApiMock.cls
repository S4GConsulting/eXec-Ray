/**
 * @description       : 
 * @author            : Raúl Iglesias
 * @group             : 
 * @last modified on  : 04-20-2022
 * @last modified by  : Raúl Iglesias
**/
global class ToolingApiMock implements HttpCalloutMock {

    private String responseType;
    
    private final String INVALID_SESSION_BODY = '{"message": "Session expired or invalid","errorCode": "INVALID_SESSION_ID"}';

    private final String GENERIC_ERROR_BODY = ToolingCompositeOperationError.getExampleErrorMessage();


    public ToolingApiMock(String responseType){
        this.responseType = responseType;
    }

    /**
    * @description : respond depending on responseType.
    * @author Raúl Iglesias | 11-04-2022
    * @param req 
    * @return HTTPResponse 
    **/
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

         if(this.responseType.equalsIgnoreCase('ERROR')){
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.GENERIC_ERROR_BODY);
            res.setStatus('GENERIC ERROR');
            res.setStatusCode(401);
        }else if(this.responseType.equalsIgnoreCase('INVALID SESSION')){
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.INVALID_SESSION_BODY);
            res.setStatus('INVALID SESSION');
            res.setStatusCode(401);
        }

        return res;
    }
}