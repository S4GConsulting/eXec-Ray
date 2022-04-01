import { LightningElement } from 'lwc';

export default class RefreshExecution extends LightningElement {
    /**
     * @description : fire refresh event to other component and reset variables.
    **/
     handleRefresh(){
        const refreshEvent = new CustomEvent("refresh", {
            detail: {
                //Is neccesary send a dynamic value because if we send the same 
               //value always, does not fit in the target component setter (USING DYNAMIC INTERACTION)
                refreshDateTime: Date.now().toString()
            }
        })
        this.dispatchEvent(refreshEvent);   
    }
}