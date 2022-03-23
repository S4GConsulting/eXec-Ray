import { LightningElement } from 'lwc';
import TitleLabel from '@salesforce/label/c.SEARCH_OBJECTS_TITLE';
import PlaceholderLabel from '@salesforce/label/c.SEARCH_OBJECTS_PLACEHOLDER';
import AnyResult from '@salesforce/label/c.SEARCH_OBJECTS_ANY_RESULT';

export default class VerticalNavigation extends LightningElement {

    labels =  {TitleLabel, PlaceholderLabel, AnyResult}

    /**
     * ********************
     * MOCK RECORDS
     * ********************
     **/

    standardObjects = [{
        'Name' : 'Account',
        'APIName' : '',
        'Type' : 'Standard'
    },
    {
        'Name' : 'Contact',
        'APIName' : '',
        'Type' : 'Standard'
    },
    {
        'Name' : 'Lead',
        'APIName' : '',
        'Type' : 'Standard'
    },
    {
        'Name' : 'Opportunity',
        'APIName' : '',
        'Type' : 'Standard'
    },
    {
        'Name' : 'Task',
        'APIName' : '',
        'Type' : 'Standard'
    }];

    customObjects = [{
        'Name' : 'Amounts',
        'APIName' : '',
        'Type' : 'Custom'
    },{
        'Name' : 'Projects',
        'APIName' : '',
        'Type' : 'Custom'
    },
    {
        'Name' : 'Templates',
        'APIName' : '',
        'Type' : 'Custom'
    }];

    standardObjectsToShow;
    customObjectsToShow;
    selectedObjectDeveloperame;

    get isAnyStandardObject(){
        return this.standardObjectsToShow != undefined && this.standardObjectsToShow.length > 0;
    }

    get isAnyCustomdObject(){
        return this.customObjectsToShow != undefined && this.customObjectsToShow.length > 0;
    }

    connectedCallback(){
        // ToDo: Call controller to retrieve objects
        this.standardObjectsToShow = this.standardObjects;
        this.customObjectsToShow = this.customObjects;
    }

    searchField(event){
        let searchText = event.target.value;
        this.standardObjectsToShow = this.standardObjects.filter(object => object.Name.toLowerCase().includes(searchText.toLowerCase()));
        this.customObjectsToShow = this.customObjects.filter(object => object.Name.toLowerCase().includes(searchText.toLowerCase()));
    }

    handleSelect(event) {
        this.selectedObjectDeveloperame = event.detail.name;
        
        const objectToPass = new CustomEvent("objectDevelopername", {
            detail: {
                name: this.selectedObjectDeveloperame
            }
        })
        this.dispatchEvent(objectToPass);
    }
}