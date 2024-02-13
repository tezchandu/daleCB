/**
* Test Class for the ApplyProcessSharingRulesController logic
* 
* @Date:    01.07.2016
* @Author:  Usman Ali (Magnet 360)
* 
* @Updates: 01.18.2016 Usman Ali (Magnet360)
*           Added code coverage for batch jobs status 
* 
*/
@isTest
private class ApplyProcessSharingRulesContTest 
{
    public static testMethod void applyRules()
    {
        TestUtil testUtil = new TestUtil();

        // Create user
        User user = testUtil.getUsers(1, null)[0];
        user.DefaultCurrencyIsoCode = 'GBP';
        user.Franchise_ID__c = '1234';
        insert user ;
        
        // Create account
        Account account = testUtil.getAccounts(1, null, user.Id )[0];
        insert account;

        // Create Franchise team record 
        Franchise_Team__c ft = new Franchise_Team__c( Name = '1234', Franchise_Account__c = account.Id, Process_sharing__c = true );
        insert ft; 

        // Create FTM record under FT
        Franchise_Team_Member__c ftm = new Franchise_Team_Member__c(    Franchise_ID__c = ft.Id , User__c = user.Id,  
                                                                        Access__c = FranchiseSharingUtil.STR_SALES );
        insert ftm ; 
        
        // Create FOA record under FT 
        Franchise_Object_Access__c foa = new Franchise_Object_Access__c( Franchise_ID__c = ft.Id , Admin_Access__c = 'Read/Write',
                                         Manager_Access__c ='Read/Write', Sales_Access__c = 'Read/Write' ,
                                         Object_Name__c = FranchiseSharingUtil.STR_ACCOUNT );
        insert foa ;

        Test.setCurrentPage(Page.ApplyProcessSharingRules);
        ApplyProcessSharingRulesController controller = new ApplyProcessSharingRulesController( new ApexPages.StandardController( ft )) ;
        controller.apply() ; 
        controller.checkStatus();
        
    }    
}