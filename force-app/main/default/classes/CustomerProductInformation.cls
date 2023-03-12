public with sharing class CustomerProductInformation {
    /*
    Purpose : Method gets product information of the client via contact associcated with case
    Initial Version : 11-Mar-2023 | Initial Commit
    */
    @AuraEnabled
    public static CustomerProduct fetchCustomerProductInfo(Id caseId) {
        CustomerProduct customerProductInfo = new CustomerProduct();
        try{
            Case cas = [select Id,contact.Product__c, contact.Home_Country__c from case where Id=:caseId limit 1];
            customerProductInfo.productName = cas.contact.Product__c;
            customerProductInfo.homeCountry = cas.contact.Home_Country__c;
            List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
            pricebookEntries = [Select Id, Name, Product2.Name,  UnitPrice ,Product2.productCode,CurrencyIsoCode 
                                                FROM PricebookEntry
                                                WHERE Pricebook2.Name =: System.Label.Price_Book_N26 
                                                AND Product2.Family =: cas.contact.Product__c 
                                                AND Product2.Country__c =: cas.contact.Home_Country__c
                                                AND IsActive = true];
            customerProductInfo.otherProducts = new List<PricebookEntry>();
            customerProductInfo.monthlyFee= 'N/A';
            for(PricebookEntry entries: pricebookEntries){
                if(entries.Product2.productCode.contains('BASE')){
                    customerProductInfo.monthlyFee = String.valueOf(entries.UnitPrice);
                }
                else if(entries.Product2.productCode.contains('ATMFEE')){
                    customerProductInfo.atmFee = (entries.UnitPrice == 0  ? 'Free' : String.valueOf(entries.UnitPrice));
                }
                else if(entries.Product2.productCode.contains('REPLACEFEE')){
                    customerProductInfo.cardReplaceFee = String.valueOf(entries.UnitPrice);
                }
                else{
                    customerProductInfo.otherProducts.add(entries);
                }
                customerProductInfo.otherProducts.add(entries);
                customerProductInfo.currencyIsoCode = entries.CurrencyIsoCode;
        }
        }catch(Exception ex){
            System.debug('An error occurred while processing the request: ' + ex.getMessage());
        }
        return  customerProductInfo;
                
    }
    public class CustomerProduct {
        @AuraEnabled
        public String productName;
        @AuraEnabled
        public String homeCountry;
        @AuraEnabled
        public String monthlyFee;
        @AuraEnabled
        public String atmFee;
        @AuraEnabled
        public String cardReplaceFee;
        @AuraEnabled
        public String currencyIsoCode;
        @AuraEnabled
        public  List<PricebookEntry> otherProducts;
    }
}