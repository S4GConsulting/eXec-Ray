import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import NoHeader from '@salesforce/resourceUrl/NoHeader';
import logo from '@salesforce/resourceUrl/eXecRayLogo';

export default class RefreshExecution extends LightningElement {

    execRayLogo = logo;

    /**
     * ********************
     * VARIABLES DEFINITION
     * ********************
     **/

    // Last button click time
    lastRefresh = Date.now();

    /**
     * ********************
     * LOGIC IMPLEMENTATION
     * ********************
     **/    

    /**
     * @description : get and format last refresh date
    **/
    get parsedDate() {
        const datetime = new Date(this.lastRefresh);
        var mm = datetime.getMonth() + 1; // getMonth() is zero-based
        var dd = datetime.getDate();

        return [datetime.getFullYear(),
                (mm>9 ? '' : '0') + mm,
                (dd>9 ? '' : '0') + dd
                ].join('-') + ' ' + 
                datetime.getHours().toString().padStart(2,0) + ':' + 
                datetime.getMinutes().toString().padStart(2,0) + ':' + 
                datetime.getSeconds().toString().padStart(2,0);
    }

    /**
     * @description : removes header on init.
    **/
    connectedCallback() {
        loadStyle(this, NoHeader);
    }

    /**
     * @description : fire refresh event to other component and reset variables.
    **/
    handleRefresh(){
        this.lastRefresh = Date.now();
        const refreshEvent = new CustomEvent("refresh", {
            detail: {
                //Is neccesary send a dynamic value because if we send the same 
               //value always, does not fit in the target component setter (USING DYNAMIC INTERACTION)
                refreshDateTime: this.lastRefresh.toString()
            }
        })
        this.dispatchEvent(refreshEvent);   
    }
}