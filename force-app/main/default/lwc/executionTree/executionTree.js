import { LightningElement, api, wire, track } from 'lwc';
import getObjectMetadata from '@salesforce/apex/ExecutionTreeController.getObjectMetadata';
import { showErrorMessage } from 'c/idUtils';

//Custom Labels
import PLEASE_SELECT_OBJECT from '@salesforce/label/c.PLEASE_SELECT_OBJECT';

export default class ExecutionTree extends LightningElement {

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    // Custom labels
    label = {PLEASE_SELECT_OBJECT};

    // To control spinner visibility.
    _objectLabel;

    // Input variable for dynamic interaction or parent component.
    @api objectDeveloperName;

    // Input variable for dynamic interaction or parent component.
    @api
    get objectLabel() {
        return this._objectLabel;
    }
    set objectLabel(value) {
        
        if(value && value !== ''){ // Avoid first render callback.
            this._objectLabel = value;
            this.spinner = true;
            this.getObjectMetadataRecords();
        }
    }

    // Input variable for refresh interaction.
    @api
    get refreshDatetime(){
        return this._refreshDatetime;
    }

    set refreshDatetime(value){
        this.spinner = true;
        this.getObjectMetadataRecords();
        this._refreshDatetime = value; 
    }

    // Variable to store the different operations by type of category as VRs, triggers, flow trigger..
    @track operationsByCategory;

    // Variable to control when the spinner have to show
    spinner;

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/

    /**
     * @description :control show time line items childs
    **/
    get isAnyOperationCategory(){
        return this.operationsByCategory  && this.operationsByCategory.length > 0;
    }

    /**
     * @description : control visibility object details.
    **/
    get objectIsSelected(){
        return this.objectLabel ? true : false;
    }
    
    /**
     * @description : get execution data records.
    **/
    getObjectMetadataRecords(){
        getObjectMetadata({objectName : this.objectDeveloperName}).then((data) => {
            this.operationsByCategory = data;
            this.spinner = false;
        }, (error) => {
            this.dispatchEvent(showErrorMessage(error));
            this.spinner = false;
        });
    }
}