import { LightningElement, api } from 'lwc';

//Custom Labels

import OPEN_DETAILS_MESSAGE from '@salesforce/label/c.OPEN_DETAILS_MESSAGE';
import OPERATION_CATEGORY_TITLE from '@salesforce/label/c.OPERATION_CATEGORY_TITLE';
import ITEMS_MESSAGE from '@salesforce/label/c.ITEMS_MESSAGE';
import NO_ITEMS_MESSAGE from '@salesforce/label/c.NO_ITEMS_MESSAGE';

/**
 * *************************
 * CATEGORY ICONS DEFINITION (TBD)
 * *************************
 **/
const RECORD_BEFORE_TRIGGER_FLOW_ICON = "standard:product_request_line_item";
const BEFORE_TRIGGERS_ICON = "standard:coaching";
const VALIDATION_RULES_ICON = "standard:incident";
const DUPLICATE_RULES_ICON = "standard:topic";
const AFTER_TRIGGERS_ICON = "standard:product_request";
const ASSIGNMENT_RULES_ICON = "standard:data_streams";
const AUTORESPONSE_RULES_ICON = "standard:client";
const WORKFLOW_RULES_ICON = "standard:work_plan_rule";
const PROCESSES_BUILDER_ICON = "standard:service_crew_member";
const ESCALATION_RULES_ICON = "standard:high_velocity_sales";
const RECORD_AFTER_TRIGGER_FLOW_ICON = "standard:connected_apps";
const ENTITLEMENT_RULES_ICON = "standard:macros";
const SUMMARY_FIELD_ICON = "standard:orders";
const SHARING_RULES_ICON = "standard:service_request_detail";

/******************X******************/

/**
 * *************************
 * CATEGORY NAMES DEFINITION (TBD)
 * *************************
 **/
const RECORD_BEFORE_TRIGGER_FLOW_NAME = "Record Before Trigger Flows";
const BEFORE_TRIGGERS_NAME = "Before Triggers";
const VALIDATION_RULES_NAME = "Validation Rules";
const DUPLICATE_RULES_NAME = "Duplicate Rules";
const AFTER_TRIGGERS_NAME = "After Triggers";
const ASSIGNMENT_RULES_NAME = "Assignment Rules";
const AUTORESPONSE_RULES_NAME = "Autoresponse Rules";
const WORKFLOW_RULES_NAME = "Workflow Rules";
const PROCESSES_BUILDER_NAME = "Process Builders";
const ESCALATION_RULES_NAME = "Escalation Rules";
const RECORD_AFTER_TRIGGER_FLOW_NAME = "Record After Trigger Flows";
const ENTITLEMENT_RULES_NAME = "Entitlement Rules";
const SUMMARY_FIELD_NAME = "Summary Fields";
const SHARING_RULES_NAME = "Sharing Rules";

/******************X******************/

/**
 * *************************
 * MAP ICON WITH CATEGORY NAME (TBD)
 * *************************
 **/
const ICON_BY_CATEGORY_NAME = {
    [RECORD_BEFORE_TRIGGER_FLOW_NAME] : RECORD_BEFORE_TRIGGER_FLOW_ICON,
    [BEFORE_TRIGGERS_NAME] : BEFORE_TRIGGERS_ICON,
    [VALIDATION_RULES_NAME] : VALIDATION_RULES_ICON,
    [DUPLICATE_RULES_NAME] : DUPLICATE_RULES_ICON,
    [AFTER_TRIGGERS_NAME]: AFTER_TRIGGERS_ICON,
    [ASSIGNMENT_RULES_NAME]: ASSIGNMENT_RULES_ICON ,
    [AUTORESPONSE_RULES_NAME] : AUTORESPONSE_RULES_ICON,
    [WORKFLOW_RULES_NAME] : WORKFLOW_RULES_ICON,
    [PROCESSES_BUILDER_NAME] : PROCESSES_BUILDER_ICON ,
    [ESCALATION_RULES_NAME] : ESCALATION_RULES_ICON,                 
    [RECORD_AFTER_TRIGGER_FLOW_NAME]: RECORD_AFTER_TRIGGER_FLOW_ICON,
    [ENTITLEMENT_RULES_NAME] : ENTITLEMENT_RULES_ICON,
    [SUMMARY_FIELD_NAME] : SUMMARY_FIELD_ICON,
    [SHARING_RULES_NAME] : SHARING_RULES_ICON
}

/******************X******************/

export default class TimeLineItem extends LightningElement {

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    //Operation data with all information category data.
    @api operation;

    //Custom labels
    label = {OPEN_DETAILS_MESSAGE, OPERATION_CATEGORY_TITLE, ITEMS_MESSAGE, NO_ITEMS_MESSAGE};

    //Control the visibility of the detail operations by category area operations.
    showDetails = false;

    //Child table variables.
    hideCheckbox = true;
    scrollable = true;
    height;

    //Columns for table. (TBD)
    tableColumns = [
        {
            label: 'Label',
            fieldName: 'url',
            type: 'url',
            sortable: true,
            typeAttributes: {
                label: {
                  fieldName: "label"
                },            
                tooltip: "URL Link"
            },
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
        }
    ];

    /**
     * @description : control if an item is expandable or not.
    **/
    get itemStyle() {
        return this.showDetails ? "slds-timeline__item_expandable slds-is-open" : "slds-timeline__item_expandable";
    }

    /**
     * @description : control itemButton style for hidden or not.
    **/
    get itemButtonStyle() {
        return this.showDetailsTable ? "slds-button slds-button_icon" : "slds-button slds-button_icon slds-hidden";
    }

    /**
     * @description : control category icon style for change it if there are not category operations.
    **/
    get iconStyle() {
        return this.showDetailsTable ? "slds-icon slds-icon_small" : "slds-icon slds-icon_small disabledIcon";
    }

    /**
     * @description : control category font style for change it if there are not category operations.
    **/
    get countItemsStyle() {
        return this.showDetailsTable ? "slds-var-m-horizontal_xx-small" : "slds-var-m-horizontal_xx-small italic";
    }

    /**
     * @description : control category font style for change it if there are not category operations.
    **/
    get titleStyle() {
        return this.showDetailsTable ? "" : "italic";
    }

    /**
     * @description : control table visibility.
    **/
    get showDetailsTable() {
        return this.operation && this.operation.operations.length === 0
                ? false
                    : true;
    }

    /**
     * @description : count operation category records.
    **/
    get operationCounter() {
        return this.operation !== undefined && this.operation.operations.length > 0
                ? this.operation.operations.length
                    : 0;
    }
    
    /**
     * @description : get icon by category name.
    **/
    get categoryIcon() {
        return ICON_BY_CATEGORY_NAME[this.operation.category] !== undefined 
                ? ICON_BY_CATEGORY_NAME[this.operation.category] 
                    : "standard:generic_loading"; 
    }

    handleOpenDetails(){
       
        if(this.showDetails){ 
            this.showDetails = false
        }else{
            this.showDetails = true
        };
    }
}