/**
* @description : wrapper composite error class.
**/
global class ToolingCompositeOperationError{

    public CompositeResponse[] compositeResponse;

    public class CompositeResponse {
        public Body[] body;
        public HttpHeaders httpHeaders;
        public Integer httpStatusCode; //400
        public String referenceId;	  //Flows
    }

    private class Body {
        public String errorCode; //PROCESSING_HALTED
        public String message;	//The transaction was rolled back since another operation in the same transaction failed.
    }

    private class HttpHeaders {}

    /**
    * @description : return a string JSON format to serialize.
    * @return String 
    **/
    public static String getExampleErrorMessage(){
        return '{'+
        '    "compositeResponse": ['+
        '        {'+
        '            "body": ['+
        '                {'+
        '                    "errorCode": "PROCESSING_HALTED",'+
        '                    "message": "The transaction was rolled back since another operation in the same transaction failed."'+
        '                }'+
        '            ],'+
        '            "httpHeaders": {},'+
        '            "httpStatusCode": 400,'+
        '            "referenceId": "Flows"'+
        '        }' +
        '}';
    }
}