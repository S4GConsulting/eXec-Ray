import { LightningElement, api } from 'lwc';

const SUCCESS_TITLE = 'Success';

export default class ExecutionTree extends LightningElement {

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    //Input variable for dynamic interaction or parent component.
    @api objectName;

    //Variable to store the different operations by type of category as VRs, triggers, flow trigger..
    operationsByCategory;

    //-----Child table variables-----//

    hideCheckbox = true;
    scrollable = true;
    height = 120;

    //-----*-----//

    tableColumns = [
        {
            label: 'Label',
            fieldName: 'label',
            type: 'text',
            sortable: true,
            iconName: 'utility:display_text'
        },
        {
            label: 'API Name',
            fieldName: 'apiName',
            type: 'text',
            sortable: true,
            iconName: 'utility:variable'
        },
        {
            label: 'Namespace',
            fieldName: 'namespace',
            type: 'text',
            sortable: true,
            iconName: 'utility:wellness' 
        },
        {
            label: 'URL',
            fieldName: 'url',
            type: 'url', 
            typeAttributes: {label: 'LINK TO'},
            iconName: 'utility:zoomin'
                
        }
    ];


    /**
     * ********************
     * MOCK RECORDS
     * ********************
     **/

    mockRecords = [
        {
            category: 'Validation Rules',
            operations : 
            [
                {label : 'TEST VR 1', url: 'Energy', namespace:'Worker', apiName: 'test2'},
                {label : 'TEST VR 2', url: 'Fintech', namespace:'Qualtrics', apiName: 'test3'},
                {label : 'TEST VR 3', url: 'Fintech', namespace:'Npsp', apiName: 'test5'}
            ]
        },
        {
            category: 'Before Triggers',
            operations : 
            [
                {label : 'TEST BT 1', url: 'Energy', namespace:'Worker', apiName: 'test2'},
                {label : 'TEST BT 2', url: 'Fintech', namespace:'Qualtrics', apiName: 'test3'},
                {label : 'TEST BT 3', url: 'Fintech', namespace:'Npsp', apiName: 'test5'}
            ]
        },
        {
            category: 'Duplicate Rules',
            operations : 
            [
                {label : 'TEST DR 1', url: 'Energy', namespace:'Worker', apiName: 'test2'},
                {label : 'TEST DR 2', url: 'Fintech', namespace:'Qualtrics', apiName: 'test3'},
                {label : 'TEST DR 3', url: 'Fintech', namespace:'Npsp', apiName: 'test5'}
            ]
        },
        {
            category: 'After Triggers',
            operations : 
            [
                {label : 'TEST AT 1', url: 'Energy', namespace:'Worker', apiName: 'test2'},
                {label : 'TEST AT 2', url: 'Fintech', namespace:'Qualtrics', apiName: 'test3'},
                {label : 'TEST AT 3', url: 'Fintech', namespace:'Npsp', apiName: 'test5'},
                {label : 'TEST AT 4', url: 'Fintech', namespace:'Npsp', apiName: 'test5'},
                {label : 'TEST AT 5', url: 'Fintech', namespace:'Npsp', apiName: 'test5'},
                {label : 'TEST AT 6', url: 'Fintech', namespace:'Npsp', apiName: 'test5'}
            ]
        }
    ]; 

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/

    connectedCallback(){
        this.operationsByCategory = this.mockRecords;
    }


}