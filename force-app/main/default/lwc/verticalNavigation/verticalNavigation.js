import { LightningElement, wire } from 'lwc';
import TitleLabel from '@salesforce/label/c.SEARCH_OBJECTS_TITLE';
import PlaceholderLabel from '@salesforce/label/c.SEARCH_OBJECTS_PLACEHOLDER';
import AnyResult from '@salesforce/label/c.SEARCH_OBJECTS_ANY_RESULT';
import getObjectsList from '@salesforce/apex/MockController.getObjectsList';

export default class VerticalNavigation extends LightningElement {

    labels =  {TitleLabel, PlaceholderLabel, AnyResult}

    standardObjectsToShow;
    customObjectsToShow;
    isLoading = true;

    get isAnyStandardObject(){
        return this.standardObjectsToShow != undefined && this.standardObjectsToShow.length > 0;
    }

    get isAnyCustomdObject(){
        return this.customObjectsToShow != undefined && this.customObjectsToShow.length > 0;
    }

    @wire(getObjectsList, {})
    wiredMockRecords(result) {
        if (result.data) {
            this.standardObjects = result.data.filter(object => object.Type === 'Standard');
            this.customObjects = result.data.filter(object => object.Type === 'Custom');

            this.formatLabel();

            // Assign variables to list that is show
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

    connectedCallback(){
        this.isLoading = true;
    }

    formatLabel(){
        this.standardObjects = this.standardObjects.map((element) => ({
            ...element,
            Label: element.Name + ' (' + element.APIName + ')'
        }));
        this.customObjects = this.customObjects.map((element) => ({
            ...element,
            Label: element.Name + ' (' + element.APIName + ')'
        }));
    }

    searchField(event){
        let searchText = event.target.value;
        this.standardObjectsToShow = this.standardObjects.filter(object => object.Name.toLowerCase().includes(searchText.toLowerCase()));
        this.customObjectsToShow = this.customObjects.filter(object => object.Name.toLowerCase().includes(searchText.toLowerCase()));
    }

    handleSelect(event) {
        const selectedObjectLabel = event.detail.name.Name;
        const selectedObjectDevelopername = event.detail.name.APIName;
        
        const eventWithObject = new CustomEvent("object", {
            detail: {
                name: selectedObjectLabel,
                developername: selectedObjectDevelopername
            }
        })
        this.dispatchEvent(eventWithObject);
    }
}