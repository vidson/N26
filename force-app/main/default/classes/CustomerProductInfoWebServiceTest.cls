@isTest
public class CustomerProductInfoWebServiceTest {
	@testSetup
	static void testData() {
    	Contact testContact = new Contact(
        	FirstName = 'Test',
        	LastName = 'Contact',
        	Home_Country__c = 'DE',
        	Product__c = 'Black',
        	UUID__c = '1234'
    	);
    	insert testContact;
        
        Product2 testProduct1 = new Product2(
        	Name = 'Black Membership ATM Fee - Germany',
            IsActive = true,
        	Country__c = 'DE',
        	Family = 'Black'
    	);
    	insert testProduct1;
        
		Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = testProduct1.Id,
        UnitPrice = 10000, IsActive = true);
        insert standardPrice;
    	Pricebook2 testPricebook = new Pricebook2(Name = System.Label.Price_Book_N26, IsActive = true);
    	insert testPricebook;
         PricebookEntry testPricebookEntry3 = new PricebookEntry(
         Pricebook2Id = testPricebook.Id,
         Product2Id = testProduct1.Id,
         Subscription_Pricing__c = 'Percent of Total',
         UnitPrice = 1.7
    	);
    	insert testPricebookEntry3;
	}

	@isTest
	static void testGetCustomerProductInfo() {
    	Test.startTest();
    
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	req.requestUri = '/services/apexrest/contact';
		req.addParameter('uuid', '1234');
    	req.httpMethod = 'GET';
    	RestContext.request = req;
    	RestContext.response = res;    
    	CustomerProductInfoWebService.CustomerInformation result = new CustomerProductInfoWebService.CustomerInformation();
        result = CustomerProductInfoWebService.getCustomerProductInfo(); 
		Test.stopTest();
    	System.assertEquals('Black', result.productFamily);
    	System.assertEquals('DE', result.homeCountry);
        System.assertEquals(1, result.productPriceCharges.size());
    	
	}
    @isTest
	static void testNonExistingClient() {
    	Test.startTest();
    	RestRequest req = new RestRequest();
    	RestResponse res = new RestResponse();
    	req.requestUri = '/services/apexrest/contact';
		req.addParameter('uuid', '12345');
    	req.httpMethod = 'GET';
    	RestContext.request = req;
    	RestContext.response = res;    
    	CustomerProductInfoWebService.CustomerInformation result = new CustomerProductInfoWebService.CustomerInformation();
        result = CustomerProductInfoWebService.getCustomerProductInfo(); 
		Test.stopTest();        
        System.assertEquals(null, result);
        System.assertEquals(404, RestContext.response.statusCode);
	}
}