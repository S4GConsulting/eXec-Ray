import { LightningElement, api, wire, track } from 'lwc';
import getObjectMetadata from '@salesforce/apex/MockController.getObjectMetadata';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const SUCCESS_TITLE = 'Success';

export default class ExecutionTree extends LightningElement {

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    //To control spinner visibility.
    _objectName;

    //Input variable for dynamic interaction or parent component.
    @api
    get objectName() {
        return this._objectName;
    }
    set objectName(value) {
        this._objectName = value;
        this.spinner = true;
    }

    //Variable to store the different operations by type of category as VRs, triggers, flow trigger..
    @track operationsByCategory;

    //Variable to control when the spinner have to show
    spinner = true;

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/

    get isAnyOperationCategory(){
        return this.operationsByCategory != undefined && this.operationsByCategory.length > 0;
    }

    get objectIsSelected(){
        return this.objectName ? true : false;
    }

    @wire(getObjectMetadata, { objectName: '$objectName', recordsNumber : 10})
    wiredMockRecords(result) {
        if (result.data) {
            this.operationsByCategory = result.data;
        } else if (result.error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: result.error.body.message,
                variant: 'error',
            }));
        }
        this.spinner = false;
    }

    handleRefresh(){
        //TODO call to apex method to refresh the metadata
    }

}