@isTest
private class SObjectDomainTest {
    @isTest
    static void test_bypass_user_Id() {
        insert new Trigger_Bypass__c(
                Name = 'test',
                Active__c = true,
                Force_Bypass__c = false,
                Profile_Ids__c = '',
                User_Ids__c = 'testcsv,' + UserInfo.getUserId(),
                SObject__c = 'Opportunity'
        );
//        Opportunities aDomain = new Opportunities(new List<Opportunity> {new Opportunity()});
//        System.assert(aDomain.isBypassed());
    }

    @isTest
    static void test_bypass_profile_Id() {
        insert new Trigger_Bypass__c(
                Name = 'test',
                Active__c = true,
                Force_Bypass__c = false,
                Profile_Ids__c = 'testCSV,' + UserInfo.getProfileId() + ',testCSV',
                SObject__c = 'Opportunity'
        );

//        Opportunities aDomain = new Opportunities(new List<Opportunity> {new Opportunity()});
//        System.assert(aDomain.isBypassed());
    }

    @isTest
    static void test_bypass_force() {
        insert new Trigger_Bypass__c(
                Name = 'test',
                Active__c = true,
                Force_Bypass__c = true,
                SObject__c = 'Opportunity'
        );

//        Opportunities aDomain = new Opportunities(new List<Opportunity> {new Opportunity()});
//        System.assert(aDomain.isBypassed());
    }

    @isTest
    static void test_bypass_inactive() {
        insert new Trigger_Bypass__c(
                Name = 'test',
                Active__c = false,
                Force_Bypass__c = true,
                SObject__c = 'Account'
        );

//        Opportunities aDomain = new Opportunities(new List<Opportunity> {new Opportunity()});
//        System.assert(!aDomain.isBypassed());
    }

    @isTest
    static void test_bypass_all() {
        insert new Trigger_Bypass__c(
                Name = 'test',
                Active__c = true,
                Force_Bypass__c = true,
                SObject__c = 'ALL'
        );

//        Opportunities aDomain = new Opportunities(new List<Opportunity> {new Opportunity()});
//        Contacts cDomain = new Contacts(new List<Contact> {new Contact()});
//        System.assert(aDomain.isBypassed());
//        System.assert(cDomain.isBypassed());
    }
}