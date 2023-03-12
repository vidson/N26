/*
 Purpose : This webservices returns Customer Informations on the products which customer has subscribed 
 Initial Version : 11-Mar-2023 | Initial Commit
 Test class : CustomerProductInfoWebServiceTest
*/
@RestResource(urlMapping='/contact/*')
global with sharing class CustomerProductInfoWebService {
    @HttpGet
    global static CustomerInformation getCustomerProductInfo() {
        String uuid = RestContext.request.params.get('uuid');
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        CustomerInformation customerInformation = new CustomerInformation();
        try {
        		if(String.isNotBlank(uuid)){
            		Contact contact = [SELECT Id, Home_Country__c,Product__c FROM Contact WHERE UUID__c = :uuid LIMIT 1];
					customerInformation.productFamily = contact.Product__c;
					customerInformation.homeCountry = contact.Home_Country__c;

					pricebookEntries = [Select Id, Name, Product2.Name, Subscription_Pricing__c, Subscription_Term__c, Subscription_Type__c, UnitPrice 
                            				FROM PricebookEntry
                            				WHERE Pricebook2.Name =: System.Label.Price_Book_N26 AND Product2.Family =: contact.Product__c AND Product2.Country__c =: contact.Home_Country__c];
					customerInformation.productPriceCharges = pricebookEntries;
            	}
            } catch (Exception e) {
            RestResponse response = new RestResponse();
            response.statusCode = 404;
            response.responseBody = Blob.valueOf('An error has occurred.'+e.getMessage());
            RestContext.response = response;
            System.debug('An error occurred while processing the request: ' + e.getMessage());
            return null;
        }
        return customerInformation;
    }
	global class CustomerInformation{
		global String productFamily { get;set; }
		global String homeCountry { get;set; }
		global List<PricebookEntry> productPriceCharges {set;get;}
   }
}