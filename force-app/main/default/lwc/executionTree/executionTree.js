import { LightningElement, api, wire, track } from 'lwc';
import getObjectMetadata from '@salesforce/apex/ExecutionTreeController.getObjectMetadata';
import { showErrorMessage } from 'c/idUtils';
import { refreshApex } from '@salesforce/apex';

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
    
    // Variable to refresh data.
    _wiredRecords;

    // Input variable for dynamic interaction or parent component.
    @api
    get objectLabel() {
        return this._objectLabel;
    }
    set objectLabel(value) {
        if(value !== '' && value !== undefined){     
            this._objectLabel = value;
            this.spinner = true;
            refreshApex(this._wiredRecords).then(() => {
                this.spinner = false;
            });
        }
    }

    @api
    get refreshDatetime(){
        return this._refreshDatetime;
    }

    set refreshDatetime(value){
        this.spinner = true;
        refreshApex(this._wiredRecords).then(() => {
            this.spinner = false;
        });
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
     * @param objectName 
    **/
    @wire(getObjectMetadata, { objectName: '$objectDeveloperName'})
    wiredMockRecords(result) {
        this._wiredRecords = result;
        if (result.data) {
            console.log(JSON.stringify(result.data));
            this.operationsByCategory = result.data;
        } else if (result.error) {
            console.log(JSON.stringify(result.error));
            this.dispatchEvent(showErrorMessage(result.error));
        }
        this.spinner = false;
    }
}