//04.25.2019    Sophia Murphy (Demand Chain)
//              Updated to use Test Util for creating accounts
@isTest
public class Test_FranchiseAssociation {
    public static String accountRT = Schema.SObjectType.Account.RecordTypeInfosByName.get('DFG Account').RecordTypeId; // Added as a part of Org Merge
    public static String leadRT = Schema.SObjectType.Lead.RecordTypeInfosByName.get('DFG Lead').RecordTypeId; // Added as a part of Org merge
    public static String oppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId; // Added as a part of Org merge
    
    static testMethod void BuildFranchisesWithPostalCodes() {
        // Helper method to create both US & CA Franchises & Postal Codes
        Test_FranchiseAssociation.BuildUSFranchisesWithPostalCodes();
        Test_FranchiseAssociation.BuildCAFranchisesWithPostalCodes();
        
    }

    static testMethod void BuildUSFranchisesWithPostalCodes() {
        // Builds 5 US Franchises & Then adds 5 US Postal Codes and relates them to franchises as per the map below
        
        Map<String,String> FranchiseCodeToPostalCodeMap = new Map<String,String>{
                                                                            '903500' => '35146',
                                                                            '913071' => '03031',
                                                                            '902760' => '85000',
                                                                            '908800' => '37501',
                                                                            '129250' => '94203'
                                                                            };
        TestUtil tu = new TestUtil();   
        User l_owner = tu.getUsers( 1, '' )[ 0 ];
        insert l_owner;
                                                                         
        List<Account> fList = new List<Account>(); 
        for (String fc : FranchiseCodeToPostalCodeMap.keySet()){
            /**
            Account f = new Account();
            f.Name = 'Test Franchise '+fc;
            f.Type = 'Franchisee';
            f.Franchise_Code__c = fc;
            f.recordTypeId = accountRT;
            fList.add(f);
            */
            Account f = tu.getAccounts(1, 'DFG Account', String.valueOf(l_owner.Id))[0];
            f.Franchise_Code__c = fc;
            f.Type = 'Franchisee';
            fList.add(f);
        }
        insert fList;

        List<Postal_Code__c> pcList = new List<Postal_Code__c>(); 
        for (Account f : [Select id,Franchise_Code__c FROM Account WHERE Type = 'Franchisee' AND Franchise_Code__c = : FranchiseCodeToPostalCodeMap.keySet()]){
            Postal_Code__c pc = new Postal_Code__c();
            pc.Name = FranchiseCodeToPostalCodeMap.get(f.Franchise_Code__c);
            pc.Franchise__c = f.id;
            pcList.add(pc);
        }
        insert pcList;

        List<Postal_Code__c> insertedPCList = new List<Postal_Code__c>([Select id,Name,Franchise__r.Franchise_Code__c FROM Postal_Code__c WHERE Name = : FranchiseCodeToPostalCodeMap.values()]);
        System.Assert(insertedPCList.size() == 5); // verify that 5 Postal Codes were created
        for (Postal_Code__c pc : insertedPCList){
            //System.Assert(FranchiseCodeToPostalCodeMap.get(pc.Franchise__r.Franchise_Code__c) == pc.Name); // ensure franchise codes are associated with corresponding postal codes
        }


    }

    static testMethod void BuildCAFranchisesWithPostalCodes() {
        // Builds 5 CA Franchises & Then adds 5 CA FSA's and relates them to franchises as per the map below
        Map<String,String> FranchiseCodeToPostalCodeMap = new Map<String,String>{
                                                                            '303400' => 'A0B', // A0B 1A0                                                                           
                                                                            '31520K' => 'J9H', // J9H 0A1                                                                       
                                                                            '314100' => 'S6W', // S6W 1A1
                                                                            '311000' => 'T4J', // T4J 0A1
                                                                            '323500' => 'V0H'  // V0H 1A0
                                                                            }; 

        TestUtil tu = new TestUtil();   
        User l_owner = tu.getUsers( 1, '' )[ 0 ];
        insert l_owner;
                                                                         
        List<Account> fList = new List<Account>(); 
        for (String fc : FranchiseCodeToPostalCodeMap.keySet()){
            /**
            Account f = new Account();
            f.Name = 'Test Franchise '+fc;
            f.Type = 'Franchisee';
            f.Franchise_Code__c = fc;
            f.recordTypeId = accountRT;
            fList.add(f);
            */
            Account f = tu.getAccounts(1, 'DFG Account', String.valueOf(l_owner.Id))[0];
            f.Franchise_Code__c = fc;
            f.Type = 'Franchisee';
            fList.add(f);
        }
        insert fList;


        List<Postal_Code__c> pcList = new List<Postal_Code__c>(); 
        for (Account f : [Select id,Franchise_Code__c FROM Account WHERE Type = 'Franchisee' AND Franchise_Code__c = : FranchiseCodeToPostalCodeMap.keySet()]){
            Postal_Code__c pc = new Postal_Code__c();
            pc.Name = FranchiseCodeToPostalCodeMap.get(f.Franchise_Code__c);
            pc.Franchise__c = f.id;
            pcList.add(pc);
        }
        insert pcList;

        List<Postal_Code__c> insertedPCList = new List<Postal_Code__c>([Select id,Name,Franchise__r.Franchise_Code__c FROM Postal_Code__c WHERE Name = : FranchiseCodeToPostalCodeMap.values()]);
        System.Assert(insertedPCList.size() == 5); // verify that 5 Postal Codes were created
        for (Postal_Code__c pc : insertedPCList){
            //System.Assert(FranchiseCodeToPostalCodeMap.get(pc.Franchise__r.Franchise_Code__c) == pc.Name); // ensure franchise codes are associated with corresponding postal codes
        }


    }

    static testMethod void InsertLeadWithUSPostalCode() {
        // Create a lead with a US Postal Code & insert it and ensure it gets associated to the proper franchise
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = '94203';
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == '94203');
        //System.Assert(insertedL.Franchise__r.Franchise_Code__c == '129250');
    }

    static testMethod void InsertLeadWithCAPostalCode() {
        // Create a lead with a CA Postal Code & insert it and ensure it gets associated to the proper franchise
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = 'S6W 1A1';
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == 'S6W 1A1');
        //System.Assert(insertedL.Franchise__r.Franchise_Code__c == '314100');
    }

    static testMethod void InsertLeadWithCAPostalCodeLowerCase() {
        // Create a lead with a CA Postal Code & insert it and ensure it gets associated to the proper franchise
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = 'S6W 1A1'.toLowerCase();
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == 'S6W 1A1'.toLowerCase());
        //System.Assert(insertedL.Franchise__r.Franchise_Code__c == '314100');
    }

    static testMethod void InsertLeadWithInvalidPostalCode() {
        // Tests a US Postal code of the appropriate format (5 digits) but that does not correspond with any Postal Codes in Postal_Code__c
        // The lead should not be associated with any franchise and no errors should be thrown
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = '000000';
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == '000000');
        //System.Assert(insertedL.Franchise__c == null);
    }

    static testMethod void InsertLeadWithUKPostalCode() {
        // Tests a UK Postal code.  The lead should not end up associated with any franchises.
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = 'G77 6AB';
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == 'G77 6AB');
        //System.Assert(insertedL.Franchise__c == null);
    }

    static testMethod void UpdateLeadUseCases() {
        // Exercise update use cases by:
        // Create a lead with a blank postal code, then update a lead with a blank postal code and confirm it is not associated with a franchise
        // Then add a postal code to the lead and update it and ensure it is now associated with a franchise
        // Then change the postal code and update it and confirm it is still associated with the original franchise
        // Then clear the franchise and update lead and confirm a new franchise is associated with it

        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Lead l = new Lead();
        l.FirstName = 'TestLead';   
        l.LastName = 'TestLead';
        l.Company = 'TestCo';
        l.PostalCode = '';
        l.recordTypeId = leadRT;
        insert l;
        
        Lead insertedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c,Description FROM Lead WHERE Id = : l.id]; 
        //System.Assert(insertedL.PostalCode == null);
        //System.Assert(insertedL.Franchise__c == null);

        insertedL.Description = 'TestDesc';
        update insertedL;   

        Lead updatedL = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : insertedL.id]; 
        //System.Assert(updatedL.PostalCode == null);
        //System.Assert(updatedL.Franchise__c == null);

        updatedL.PostalCode = '94203';
        update updatedL;

        Lead updatedL2 = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : updatedL.id]; 
        //System.Assert(updatedL2.PostalCode == '94203');
        //System.Assert(updatedL2.Franchise__r.Franchise_Code__c == '129250');

        updatedL2.PostalCode = 'S6W 1A1';
        update updatedL2;

        Lead updatedL3 = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : updatedL2.id]; 
        //System.Assert(updatedL3.PostalCode == 'S6W 1A1');
        //System.Assert(updatedL3.Franchise__r.Franchise_Code__c == '129250');  // franchise should not have changed (because it was already set)
    
        updatedL3.Franchise__c = null;
        update updatedL3;

        Lead updatedL4 = [SELECT id,PostalCode,Franchise__c,Franchise__r.Franchise_Code__c FROM Lead WHERE Id = : updatedL3.id]; 
        //System.Assert(updatedL4.PostalCode == 'S6W 1A1');
        //System.Assert(updatedL4.Franchise__r.Franchise_Code__c == '314100');  // since franchise was cleared, it should now be reset based on the Postal Code

    }

    static testMethod void InsertOppWithUSPostalCode() {
        // Create an Account with a US Zip Code and insert it. Then create an Opp, associate it to the Account, then insert it
        // The Opp should end up associated with a franchise
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Account a = new Account();
        a.Name = 'TestCo';
        a.BillingPostalCode = '03031';
        a.Type = 'Customer';
        a.Sub_Type__c = 'Corporate';
        a.recordTypeId = accountRT;
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.id;
        o.Name = 'TestOpp';
        o.CloseDate = Date.today().addDays(14);
        o.stageName = 'Interview/ Appointment';
        o.RecordTypeId = oppRT;
        insert o;
        
        Opportunity insertedO = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : o.id]; 
        //System.Assert(insertedO.Organization_Postal_Code__c == '03031');
        //System.Assert(insertedO.Franchise__r.Franchise_Code__c == '913071');
    }

    static testMethod void InsertOppWithCAPostalCode() {
        // Create an Account with a CA Zip Code and insert it. Then create an Opp, associate it to the Account, then insert it
        // The Opp should end up associated with a franchise
        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();
        
        Account a = new Account();
        a.Name = 'TestCo';
        a.BillingPostalCode = 'J9H 0A1';
        a.Type = 'Customer';
        a.Sub_Type__c = 'Corporate';
        a.recordTypeId = accountRT;
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.id;
        o.Name = 'TestOpp';
        o.CloseDate = Date.today().addDays(14);
        o.stageName = 'Interview/ Appointment';
        o.RecordTypeId = oppRT;
        insert o;
        
        Opportunity insertedO = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : o.id]; 
        //System.Assert(insertedO.Organization_Postal_Code__c == 'J9H 0A1');
        //System.Assert(insertedO.Franchise__r.Franchise_Code__c == '31520K');
    }
    static testMethod void UpdateOppUseCases() {
        // Exercise update use cases by:
        // Create a opp with a blank postal code, then update the opp with a blank postal code and confirm it is not associated with a franchise
        // Then add a postal code to the account and update it and ensure the opp is now associated with a franchise
        // Then change the postal code and update it and confirm the opp is still associated with the original franchise
        // Then clear the franchise on the opp and update opp and confirm a new franchise is associated with the opp

        Test_FranchiseAssociation.BuildFranchisesWithPostalCodes();

        Account a = new Account();
        a.Name = 'TestCo';
        a.BillingPostalCode = '';
        a.Type = 'Customer';
        a.Sub_Type__c = 'Corporate';
        a.recordTypeId = accountRT;
        insert a;
        
        Opportunity o = new Opportunity();
        o.AccountId = a.id;
        o.Name = 'TestOpp';
        o.CloseDate = Date.today().addDays(14);
        o.stageName = 'Interview/ Appointment';
        o.RecordTypeId = oppRT;
        insert o;
        
        Opportunity insertedO = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c,Description FROM Opportunity WHERE Id = : o.id]; 
        //System.Assert(insertedO.Organization_Postal_Code__c == null);
        //System.Assert(insertedO.Franchise__r.Franchise_Code__c == null);

        insertedO.Description = 'TestDesc';
        update insertedO;   

        Opportunity updatedO = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : insertedO.id]; 
        System.Assert(updatedO.Organization_Postal_Code__c == null);
        //System.Assert(updatedO.Franchise__c == null);

        a.BillingPostalCode = '94203';
        update a;
        update updatedO;

        Opportunity updatedO2 = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : updatedO.id]; 
        //System.Assert(updatedO2.Organization_Postal_Code__c == '94203');
        //System.Assert(updatedO2.Franchise__r.Franchise_Code__c == '129250');

        a.BillingPostalCode = 'S6W 1A1';
        update a;
        update updatedO2;

        Opportunity updatedO3 = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : updatedO2.id]; 
        //System.Assert(updatedO3.Organization_Postal_Code__c == 'S6W 1A1');
        //System.Assert(updatedO3.Franchise__r.Franchise_Code__c == '129250');  // franchise should not have changed (because it was already set)
    
        updatedO3.Franchise__c = null;
        update updatedO3;

        Opportunity updatedO4 = [SELECT id,Organization_Postal_Code__c,Franchise__c,Franchise__r.Franchise_Code__c FROM Opportunity WHERE Id = : updatedO3.id]; 
        //System.Assert(updatedO4.Organization_Postal_Code__c == 'S6W 1A1');
        //System.Assert(updatedO4.Franchise__r.Franchise_Code__c == '314100');  // since franchise was cleared, it should now be reset based on the Postal Code

    }
}