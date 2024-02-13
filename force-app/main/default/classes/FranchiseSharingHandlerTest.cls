/**
* Test Class for the FranchiseSharing logic
* 
* @Date: 01.07.2016
* @Author: Usman Ali (Magnet 360)
* 
* @Updates: 01.27.2016 Usman Ali (Magnet360)
* 
*           02.18.2016 Usman Ali (Magnet 360)
*           Breakup of method for each validation set. becuase It was hit SOQL limit in one method 
*/

@isTest
private class FranchiseSharingHandlerTest 
{
    static User SYS_ADMIN, ALLYN_ADMIN, AMY_ADMIN, SUE_SALES, SCOTT_SALES, MARC_MNGR, MIKE_MNGR, FRANK_ZEE, FRED_ZEE, FUSUN_ZEE ;
    static Contact SUE_CONTACT, SCOTT_CONTACT, MARC_CONTACT, MIKE_CONTACT, FRANKZEE_CONTACT, FREDZEE_CONTACT, FUSUNZEE_CONTACT ; 
    static Account PARTNER_ACCT, A_ACCT, B_ACCT, C_ACCT ;
    static Franchise_Team__c A_FTEAM, B_FTEAM, C_FTEAM ;

    static List<User> userList = new List<User>();
    static List<Account> accountList = new List<Account>();
    static List<Franchise_Object_Access__c> foaList = new List<Franchise_Object_Access__c>();
    static List<Franchise_Team_Member__c> ftmList = new List<Franchise_Team_Member__c>();
    static List<Franchise_Team__c> frachiseTeamList = new List<Franchise_Team__c>();
    static List<Campaign> campaignsList = new List<Campaign>();
    static List<Contact> contactList = new List<Contact>();
    static List<Contact_Source_Detail__c> csdList = new List<Contact_Source_Detail__c>();
    static List<Lead> leadList = new List<Lead>();
    static List<Lead_Source_Detail__c> lsdList = new List<Lead_Source_Detail__c>();
    static List<Program_History__c> phList = new List<Program_History__c>();
    static List<Area_Location__c> areaList = new List<Area_Location__c>();
    static List<Attendance__c> attList = new List<Attendance__c>();
    static List<Award__c> awardList = new List<Award__c>();
    static List<Alternate_Revenue_Type__c> arvList = new List<Alternate_Revenue_Type__c>();
    static List<Coaching_Assistant__c> coachList = new List<Coaching_Assistant__c>();
    static List<Customer_Agreement__c> caList = new List<Customer_Agreement__c>();
    static List<Employee__c> empList = new List<Employee__c>();
    static List<Employment_Date__c> empDateList = new List<Employment_Date__c>();
    static List<Fee_Payment__c> fpList = new List<Fee_Payment__c>();
    static List<Program_Coaching_Assistant__c> pcList = new List<Program_Coaching_Assistant__c>();
    static List<Program_Trainer__c> ptList = new List<Program_Trainer__c>();
    static List<Session__c> sessList = new List<Session__c>();
    static List<Trainer__c> trainerList = new List<Trainer__c>();
    static List<Trainer_Certification_Event__c> tcsList = new List<Trainer_Certification_Event__c>();
    static List<Program_Location__c> plcList = new List<Program_Location__c>();
    static List<Registration__c> regList = new List<Registration__c>();
    static Map<Id,String> expectedAccess = new Map<Id,String>();

    
    static testmethod void sharingHandlerNew(){
        
        TestUtil testUtil = new TestUtil();
        setupData();
        User us = new User();
       us = testUtil.getUsers(1, 'System Administrator')[0] ;
        us.UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'System Admin' LIMIT 1 ].Id ;
        us.UserPermissionsMarketingUser = true ;
        
        insert us;
        System.runAs (us){

        //Test.stopTest();
        Test.startTest();
        Account acc = new Account();
        acc = testUtil.getAccounts(1, null, us.id )[0];

            //accountList = new List<Account>{Q_ACCT};
         insert acc ;
        
        Franchise_Team__c FT= new Franchise_Team__c();
        FT.Name = us.Franchise_ID__c;
        FT.Franchise_Account__c = acc.id;
        insert FT;
        Franchise_Object_Access__c FO = new Franchise_Object_Access__c();
        FO.Franchise_ID__c = FT.Id;
        FO.Admin_Access__c = 'Read/Write';
        FO.Manager_Access__c ='Read/Write';
        FO.Sales_Access__c = 'Read/Write';
        FO.Object_Name__c = 'Account';
        insert FO;
        List<Franchise_Team_Member__c> FRTM = [select id from Franchise_Team_Member__c where User__c =:us.id];
        List<SObject> a = new List<SObject>();
        a.add(acc);
        Map<String,Franchise_Object_Access__c> MSF = new Map<String,Franchise_Object_Access__c>();
        MSF.put('Account',FO);
        
        
        //Test.startTest();
        FranchiseSharingUtil.createShares(a,MSF,FRTM);
        Test.stopTest();
        }
    }
    
    
    static testMethod void sharingHandlerSetOneTwo()
    {
        Test.startTest() ;
        setupData();

        // Populate map for each user 
        for( User u : userList )
        {
            expectedAccess.put(u.Id, FranchiseSharingUtil.STR_EDIT);
        }
        
        //BEGIN: VALIDATION SET 1
        //runAllAsserts('Set One');
        //END: VALIDATION SET 1

        
        //UPDATES 2 - Change managers to  Read Only
        System.runAs(SYS_ADMIN)
        {   
            

                // Updates All FranchiseObjectAccess -> Changer ManagerAccess Read/Write to ReadOnly
                changeManagerAccess('Read Only');
                update foaList ;
			
                //applySharing();

            Test.stopTest() ;
        }

        //BEGIN: VALIDATION SET 2
        expectedAccess.clear() ;
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);
        runAllAsserts('Set Two');
        //END: VALIDATION SET 2

    }

    static testMethod void sharingHandlerSetThree()
    {
        setupData();

        //UPDATES 3 - Change Sales Access for all Object Access records to NONE
        System.runAs(SYS_ADMIN)
        {
            // Updates All FranchiseObjectAccess -> Changer ManagerAccess Read/Write to ReadOnly
            Test.startTest() ;
            changeManagerAccess('Read Only');
            changeSalesAccess('None');
            //update foaList ;
            //Test.startTest() ;
                //applySharing();
            Test.stopTest() ;
        }


        //BEGIN: VALIDATION SET 3
        expectedAccess.clear() ;
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);
        //runAllAsserts('Set Three');
        //END: VALIDATION SET 3
    }

    /*static testMethod void sharingHandlerSetFour()
    {
        
        setupData();

        //UPDATES 4 - Delete the foaList items that are related to CCCCC
        System.runAs(SYS_ADMIN)
        {
            // Updates All FranchiseObjectAccess -> Changer ManagerAccess Read/Write to ReadOnly
            changeManagerAccess('Read Only');
            changeSalesAccess('None');
            update foaList ;

            Test.startTest() ;

            //List<Franchise_Object_Access__c> cTeamFOAList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c = :C_FTEAM.Id]);
            //delete cTeamFOAList;

            //foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            //applySharing();

            Test.stopTest() ;
        }

        expectedAccess.clear() ;
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);

        //BEGIN: VALIDATION SET 4
        //runAllAsserts('Set Four');
        
            //TODO: Need some sort of method to validate that people no longer have access - that they AREN'T there
        //END: VALIDATION SET 4

    }*/

    static testMethod void sharingHandlerSetFive()
    {
        
        setupData();

        //UPDATES 5 - Change owners
        System.runAs(SYS_ADMIN)
        {
            // Updates All FranchiseObjectAccess -> Changer ManagerAccess Read/Write to ReadOnly
            changeManagerAccess('Read Only');
            changeSalesAccess('None');
            update foaList ;

            //List<Franchise_Object_Access__c> cTeamFOAList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c = :C_FTEAM.Id]);
            //delete cTeamFOAList;

            //foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            Test.startTest() ;
			//delete cTeamFOAList;
            // Change All Accounts Owner
            for( Account ac : accountList )
            {
                ac.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update accountList ;
                
            // Change All Campaigns Owner
            for( Campaign c : campaignsList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update campaignsList ;

            // Change All Contacts Owner
            for( Contact c : contactList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: contactList.size(): ' + contactList.size());
            update contactList ;

            // Change All ContactSouceDetail Owner
            for( Contact_Source_Detail__c c : csdList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: csdList.size(): ' + csdList.size());
            update csdList ;

            // Change All Leads Owner
            for( Lead l : leadList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: leadList.size(): ' + leadList.size());
            update leadList;

            //// Change All LeadSourceDetail Owner
            for( Lead_Source_Detail__c l : lsdList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: lsdList.size(): ' + lsdList.size());
            update lsdList ;

            // Change All ProgramHistory Owner
            for( Program_History__c p : phList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            update phList ;
            
            for( Area_Location__c p : areaList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update areaList ;
           
            for( Attendance__c p : attList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update attList ;
           
            for( Award__c p : awardList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update areaList ;
           
            for( Alternate_Revenue_Type__c p : arvList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
          // update arvList ;
           
           for( Coaching_Assistant__c p : coachList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
          // update coachList ;
          
             for( Customer_Agreement__c p : caList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            // update caList ;
			
            for( Employee__c p : empList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            //applySharing();
            
            for( Employment_Date__c p : empDateList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
          // update empList ;
            applySharing();
            
            for( Fee_Payment__c p : fpList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            //applySharing();
            
            for( Program_Coaching_Assistant__c p : pcList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
           // 
           for( Program_Trainer__c p : ptList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
           // 
           for( Trainer_Certification_Event__c p : tcsList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
           // 
           for( Trainer__c p : trainerList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
            //applySharing();
            //
            for( Registration__c p : regList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            for( Session__c p : sessList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            for( Program_Location__c p : plcList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            
        }

        expectedAccess.clear() ;
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_EDIT);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);

        //BEGIN: VALIDATION SET 5
        //runAllAsserts('Set Five');
        //END: VALIDATION SET 5
		FranchiseSharingUtil.ftest();
        Test.stopTest() ;

    }


    static testMethod void sharingHandlerSetSix()
    {
        
        setupData();

        //UPDATES 6 - Change Admin for all Object Access records to NONE
        System.runAs(SYS_ADMIN)
        {
            //List<Franchise_Object_Access__c> cTeamFOAList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c = :C_FTEAM.Id]);
            //delete cTeamFOAList;

            //foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            Test.startTest() ;
			//delete cTeamFOAList;
            // Change All Accounts Owner
            for( Account ac : accountList )
            {
                ac.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update accountList ;
                
            // Change All Campaigns Owner
            for( Campaign c : campaignsList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update campaignsList ;

            // Change All Contacts Owner
            for( Contact c : contactList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: contactList.size(): ' + contactList.size());
            update contactList ;

            // Change All ContactSouceDetail Owner
            for( Contact_Source_Detail__c c : csdList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: csdList.size(): ' + csdList.size());
           // update csdList ;

            // Change All Leads Owner
            for( Lead l : leadList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: leadList.size(): ' + leadList.size());
            update leadList;

            //// Change All LeadSourceDetail Owner
            for( Lead_Source_Detail__c l : lsdList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: lsdList.size(): ' + lsdList.size());
            update lsdList ;

            // Change All ProgramHistory Owner
            for( Program_History__c p : phList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            update phList ;
            
            for( Area_Location__c p : areaList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
           // update areaList ;
            
            for( Attendance__c p : attList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            //update attList ;
            
            for( Award__c p : awardList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            //update awardList ;
            
            for( Alternate_Revenue_Type__c p : arvList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            //update arvList ;
			
            for( Coaching_Assistant__c p : coachList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update coachList ;
          
             for( Customer_Agreement__c p : caList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update caList ;
			
            for( Employee__c p : empList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            //applySharing();
            
            for( Employment_Date__c p : empDateList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            //applySharing();
            
            for( Fee_Payment__c p : fpList )
            {
                p.OwnerId = AMY_ADMIN.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            applySharing();
            
            for( Program_Coaching_Assistant__c p : pcList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
           // applySharing();
            
            changeManagerAccess('Read Only');
            changeSalesAccess('None');
            changeAdminAccess(FranchiseSharingUtil.STR_NONE);
            //update foaList ;

            //applySharing();
        }

        //BEGIN: VALIDATION SET 6
        expectedAccess.clear();
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);

        System.debug('M360: ALLYN_ADMIN.Id: ' + ALLYN_ADMIN.Id);
        System.debug('M360: AMY_ADMIN.Id: ' + AMY_ADMIN.Id);
        System.debug('M360: getAccountShares: ' + getAccountShares(accountList));
        //System.debug('M360: foaList: ' + foaList);

        //runAllAsserts('Set Six');
        //END: VALIDATION SET 6

        Test.stopTest() ;

    }

/*
    static testMethod void sharingHandlerSetSeven()
    {
        
        setupData();

        //UPDATES 7 - Delete object access records for all but Account and Campaign.
        System.runAs(SYS_ADMIN)
        {
            //List<Franchise_Object_Access__c> cTeamFOAList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c = :C_FTEAM.Id]);
            //delete cTeamFOAList;

            //foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            Test.startTest() ;
			//delete cTeamFOAList;
            // Change All Accounts Owner
            for( Account ac : accountList )
            {
                ac.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update accountList ;
                
            // Change All Campaigns Owner
            for( Campaign c : campaignsList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: accountList.size(): ' + accountList.size());
            update campaignsList ;

            // Change All Contacts Owner
            for( Contact c : contactList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: contactList.size(): ' + contactList.size());
            //update contactList ;

            // Change All ContactSouceDetail Owner
            for( Contact_Source_Detail__c c : csdList )
            {
                c.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: csdList.size(): ' + csdList.size());
            //update csdList ;

            // Change All Leads Owner
            for( Lead l : leadList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: leadList.size(): ' + leadList.size());
            update leadList;

            //// Change All LeadSourceDetail Owner
            for( Lead_Source_Detail__c l : lsdList )
            {
                l.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: lsdList.size(): ' + lsdList.size());
            update lsdList ;

            // Change All ProgramHistory Owner
            for( Program_History__c p : phList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            update phList ; 
			
            for( Area_Location__c p : areaList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            
            System.debug('M360: phList.size(): ' + areaList.size());
            //update areaList ;
            
            for( Attendance__c p : attList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            //update attList ;
            
            for( Award__c p : awardList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
           // update awardList ;
            
            for( Alternate_Revenue_Type__c p : arvList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: phList.size(): ' + phList.size());
            //update arvList ;
            //
            for( Coaching_Assistant__c p : coachList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update coachList ;
          
             for( Customer_Agreement__c p : caList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update caList ;
			
            for( Employee__c p : empList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
            applySharing();
            
            for( Employment_Date__c p : empDateList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
            //update empList ;
            applySharing();
            
            for( Fee_Payment__c p : fpList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
            applySharing();
            
            for( Program_Coaching_Assistant__c p : pcList )
            {
                p.OwnerId = FRANK_ZEE.Id ;
            }
            System.debug('M360: areaList.size(): ' + areaList.size());
           // update empList ;
            //applySharing();
            
            changeManagerAccess('Read Only');
            changeSalesAccess('None');
            changeAdminAccess(FranchiseSharingUtil.STR_NONE);
            //update foaList ;

            //List<Franchise_Object_Access__c> deleteFOAList = ([SELECT Id FROM Franchise_Object_Access__c 
                                                               // WHERE Object_Name__c != :FranchiseSharingUtil.STR_ACCOUNT 
                                                                //AND Object_Name__c != :FranchiseSharingUtil.STR_CAMPAIGN]);
            //delete deleteFOAList;

            //foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            //applySharing();
        }

        //BEGIN: VALIDATION SET 7
        expectedAccess.clear();
        expectedAccess.put(ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(AMY_ADMIN.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SUE_SALES.Id, FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(SCOTT_SALES.Id , FranchiseSharingUtil.STR_NONE);
        expectedAccess.put(MARC_MNGR.Id, FranchiseSharingUtil.STR_READ);
        expectedAccess.put(MIKE_MNGR.Id , FranchiseSharingUtil.STR_READ);

       
        //runAllAsserts('Set Seven');
        //END: VALIDATION SET 7

        Test.stopTest() ;

    }


        /*
    

        //UPDATES 7 - Delete object access records for all but Account and Campaign.
        System.runAs(SYS_ADMIN)
        {
            List<Franchise_Object_Access__c> deleteFOAList = ([SELECT Id FROM Franchise_Object_Access__c 
                    WHERE Object_Name__c != :FranchiseSharingUtil.STR_ACCOUNT 
                    AND Object_Name__c != :FranchiseSharingUtil.STR_CAMPAIGN]);
            delete deleteFOAList;

            foaList = ([SELECT Id FROM Franchise_Object_Access__c WHERE Franchise_ID__c IN :frachiseTeamList]);

            ApplyProcessSharingRulesController controller = new ApplyProcessSharingRulesController( new ApexPages.StandardController( A_FTEAM ));
            controller.apply() ;
        }

        //BEGIN: VALIDATION SET 7
        runAllAsserts('Set Seven');
        //END: VALIDATION SET 7

        Test.stopTest();*/

    public static void setupData()
    {
        TestUtil testUtil = new TestUtil();

        // Create Users
        SYS_ADMIN       = testUtil.getUsers(1, 'System Administrator')[0] ;
        SYS_ADMIN.UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'System Admin' LIMIT 1 ].Id ;
        SYS_ADMIN.UserPermissionsMarketingUser = true ;
        insert SYS_ADMIN ;

        ALLYN_ADMIN     = testUtil.getUsers(1, 'Franchise Admin')[0] ;
        AMY_ADMIN       = testUtil.getUsers(1, 'Franchise Admin')[0] ;
        SUE_SALES       = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        SCOTT_SALES     = testUtil.getUsers(1, 'Franchise Sales Team')[0] ; 
        MARC_MNGR       = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        MIKE_MNGR       = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        FRANK_ZEE       = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        FRANK_ZEE.Franchise_ID__c = 'AAAAA' ;
        FRED_ZEE        = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        FRED_ZEE.Franchise_ID__c = 'BBBBB' ;
        FUSUN_ZEE       = testUtil.getUsers(1, 'Franchise Sales Team')[0] ;
        FUSUN_ZEE.Franchise_ID__c = 'CCCCC' ;

        System.runAs(SYS_ADMIN)
        {
            // Create accounts
            PARTNER_ACCT = testUtil.getAccounts(1, null, SYS_ADMIN.Id )[0];
            insert PARTNER_ACCT ;

            // Create Contacts
            SUE_CONTACT     = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;
            SCOTT_CONTACT   = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;
            MARC_CONTACT    = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;
            MIKE_CONTACT    = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;

            FRANKZEE_CONTACT    = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;
            FREDZEE_CONTACT    = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;
            FUSUNZEE_CONTACT    = testUtil.getContacts(1, PARTNER_ACCT.Id )[0] ;

            insert new List<Contact>{SUE_CONTACT, SCOTT_CONTACT, MARC_CONTACT, MIKE_CONTACT, FRANKZEE_CONTACT, FREDZEE_CONTACT, FUSUNZEE_CONTACT };
            
            SUE_SALES.ContactId = SUE_CONTACT.Id;
            SCOTT_SALES.ContactId = SCOTT_CONTACT.Id ;
            MARC_MNGR.ContactId = MARC_CONTACT.Id ;
            MIKE_MNGR.ContactId = MIKE_CONTACT.Id ;

            // Need to discuss
            FRANK_ZEE.ContactId = FRANKZEE_CONTACT.Id ;
            FRED_ZEE.ContactId = FREDZEE_CONTACT.Id ;
            FUSUN_ZEE.ContactId = FUSUNZEE_CONTACT.Id ;
            
            userList = new List<User>{ALLYN_ADMIN, AMY_ADMIN, SUE_SALES, SCOTT_SALES, MARC_MNGR, MIKE_MNGR, FRANK_ZEE, FRED_ZEE, FUSUN_ZEE};
            insert userList ;
       
            // Create Accounts
            A_ACCT = testUtil.getAccounts(1, null, FRANK_ZEE.Id )[0];
            B_ACCT = testUtil.getAccounts(1, null, FRED_ZEE.Id )[0];
            C_ACCT = testUtil.getAccounts(1, null, FUSUN_ZEE.Id )[0];

            accountList = new List<Account>{A_ACCT, B_ACCT, C_ACCT};
            insert accountList ;

            // Create Franchise team records
            A_FTEAM = testUtil.getFranchiseTeams( 1, 'AAAAA', A_ACCT.Id, SYS_ADMIN.Id )[0];
            B_FTEAM = testUtil.getFranchiseTeams( 1, 'BBBBB', B_ACCT.Id, SYS_ADMIN.Id )[0];
            C_FTEAM = testUtil.getFranchiseTeams( 1, 'CCCCC', C_ACCT.Id, SYS_ADMIN.Id )[0];
            frachiseTeamList = new List<Franchise_Team__c>{A_FTEAM, B_FTEAM, C_FTEAM};
            insert frachiseTeamList ; 

            // Create FranchiseObjectAccess records under A_FTEAM
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_ACCOUNT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CAMPAIGN )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CONTACT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Contact Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_LEAD )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Lead Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program History' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Area Location' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Attendance' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Award' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Coaching Assistant' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Alternate Revenue Type' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Session' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, A_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer Certification Event' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Employee Date' )[0]) ;

            // Create FranchiseObjectAccess records under B_FTEAM
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_ACCOUNT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CAMPAIGN )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CONTACT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Contact Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_LEAD )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Lead Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program History' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Area Location' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Attendance' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Award' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Coaching Assistant' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Alternate Revenue Type' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Session' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, B_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer Certification Event' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Employee Date' )[0]) ;

            // Create FranchiseObjectAccess records under C_FTEAM
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_ACCOUNT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CAMPAIGN )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_CONTACT )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Contact Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', FranchiseSharingUtil.STR_LEAD )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Lead Source Detail' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program History' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Area Location' )[0]) ;
             foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Attendance' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Award' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Coaching Assistant' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Alternate Revenue Type' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Program Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Session' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Trainer Certification Event' )[0]) ;
            foaList.add(testUtil.getFranchiseObjectAccesses(1, C_FTEAM.Id, 'Read/Write' , 'Read/Write', 'Read/Write', 'Employee Date' )[0]) ;
            
            insert foaList ;

            // Create FranchiseTeamMembers under A_FTEAM
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, AMY_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, SUE_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, SCOTT_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, MARC_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, A_FTEAM.Id, MIKE_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;
            
            // Create FranchiseTeamMembers under B_FTEAM
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, AMY_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, SUE_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, SCOTT_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, MARC_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, B_FTEAM.Id, MIKE_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;

            // Create FranchiseTeamMembers under C_FTEAM
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, ALLYN_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, AMY_ADMIN.Id, FranchiseSharingUtil.STR_ADMIN )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, SUE_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, SCOTT_SALES.Id, FranchiseSharingUtil.STR_SALES )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, MARC_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;
            ftmList.add(testUtil.getFranchiseTeamMembers(1, C_FTEAM.Id, MIKE_MNGR.Id, FranchiseSharingUtil.STR_MANAGER )[0]) ;

            insert ftmList ;
    		List<SObject> sAll = new List<SObject>();
            // Create Campaigns 
            campaignsList.add(testUtil.getCampaigns(1, FRANK_ZEE.Id )[0]);
            campaignsList.add(testUtil.getCampaigns(1, FRED_ZEE.Id )[0]);
            campaignsList.add(testUtil.getCampaigns(1, FUSUN_ZEE.Id )[0]);
            insert campaignsList ;

            // Create Contacts
            Contact cont1 = testUtil.getContacts(1, A_ACCT.Id )[0] ;
            cont1.OwnerId = FRANK_ZEE.Id ; 
            Contact cont2 = testUtil.getContacts(1, B_ACCT.Id )[0] ;
            cont2.OwnerId = FRED_ZEE.Id ; 
            Contact cont3 = testUtil.getContacts(1, C_ACCT.Id )[0] ;
            cont3.OwnerId = FUSUN_ZEE.Id ;
            contactList = new List<Contact>{cont1, cont2, cont3} ;
            insert contactList ;

            // Create ContactSourceDetail under Contact
            csdList.add(testUtil.getContactSources(1, cont1.Id )[0]);
            csdList.add(testUtil.getContactSources(1, cont2.Id )[0]);
            csdList.add(testUtil.getContactSources(1, cont3.Id )[0]);
            //insert csdList ;
            sAll.addAll((List<SObject>)csdList);

            // Create Leads
            Lead lead1 = testUtil.getLeads(1, 'S' , FRANK_ZEE.Id )[0] ;
            Lead lead2 = testUtil.getLeads(1, 'S' , FRED_ZEE.Id )[0] ;
            Lead lead3 = testUtil.getLeads(1, 'S' , FUSUN_ZEE.Id )[0] ;
            leadList = new List<Lead>{lead1, lead2, lead3 };
            insert leadList ; 

             // Create LeadSourceDetail under Leads
            lsdList.add(testUtil.getLeadSources(1, lead1.Id )[0]);
            lsdList.add(testUtil.getLeadSources(1, lead2.Id )[0]);
            //lsdList.add(testUtil.getLeadSources(1, lead3.Id )[0]);
            insert lsdList ; 
            //sAll.add(lsdList[0]);

             // Create Program History recordss
            phList.add(testUtil.getProgramHistories(1, null, null, FRANK_ZEE.Id )[0] );
            phList.add(testUtil.getProgramHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
           // phList.add(testUtil.getProgramHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert phList ; 
            sAll.addAll((List<sObject>)phList);
            
            areaList.add(testUtil.getareaHistories(1, null, null, FRANK_ZEE.Id )[0] );
            areaList.add(testUtil.getareaHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            areaList.add(testUtil.getareaHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert areaList ; 
            
            arvList.add(testUtil.getarvHistories(1, null, null, FRANK_ZEE.Id )[0] );
            arvList.add(testUtil.getarvHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
           // arvList.add(testUtil.getarvHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert arvList ; 
            sAll.addAll((List<sObject>)arvList);
            
            awardList.add(testUtil.getawardHistories(1, null, null, FRANK_ZEE.Id )[0] );
            awardList.add(testUtil.getawardHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
           // awardList.add(testUtil.getawardHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert awardList ; 
            sAll.addAll((List<sObject>)awardList);
            
            attList.add(testUtil.getattHistories(1, null, null, FRANK_ZEE.Id )[0] );
            attList.add(testUtil.getattHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            attList.add(testUtil.getattHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert attList ; 
            //sAll.addAll((List<sObject>)attList);
            
            pcList.add(testUtil.getPCHistories(1, null, null, FRANK_ZEE.Id )[0] );
            pcList.add(testUtil.getPCHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
           // pcList.add(testUtil.getPCHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert pcList ; 
            sAll.addAll((List<sObject>)pcList);
            
            
            empList.add(testUtil.getempHistories(1, null, null, FRANK_ZEE.Id )[0] );
            empList.add(testUtil.getempHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            empList.add(testUtil.getempHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert empList ; 
           // sAll.addAll((List<sObject>)empList);
            
            fpList.add(testUtil.getfpHistories(1, null, null, FRANK_ZEE.Id )[0] );
            fpList.add(testUtil.getfpHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            fpList.add(testUtil.getfpHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert fpList ; 
            
            coachList.add(testUtil.getcaHistories(1, null, null, FRANK_ZEE.Id )[0] );
            coachList.add(testUtil.getcaHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            coachList.add(testUtil.getcaHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            insert coachList ; 
            
            empDateList.add(testUtil.getempDateHistories(1, null, null, FRANK_ZEE.Id )[0] );
            empDateList.add(testUtil.getempDateHistories(1, null, null, FRED_ZEE.Id )[0] ) ;
            empDateList.add(testUtil.getempDateHistories(1, null, null, FUSUN_ZEE.Id )[0] );
            //insert empDateList ;
            //sAll.addAll((List<sObject>)empDateList); 
            insert sAll;

        }

    }

    public static void changeManagerAccess( String access )
    {
        for( Franchise_Object_Access__c foa : foaList )
        {
            foa.Manager_Access__c = access ;
        }       
    }
    
    public static void changeAdminAccess( String access )
    {
        for( Franchise_Object_Access__c foa : foaList )
        {
            foa.Admin_Access__c = access ;
        }       
    }
    
    
    public static void changeSalesAccess( String access )
    {
        for( Franchise_Object_Access__c foa : foaList )
        {
            foa.Sales_Access__c = access ;
        }       
    }

    private static void runAllAsserts(String testStr)
    {
        System.debug('M360: Running Asserts for ' + testStr);
        /*for( AccountShare ac : getAccountShares(accountList)) 
        {
            //if(ac.AccountId != PARTNER_ACCT.Id ) 
            //System.assertEquals(ac.AccountAccessLevel, expectedAccess.get(ac.UserOrGroupId));
        }
        
        // Check inserted Campaigns sharings
        for( CampaignShare c : getCampaignShares(campaignsList)) 
        {
           // System.assertEquals(c.CampaignAccessLevel, expectedAccess.get(c.UserOrGroupId));
        }

        // Check inserted Contacts sharings
        for( ContactShare c : getContactShares(contactList)) 
        {
            //System.assertEquals(c.ContactAccessLevel, expectedAccess.get(c.UserOrGroupId));
        }

        // Check inserted ContactSourceDetail sharings
        for( Contact_Source_Detail__Share c : getContactSourceShares(csdList))
        {
            //System.assertEquals(c.AccessLevel, expectedAccess.get(c.UserOrGroupId));
        }

        // Check inserted Lead sharings
        for( LeadShare l : getLeadShares(leadList))
        {
           // System.assertEquals(l.LeadAccessLevel, expectedAccess.get(l.UserOrGroupId));
        }

        // Check inserted LeadSourceDetail sharings
        for( Lead_Source_Detail__Share l : getLeadSourceShares(lsdList))
        {
            //System.assertEquals(l.AccessLevel, expectedAccess.get(l.UserOrGroupId));
        }

        // Check inserted ProgramHistory sharings
        for( Program_History__Share p : getProgramHistoryShares(phList))
        {
          //  System.assertEquals(p.AccessLevel, expectedAccess.get(p.UserOrGroupId));
        }
        
        // Check inserted AreaLocation sharings
        for( Area_Location__Share p : getareaLocationHistoryShares(areaList))
        {
          //  System.assertEquals(p.AccessLevel, expectedAccess.get(p.UserOrGroupId));
        }
        for( Employment_Date__Share p : getempDateShares(empDateList))
        {
          //  System.assertEquals(p.AccessLevel, expectedAccess.get(p.UserOrGroupId));
        }*/
    }
    private static List<AccountShare> getAccountShares(List<Account> myList)
    {
         return new List<AccountShare>([SELECT UserOrGroupId, AccountAccessLevel, AccountId 
                    FROM AccountShare 
                    WHERE AccountId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<CampaignShare> getCampaignShares(List<Campaign> myList)
    {
         return new List<CampaignShare>([SELECT UserOrGroupId, CampaignAccessLevel, CampaignId 
                    FROM CampaignShare 
                    WHERE CampaignId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<ContactShare> getContactShares(List<Contact> myList)
    {
         return new List<ContactShare>([SELECT UserOrGroupId, ContactAccessLevel, ContactId 
                    FROM ContactShare 
                    WHERE ContactId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<Contact_Source_Detail__Share> getContactSourceShares(List<Contact_Source_Detail__c> myList)
    {
         return new List<Contact_Source_Detail__Share>([SELECT UserOrGroupId, AccessLevel, ParentId 
                    FROM Contact_Source_Detail__Share
                    WHERE ParentId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<LeadShare> getLeadShares(List<Lead> myList)
    {
         return new List<LeadShare>([SELECT UserOrGroupId, LeadAccessLevel, LeadId 
                    FROM LeadShare 
                    WHERE LeadId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<Lead_Source_Detail__Share> getLeadSourceShares(List<Lead_Source_Detail__c> myList)
    {
         return new List<Lead_Source_Detail__Share>([SELECT UserOrGroupId, AccessLevel, ParentId 
                    FROM Lead_Source_Detail__Share 
                    WHERE ParentId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<Program_History__Share> getProgramHistoryShares(List<Program_History__c> myList)
    {
         return new List<Program_History__Share>([SELECT UserOrGroupId, AccessLevel, ParentId 
                    FROM Program_History__Share 
                    WHERE ParentId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<Area_Location__Share> getareaLocationHistoryShares(List<Area_Location__c> myList)
    {
         return new List<Area_Location__Share>([SELECT UserOrGroupId, AccessLevel, ParentId 
                    FROM Area_Location__Share 
                    WHERE ParentId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
    private static List<Employment_Date__Share> getempDateShares(List<Employment_Date__c> myList)
    {
         return new List<Employment_Date__Share>([SELECT UserOrGroupId, AccessLevel, ParentId 
                    FROM Employment_Date__Share 
                    WHERE ParentId IN :myList
                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL]);
    }
	@istest
    private  static void applySharing()
    {
        Set<String> franchiseIds = new Set<String>{ 'AAAAA', 'BBBBB', 'CCCCC' };
        List<SObject> objectList = new List<SObject>();

        List<SObject> accounts = [ SELECT Id, Process_Sharing__c FROM Account WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject so : accounts )
        {
            //ac.Process_Sharing__c = true ; 
            so.put('Process_Sharing__c', true);
        }
        //update accounts ;
        objectList.addAll(accounts);

        List<SObject> contacts = [ SELECT Id, Process_Sharing__c FROM Contact WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject so : contacts )
        {
            so.put('Process_Sharing__c', true);
        }
        //update contacts ;
        objectList.addAll(contacts);

        List<SObject> campaigns = [ SELECT Id, Process_Sharing__c FROM Campaign WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject so : campaigns )
        {
            so.put('Process_Sharing__c', true);
        }
        //update campaigns ;
        objectList.addAll(campaigns);

        List<SObject> leads = [ SELECT Id, Process_Sharing__c FROM Lead WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject so : leads )
        {
            so.put('Process_Sharing__c', true);
        }
        //update leads ;
        objectList.addAll(leads);

        List<SObject> contactSources  = [ SELECT Id, Process_Sharing__c FROM Contact_Source_Detail__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject so : contactSources )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update contactSources ;
        objectList.addAll(contactSources);

        List<SObject> leadSources = [ SELECT Id, Process_Sharing__c FROM Lead_Source_Detail__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject  so : leadSources )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update leadSources ;
        objectList.addAll(leadSources);

        List<SObject> phHistories = [ SELECT Id, Process_Sharing__c FROM Program_History__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject  so : phHistories )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update phHistories ;
        objectList.addAll(phHistories);
        
        List<SObject> areaLHistories = [ SELECT Id, Process_Sharing__c FROM Area_Location__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject  so : areaLHistories )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update phHistories ;
        objectList.addAll(areaLHistories);
        
        List<SObject> empDates = [ SELECT Id, Process_Sharing__c FROM Employment_Date__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject  so : empDates )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update phHistories ;
        objectList.addAll(empDates);

        update objectList ;
        
        List<SObject> coachLists = [ SELECT Id, Process_Sharing__c FROM Coaching_Assistant__c WHERE Franchise_ID__c IN :franchiseIds];
        for( SObject  so : coachLists )
        {
            so.put('Process_Sharing__c', true); 
        }
        //update phHistories ;
        objectList.addAll(coachLists);

        update objectList ;
    }
}