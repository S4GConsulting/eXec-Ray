import { LightningElement, wire } from 'lwc';
import TitleLabel from '@salesforce/label/c.SEARCH_OBJECTS_TITLE';
import PlaceholderLabel from '@salesforce/label/c.SEARCH_OBJECTS_PLACEHOLDER';
import AnyResult from '@salesforce/label/c.SEARCH_OBJECTS_ANY_RESULT';
import getObjectsList from '@salesforce/apex/MockController.getObjectsList';

export default class VerticalNavigation extends LightningElement {
    
    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    // Custom labels
    labels =  {TitleLabel, PlaceholderLabel, AnyResult}
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

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/

    /**
     * @description : control if Standard Objects list is empty.
    **/
    get isAnyStandardObject(){
        return this.standardObjectsToShow && this.standardObjectsToShow.length > 0;
    }

    /**
     * @description : control if Custom Objects list is empty.
    **/
    get isAnyCustomdObject(){
        return this.customObjectsToShow && this.customObjectsToShow.length > 0;
    }

    /**
     * @description : get and format organization Objects list
    **/
    @wire(getObjectsList, {})
    wiredMockRecords(result) {
        if (result.data) {
            this.standardObjects = result.data.filter(object => object.type === 'Standard');
            this.customObjects = result.data.filter(object => object.type === 'Custom');

            this.formatLabel();

            // Assign variables to the list that is show
            this.standardObjectsToShow = this.standardObjects
            this.customObjectsToShow = this.customObjects;
        } else if (result.error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: result.error.body.message,
                variant: 'error',
            }));
        }
        this.isLoading = false;
    }

    /**
     * @description : set as loading in component callback
    **/
    connectedCallback(){
        this.isLoading = true;
    }

    /**
     * @description : set objects label as: LABEL (DeveloperName)
    **/
    formatLabel(){
        this.standardObjects = this.standardObjects.map((element) => ({
            ...element,
            label: element.name + ' (' + element.apiName + ')'
        }));
        this.customObjects = this.customObjects.map((element) => ({
            ...element,
            label: element.name + ' (' + element.apiName + ')'
        }));
    }

    /**
     * @description : control objects lists when searching some text
    **/
    searchField(event){
        let searchText = event.target.value;
        this.standardObjectsToShow = this.standardObjects.filter(object => object.name.toLowerCase().includes(searchText.toLowerCase()));
        this.customObjectsToShow = this.customObjects.filter(object => object.name.toLowerCase().includes(searchText.toLowerCase()));
    }

    /**
     * @description : handle item selected. Launch custom event to Dynamic Interaction as defines in XML
    **/
    handleSelect(event) {
        const selectedObjectLabel = event.detail.name.name;
        const selectedObjectDevelopername = event.detail.name.apiName;
        
        const eventWithObject = new CustomEvent("object", {
            detail: {
                label: selectedObjectLabel,
                developerName: selectedObjectDevelopername
            }
        })
        this.dispatchEvent(eventWithObject);
    }
}