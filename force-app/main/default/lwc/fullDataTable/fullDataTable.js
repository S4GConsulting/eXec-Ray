import { LightningElement, api } from 'lwc';

export default class fullDataTable extends LightningElement {
    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/
    @api records;
    @api columns;
    @api tableLoadingState;
    @api keyField = 'Id';
    @api maxRowSelection = 20 ;
    @api hideCheckbox ;
    @api hideBottonSave;
    @api draftValues ;
    @api preselectedRows = [];
    @api errors;

    // Columns order variables 
    sortBy;
    sortDirection;

    // Scroll manage variables
    @api scroll = false;
    @api height;

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/

    /**
     * @description : change style depending on if is scrolleable or no dynamic table height.
     **/
    get tabClass() {
        return this.scroll ? 'slds-p-around_medium lgc-bg' : '';
    }

    /**
     * @description : dynamic table height.
     **/
    get tabStyle() {
        return `height:${this.height}px;`;
    }

    /**
     * @description : order according to event data depending on field name and selected address.
     **/
    handleSortdata(event) {
        // Field name
        this.sortBy = event.detail.fieldName;

        // Sort direction
        this.sortDirection = event.detail.sortDirection;

        // Calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);

    }

    /**
     * @description : order data function.
     * @param fieldName 
     * @param direction 
     **/
    sortData(fieldname, direction) {
        // Serialize the data before calling sort function
        const parseData = JSON.parse(JSON.stringify(this.records));

        // Return the value stored in the field
        const keyValue = (a) => {
            return a[fieldname];
        };

        // Cheking reverse direction 
        const isReverse = direction === 'asc' ? 1 : -1;

        // Sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // Handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // Sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // Set the sorted data to data table data
        this.records = parseData;
    }

    /**
     * @description : selected row event handler.
     * @param event 
     **/
    handleClick(event) {
        this.dispatchEvent(new CustomEvent('selectedrow', {
                                detail: { 
                                    selectedRows: event.detail.selectedRows 
                                }}
        ));
    }

    /**
     * @description : draft row event handler.
     * @param event 
     **/
    handleSave(event) {
        event.preventDefault();
        this.saveDraftValues = event.detail.draftValues;
        this.dispatchEvent(new CustomEvent('updaterows',{
                                detail : {
                                    draftValues : this.saveDraftValues
                                }}
        ));
    }

}