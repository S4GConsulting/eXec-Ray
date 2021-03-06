import { LightningElement, wire, api } from 'lwc';
import { showErrorMessage } from 'c/idUtils';
import TitleLabel from '@salesforce/label/c.SEARCH_OBJECTS_TITLE';
import PlaceholderLabel from '@salesforce/label/c.SEARCH_OBJECTS_PLACEHOLDER';
import AnyResult from '@salesforce/label/c.SEARCH_OBJECTS_ANY_RESULT';
import Loading from '@salesforce/label/c.LOADING';
import SearchAnObject from '@salesforce/label/c.SEARCH_AN_OBJECT';
import init from '@salesforce/apex/ExecutionTreeController.init';
import { refreshApex } from '@salesforce/apex';

export default class VerticalNavigation extends LightningElement {
    
    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    // Custom labels
    labels =  {TitleLabel, PlaceholderLabel, AnyResult, Loading, SearchAnObject}
    // List of Standard Objects available
    standardObjects;
    // List of Custom Objects available
    customObjects;
    // List of Standard Objects to show in the navigation
    standardObjectsToShow;
    // List of Custom Objects to show in the navigation
    customObjectsToShow;
    // Control spinner visibility
    isLoading = true;
    // Selected navigarion item
    selected = undefined;
    // Record from wire method
    _wiredRecord;
    // Private parameter to save refresh datetime
    _refreshDatetime;
    // Save datetime last refresh. When this is updated the component is reloaded
    @api
    get refreshDatetime(){
        return this._refreshDatetime;
    }

    set refreshDatetime(value){
        if(value){ // Is neccesary for the first rendered time
            this.refresh();
        }
        this._refreshDatetime = value; 
    }

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/    

    /**
     * @description : get and format organization Objects list
    **/
     @wire(init)
     wiredMockRecords(result) {
         const { data, error } = result;
         this._wiredRecords = result;
         if (data) {
             this.standardObjects = data.filter(object => object.type === 'Standard');
             this.customObjects = data.filter(object => object.type === 'Custom');
 
             this.formatLabel();
 
             // Assign variables to the list that is show
             this.standardObjectsToShow = this.standardObjects
             this.customObjectsToShow = this.customObjects;
             this.isLoading = false;
         } else if (error) {
            this.dispatchEvent(showErrorMessage(error));
            this.isLoading = false;
         }
     }

    /**
     * @description : control if Standard Objects list is empty.
    **/
    get isAnyStandardObject(){
        return this.standardObjectsToShow?.length > 0;
    }

    /**
     * @description : control if Custom Objects list is empty.
    **/
    get isAnyCustomdObject(){
        return this.customObjectsToShow?.length > 0;
    }

    /**
     * @description : set objects label as: LABEL (DeveloperName)
    **/
     formatLabel(){
        this.standardObjects = this.formatLabelPerObject(this.standardObjects);
        this.customObjects = this.formatLabelPerObject(this.customObjects);
    }

    /**
     * @description : set objects label as: LABEL (DeveloperName) per object
    **/
    formatLabelPerObject(object){
        return object.map((element) => ({
            ...element,
            formattedlabel: element.label + ' (' + element.apiName + ')'
        }));
    }

    /**
     * @description : control objects lists when searching some text
    **/
    searchField(event){
        let searchText = event.target.value;
        this.standardObjectsToShow = this.filterObjectsByText(this.standardObjects, searchText);
        this.customObjectsToShow = this.filterObjectsByText(this.customObjects, searchText);
    }

    /**
     * @description : filter objects that cointains text in the label
    **/
    filterObjectsByText(objects, searchText){
        return objects.filter(currentObject => currentObject.label.toLowerCase().includes(searchText.toLowerCase()));
    }

    /**
     * @description : refresh list of objects
    **/
    refresh(){
        this.isLoading = true;
        this.selected = undefined;
        refreshApex(this._wiredRecords).then(() => {
            this.isLoading = false;
        }, (error) => {
            this.dispatchEvent(showErrorMessage(error));
            this.spinner = false;
        });          
        this.standardObjectsToShow = this.standardObjects
        this.customObjectsToShow = this.customObjects; 
    }

    /**
     * @description : handle item selected. Launch custom event to Dynamic Interaction as defines in XML
    **/
    handleSelect(event) {
        const selectedObjectLabel = event.detail.name.label;
        const selectedObjectDevelopername = event.detail.name.apiName;
        
        this.selected = event.detail.label;

        if(selectedObjectLabel && selectedObjectLabel !== ''){
            const eventWithObject = new CustomEvent("object", {
                detail: {
                    label: selectedObjectLabel,
                    developerName: selectedObjectDevelopername
                }
            })
            this.dispatchEvent(eventWithObject);
        }
    }
}