import { api, LightningElement, track, wire } from 'lwc';
import fetchCustomerProductInfo from '@salesforce/apex/CustomerProductInformation.fetchCustomerProductInfo';

export default class CustomerProductInfo extends LightningElement {
    
    @api recordId;
    customerProductInfo;
    
    connectedCallback() {
        this.getCustomerProductInfo();
    }

    getCustomerProductInfo() {
        fetchCustomerProductInfo({ caseId: this.recordId })
        .then((result) => {
            this.customerProductInfo = result;
            console.log(this.customerProductInfo);
            console.log(JSON.stringify(this.customerProductInfo));
        })
        .catch((error) => {
            console.error(error);
        });
    }
    get isMonthlyFeeAvailable() {
        return isNaN(this.customerProductInfo.monthlyFee);
    }
    get isAtmFeeApplicable() {
        return isNaN(this.customerProductInfo.atmFee);
    }
}