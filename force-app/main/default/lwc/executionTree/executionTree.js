import { LightningElement, api, wire, track } from 'lwc';
import getObjectMetadata from '@salesforce/apex/MockController.getObjectMetadata';
import { showErrorMessage } from 'c/idUtils';

//Custom Labels
import PLEASE_SELECT_OBJECT from '@salesforce/label/c.PLEASE_SELECT_OBJECT';

export default class ExecutionTree extends LightningElement {

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    //Custom labels
    label = {PLEASE_SELECT_OBJECT};

    //To control spinner visibility.
    _objectLabel;

    //Input variable for dynamic interaction or parent component.
    @api objectDeveloperName;

    //Input variable for dynamic interaction or parent component.
    @api
    get objectLabel() {
        return this._objectLabel;
    }
    set objectLabel(value) {
        console.log(JSON.stringify(value));
        this._objectLabel = value;
        if(value !== ''){
            this.spinner = true;
        }
    }

    //Variable to store the different operations by type of category as VRs, triggers, flow trigger..
    @track operationsByCategory;

    //Variable to control when the spinner have to show
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
        return this.operationsByCategory != undefined && this.operationsByCategory.length > 0;
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
    @wire(getObjectMetadata, { objectName: '$objectDeveloperName', recordsNumber : 10})
    wiredMockRecords(result) {
        if (result.data) {
            this.operationsByCategory = result.data;
        } else if (result.error) {
            showErrorMessage(result.error);
        }
        this.spinner = false;
    }

    handleRefresh(){
        //TODO call to apex method to refresh the metadata
    }

}