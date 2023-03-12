@isTest
public class CustomerProductInformationTest {
    @testSetup static void setup() {
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Home_Country__c = 'DE',
            Product__c = 'Black',
            UUID__c = '1234'
        );
        insert testContact;
        List<Product2> allProducts = new List<Product2>();
        Product2 testProduct1 = new Product2(
            Name = 'Black Membership Base Fee - Germany',
            IsActive = true,
            Country__c = 'DE',
            Family = 'Black',
            productCode = 'BLACKBASEDE'
        );
        allProducts.add(testProduct1);
        Product2 testProduct2 = new Product2(
            Name = 'Black Membership ATM Fee - Germany',
            IsActive = true,
            Country__c = 'DE',
            Family = 'Black',
            productCode = 'BLACKATMFEEDE'
        );
        allProducts.add(testProduct2);
        Product2 testProduct3 = new Product2(
            Name = 'Black Membership Replace Fee - Germany',
            IsActive = true,
            Country__c = 'DE',
            Family = 'Black',
            productCode = 'BLACKREPLACEFEEDE'
        );
        allProducts.add(testProduct3);
        insert allProducts;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = allProducts[0].Id,
            UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = allProducts[1].Id,
            UnitPrice = 10000, IsActive = true);
        PricebookEntry standardPrice3 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = allProducts[2].Id,
            UnitPrice = 10000, IsActive = true);
		List<PricebookEntry> allStdEntries = new List<PricebookEntry>();
        allStdEntries.add(standardPrice1);
        allStdEntries.add(standardPrice2);
        allStdEntries.add(standardPrice3);
        insert allStdEntries;
        
        Pricebook2 testPricebook = new Pricebook2(Name = System.Label.Price_Book_N26, IsActive = true);
        insert testPricebook;
        PricebookEntry testPricebookEntry3 = new PricebookEntry(
            Pricebook2Id = testPricebook.Id,
            Product2Id = allProducts[0].Id,
            Subscription_Pricing__c = 'Percent of Total',
            UnitPrice = 1.7,
            isActive=true
        );
        PricebookEntry testPricebookEntry4 = new PricebookEntry(
            Pricebook2Id = testPricebook.Id,
            Product2Id = allProducts[1].Id,
            Subscription_Pricing__c = 'Percent of Total',
            UnitPrice = 1.7,
            isActive=true
        );
        PricebookEntry testPricebookEntry5 = new PricebookEntry(
            Pricebook2Id = testPricebook.Id,
            Product2Id = allProducts[2].Id,
            Subscription_Pricing__c = 'Percent of Total',
            UnitPrice = 1.7,
            isActive=true
        );
        List<PricebookEntry> allEntries = new List<PricebookEntry>();
        allEntries.add(testPricebookEntry5);
        allEntries.add(testPricebookEntry4);
        allEntries.add(testPricebookEntry3);
        insert allEntries;
        
        case cas = new Case();
        cas.ContactId = testContact.Id;
        insert cas;
        
    }
    
    @isTest
    static void testFetchCustomerProductInfo() {
        // Test valid case
        Case c = [SELECT Id, Contact.Product__c, Contact.Home_Country__c FROM Case LIMIT 1];
        CustomerProductInformation.CustomerProduct result = CustomerProductInformation.fetchCustomerProductInfo(c.Id);
        //          
        // Test case where product is not found
        //c.Contact.Product__c = 'Standard';
        //update c.Contact;
        //  result = CustomerProductInformation.fetchCustomerProductInfo(c.Id);
        
        // Test case where no pricebook entry is found
        
    }
    
    @isTest
    static void testFetchCustomerProductInfoError() {
        
    }
}