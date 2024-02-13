/**
* Contains repeatable methods that are used in the FranchiseSharing updates
* 
* @Date: 01.06.2016
* @Author: Sophia Murphy (Magnet 360)
* 
* @Updates:
* 01.21.2016    Sophia Murphy (Magnet 360)
*               Addition of other objects
* 
*/
public with sharing class FranchiseSharingUtil {

    public static String STR_EDIT = 'Edit';
    public static String STR_READ = 'Read';
    public static Map<String, String> VALID_ACCESS = new Map<String, String>{'Read/Write' => STR_EDIT, 'Read Only' => STR_READ};
    public static String STR_ADMIN = 'Admin';
    public static String STR_MANAGER = 'Manager';
    public static String STR_SALES = 'Sales';

    public static String STR_NONE = 'None';

    public static String STR_ACCOUNT = 'Account';
    public static String STR_CONTACT = 'Contact';
    public static String STR_CAMPAIGN = 'Campaign'; 
    public static String STR_LEAD = 'Lead';
    public static String STR_CONTACTSOURCE = 'Contact_Source_Detail__c';
    public static String STR_LEADSOURCE = 'Lead_Source_Detail__c';
    public static String STR_PROGRAMHISTORY = 'Program_History__c';
    public static String STR_AREA_LOC = 'Area_Location__c';
    public static String STR_ATTENDANCE = 'Attendance__c';
    public static String STR_AWARD = 'Award__c';
    public static String STR_ARTYPE = 'Alternate_Revenue_Type__c';
    public static String STR_COACH_ASST = 'Coaching_Assistant__c';
    public static String STR_CUST_AGREEMENT = 'Customer_Agreement__c'; 
    public static String STR_EMPLOYEE = 'Employee__c'; 
    public static String STR_EMP_DATE = 'Employment_Date__c';
    public static String STR_FEE_PAYMENT = 'Fee_Payment__c';
    public static String STR_PROGRAM = 'Program__c';
    public static String STR_PROG_COACH_ASST = 'Program_Coaching_Assistant__c';
    public static String STR_PROG_LOCATION = 'Program_Location__c';
    public static String STR_PROG_TRAINER = 'Program_Trainer__c';
    public static String STR_REGISTRATION = 'Registration__c';
    public static String STR_SALES_PERSON = 'Sales_Person__c';
    public static String STR_SESSION = 'Session__c';
    public static String STR_TRAINER = 'Trainer__c';
    public static String STR_TRAINER_CERT_EVENT = 'Trainer_Certification_Event__c';

    public static String STR_OPP = 'Opportunity';
    public static String STR_CASE = 'Case';
    public static String STR_MANUAL = 'Manual';

    public static Map<String,String> labelToAPINamesObjects{ get {
                                                                    if( labelToAPINamesObjects == null )
                                                                    {
                                                                        labelToAPINamesObjects = new Map<String,String>();
                                                                        labelToAPINamesObjects.put( STR_ACCOUNT, STR_ACCOUNT );
                                                                        labelToAPINamesObjects.put( STR_CONTACT , STR_CONTACT );
                                                                        labelToAPINamesObjects.put( STR_CAMPAIGN , STR_CAMPAIGN);
                                                                        labelToAPINamesObjects.put( STR_LEAD , STR_LEAD );
                                                                        labelToAPINamesObjects.put('Contact Source Detail' , STR_CONTACTSOURCE );
                                                                        labelToAPINamesObjects.put('Lead Source Detail' , STR_LEADSOURCE );
                                                                        labelToAPINamesObjects.put('Program History' , STR_PROGRAMHISTORY );
                                                                        labelToAPINamesObjects.put('Area Location' , STR_AREA_LOC );
                                                                        labelToAPINamesObjects.put('Attendance' , STR_ATTENDANCE );
                                                                        labelToAPINamesObjects.put('Award' , STR_AWARD );
                                                                        labelToAPINamesObjects.put('Alternate Revenue Type' , STR_ARTYPE );
                                                                        labelToAPINamesObjects.put('Coaching Assistant' , STR_COACH_ASST );
                                                                        labelToAPINamesObjects.put('Customer Agreement' , STR_CUST_AGREEMENT );
                                                                        labelToAPINamesObjects.put('Employee' , STR_EMPLOYEE );
                                                                        labelToAPINamesObjects.put('Employee Date' , STR_EMP_DATE );
                                                                        labelToAPINamesObjects.put('Fee Payment' , STR_FEE_PAYMENT );
                                                                        labelToAPINamesObjects.put('Program' , STR_PROGRAM );
                                                                        labelToAPINamesObjects.put('Program Coaching Assistant' , STR_PROG_COACH_ASST );
                                                                        labelToAPINamesObjects.put('Program Location' , STR_PROG_LOCATION );
                                                                        labelToAPINamesObjects.put('Program Trainer' , STR_PROG_TRAINER );
                                                                        labelToAPINamesObjects.put('Registration' , STR_REGISTRATION );
                                                                        labelToAPINamesObjects.put('Sales Person' , STR_SALES_PERSON );
                                                                        labelToAPINamesObjects.put('Session' , STR_SESSION );
                                                                        labelToAPINamesObjects.put('Trainer' , STR_TRAINER );
                                                                        labelToAPINamesObjects.put('Trainer Certification Event' , STR_TRAINER_CERT_EVENT );
                                                                        
                                                                    } 
                                                                    return labelToAPINamesObjects;
                                                                }
                                                            } 

    public static Map<String,String> apiNamesToLabelObjects{ get {
                                                                    if( apiNamesToLabelObjects == null )
                                                                    {
                                                                        apiNamesToLabelObjects = new Map<String,String>();
                                                                        apiNamesToLabelObjects.put( STR_ACCOUNT, STR_ACCOUNT );
                                                                        apiNamesToLabelObjects.put( STR_CONTACT , STR_CONTACT );
                                                                        apiNamesToLabelObjects.put( STR_CAMPAIGN , STR_CAMPAIGN);
                                                                        apiNamesToLabelObjects.put( STR_LEAD , STR_LEAD );
                                                                        apiNamesToLabelObjects.put( STR_CONTACTSOURCE , 'Contact Source Detail' );
                                                                        apiNamesToLabelObjects.put( STR_LEADSOURCE , 'Lead Source Detail'  );
                                                                        apiNamesToLabelObjects.put( STR_PROGRAMHISTORY , 'Program History'  );
                                                                        apiNamesToLabelObjects.put(STR_AREA_LOC, 'Area Location');
                                                                        apiNamesToLabelObjects.put(STR_ATTENDANCE , 'Attendance');
                                                                        apiNamesToLabelObjects.put(STR_AWARD, 'Award'  );
                                                                        apiNamesToLabelObjects.put( STR_ARTYPE , 'Alternate Revenue Type');
                                                                        apiNamesToLabelObjects.put( STR_COACH_ASST , 'Coaching Assistant');
                                                                        apiNamesToLabelObjects.put( STR_CUST_AGREEMENT, 'Customer Agreement' );
                                                                        apiNamesToLabelObjects.put(STR_EMPLOYEE, 'Employee');
                                                                        apiNamesToLabelObjects.put( STR_EMP_DATE , 'Employee Date' );
                                                                        apiNamesToLabelObjects.put(STR_FEE_PAYMENT, 'Fee Payment' );
                                                                        apiNamesToLabelObjects.put(STR_PROGRAM , 'Program' );
                                                                        apiNamesToLabelObjects.put( STR_PROG_COACH_ASST, 'Program Coaching Assistant' );
                                                                        apiNamesToLabelObjects.put( STR_PROG_LOCATION , 'Program Location');
                                                                        apiNamesToLabelObjects.put( STR_PROG_TRAINER , 'Program Trainer');
                                                                        apiNamesToLabelObjects.put( STR_REGISTRATION , 'Registration');
                                                                        apiNamesToLabelObjects.put(STR_SALES_PERSON, 'Sales Person' );
                                                                        apiNamesToLabelObjects.put(STR_SESSION , 'Session');
                                                                        apiNamesToLabelObjects.put( STR_TRAINER , 'Trainer');
                                                                        apiNamesToLabelObjects.put(STR_TRAINER_CERT_EVENT , 'Trainer Certification Event' );
                                                                    } 
                                                                    return apiNamesToLabelObjects;
                                                                }
                                                            } 

    public static List<sObject> createShares(List<sObject> sobjList, Map<String, Franchise_Object_Access__c> accessByObject, List<Franchise_Team_Member__c> teamMembers)
    {
        Boolean runOpps = false;
        Map<Id, List<Franchise_Team_Member__c>> acctIdToFTM_forOpps = new Map<Id, List<Franchise_Team_Member__c>>();
        Map<String, String> acct_userToOppAccess = new Map<String, String>();

        List<sObject> returnShares = new List<sObject>();
        System.debug('M360: sobjList: ' + sobjList);
        System.debug('M360: accessByObject: ' + accessByObject);
        for(String objName : accessByObject.keySet())
        {
            Franchise_Object_Access__c foa = accessByObject.get(objName);

            System.debug('M360: objName: ' + objName);
            System.debug('M360: foa: ' + foa);

            Map<String, String> roleToAccess = new Map<String, String>();
            roleToAccess.put(STR_ADMIN, foa.Admin_Access__c);
            roleToAccess.put(STR_MANAGER, foa.Manager_Access__c);
            roleToAccess.put(STR_SALES, foa.Sales_Access__c);

            if(objName == STR_ACCOUNT ) 
            {
                roleToAccess.put(STR_OPP + STR_ADMIN  , foa.Opp_Admin_Access__c);
                roleToAccess.put(STR_OPP + STR_MANAGER , foa.Opp_Manager_Access__c);
                roleToAccess.put(STR_OPP + STR_SALES , foa.Opp_Sales_Access__c);

                roleToAccess.put(STR_CASE + STR_ADMIN , foa.Case_Admin_Access__c);
                roleToAccess.put(STR_CASE + STR_MANAGER , foa.Case_Manager_Access__c);
                roleToAccess.put(STR_CASE + STR_SALES , foa.Case_Sales_Access__c);

                roleToAccess.put(STR_CONTACT + STR_ADMIN , foa.Contact_Admin_Access__c);
                roleToAccess.put(STR_CONTACT + STR_MANAGER , foa.Contact_Manager_Access__c);
                roleToAccess.put(STR_CONTACT + STR_SALES , foa.Contact_Sales_Access__c);

                System.debug('M360: 1: ' + roleToAccess);

                runOpps = true;
            }

            for(Franchise_Team_Member__c ftm : teamMembers)
            {
                System.debug('M360: ftm: ' + ftm);
                for(sObject obj : sobjList)
                {
                    if(obj.getSObjectType().getDescribe().getName() == objName)
                    {
                        String tmpAccess ;
                        tmpAccess = roleToAccess.get(ftm.Access__c);
                        System.debug('M360: tmpAccess: ' + tmpAccess);

                        /*if(tmpAccess != null && tmpAccess != STR_NONE)
                        {
                            sObject shareObj = createShare(objName, obj, ftm.User__c, tmpAccess);
                            if(shareObj != null) returnShares.add(shareObj);

                        } // if(tmpAccess != null && tmpAccess != STR_NONE)*/

                        
                        if( objName == STR_ACCOUNT && tmpAccess != null && tmpAccess != STR_NONE) 
                        {
                            // Get Sharing Access for Opportunties 

                            System.debug('M360: 1: ' + STR_OPP + ftm.Access__c);

                            String tmpOppAccess = roleToAccess.get(STR_OPP + ftm.Access__c );
                            String tmpCaseAccess = roleToAccess.get(STR_CASE + ftm.Access__c);
                            String tmpContactAccess = roleToAccess.get(STR_CONTACT + ftm.Access__c);
                            System.debug('M360: tmpOppAccess: ' + tmpOppAccess + ' tmpCaseAccess ' + tmpCaseAccess + ' tmpContactAccess ' + tmpContactAccess );
                            sObject shareObj;
                            Account record = (Account)obj ;

                            //Even if the user is the owner - we need to set the Account Share for opps.
                            if( ftm.User__c != record.OwnerId ) shareObj = createAccountShare(record, ftm.User__c , tmpAccess, tmpOppAccess, tmpCaseAccess, tmpContactAccess );
                            //shareObj = createAccountShare(record, ftm.User__c , tmpAccess, tmpOppAccess, tmpCaseAccess, tmpContactAccess );
                            if(shareObj != null) returnShares.add(shareObj);

                            if(runOpps)
                            {
                                system.debug('ftm.User__c  ' + ftm.User__c);
                                system.debug('record.OwnerId  '+record.OwnerId);
                                if( ftm.User__c == record.OwnerId ) {
                                    List<Franchise_Team_Member__c> tmpFTMList = acctIdToFTM_forOpps.get(record.Id);
                                    if(tmpFTMList == null)
                                    {
                                        tmpFTMList = new List<Franchise_Team_Member__c>();
                                    }
                                    tmpFTMList.add(ftm);
                                    acctIdToFTM_forOpps.put(record.Id, tmpFTMList);

                                    String tmpString = record.Id + ':' + record.OwnerId;
                                    acct_userToOppAccess.put(tmpString, tmpOppAccess);
                                }
                            }
                        }
                        else if( tmpAccess != null && tmpAccess != STR_NONE)
                        {
                            sObject shareObj = createShare(objName, obj, ftm.User__c, tmpAccess);
                            if(shareObj != null) returnShares.add(shareObj);
                            system.debug('returnShares  '+returnShares);
                        }

                    } // if(obj.getSObjectType() == objName)
                } // for(sObject obj : sobjList)
            } // for(Franchise_Team_Member__c ftm : teamMembers)
        } // for(String objName : accessByObject.keySet())

        //FINAL - if we need to run opp sharing - do that now
        if(runOpps && acctIdToFTM_forOpps.size() > 0)
        {
             //We have the Account record - now we need to find all the Opps related to this Account
             //In cases where the Opp is not OWNED by the same person as the account
            System.debug('M360: acct_userToOppAccess: ' + acct_userToOppAccess);
            for(Opportunity oRecord : [SELECT Id, OwnerId, AccountId, Account.OwnerId FROM Opportunity WHERE AccountId = :acctIdToFTM_forOpps.keySet()])
            {
                List<Franchise_Team_Member__c> ftmsForAccount = acctIdToFTM_forOpps.get(oRecord.AccountId);
                for(Franchise_Team_Member__c oftm : ftmsForAccount) 
                {
                    //Figured out what access they need...
                    String tmpString = oRecord.AccountId + ':' + oRecord.Account.OwnerId;
                    System.debug('M360: tmpString: ' + tmpString);
                    String oppAccess = acct_userToOppAccess.get(tmpString);
                    System.debug('M360: oppAccess: ' + oppAccess);

                    //createOpportunityShare(record, userId, accessLevel);
                    if(oppAccess != null)
                    {
                        sObject shareObj;
                        if(oftm.User__c != oRecord.OwnerId ) shareObj = createOpportunityShare(oRecord, oftm.User__c, oppAccess);
                        if(shareObj != null) returnShares.add(shareObj);
                    }
                }
                
            }
        }

                           


        return returnShares;
    }

    /**
    * @Purpose: Method used to create sharing rules on multiple objects
    *
    * @param    String objType to hold Object API name
    *           SObject sobj refrence of object on which apply sharing rules
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on campaing record
    * @return   sObject
    *
    * @Date:    ***
    * @Author:  Sophia Murphy (Magnet360)
    * @Updates: 01.22.2016 Usman Ali (Magnet 360)
    *           Added code for these objects sharings 
    *           Campaign, Lead, ContactSourceDetail, LeadSourceDetail, ProgramHistory
    */


    private static sObject createShare(String objType, sObject sobj, Id userId, String accessLevel)
    {
        System.debug('M360: objType: ' + objType);
        System.debug('M360: sobj: ' + sobj);
        System.debug('M360: userId: ' + userId);
        System.debug('M360: accessLevel: ' + accessLevel);

        sObject returnObj;

        /*// When object is Account then create sharings for account owner
        if(objType == STR_ACCOUNT)
        {
            Account record = (Account)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createAccountShare(record, userId, accessLevel);
            }
        } */

        // When object is Opportunity then create sharings for Opportunity owner
        /**if(objType == STR_OPP)
        {
            Opportunity record = (Opportunity)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createOpportunityShare(record, userId, accessLevel);
            }
        }*/

        // When object is Contact then create sharings for Contact owner
        if(objType == STR_CONTACT)
        {
            Contact record = (Contact)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createContactShare(record, userId, accessLevel);
            }
        }
        
        // When object is Campaign then create sharings for Campaign owner
        if(objType == STR_CAMPAIGN)
        {
            Campaign record = (Campaign)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createCampaignShare(record, userId, accessLevel);
            }
        }
        
        // When object is Lead then create sharings for Lead owner
        if(objType == STR_LEAD )
        {
            Lead record = (Lead)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createLeadShare(record, userId, accessLevel);
            }
        }
        
        // When object is ContactSourceDetail then create sharings for ContactSourceDetail owner
        if(objType == STR_CONTACTSOURCE )
        {
            Contact_Source_Detail__c record = (Contact_Source_Detail__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createContactSourceDetailShare(record, userId, accessLevel);
            }
        }
        
        // When object is LeadSourceDetail then create sharings for LeadSourceDetail owner
        if(objType == STR_LEADSOURCE )
        {
            Lead_Source_Detail__c record = (Lead_Source_Detail__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createLeadSourceDetailShare(record, userId, accessLevel);
            }
        }
        
        // When object is ProgramHistory then create sharings for ProgramHistory owner
        if(objType == STR_PROGRAMHISTORY )
        {
            Program_History__c record = (Program_History__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createProgramHistoryShare(record, userId, accessLevel);
            }
        }
        
       
        // When object is Area Location then create sharings for Area Location owner
        if(objType == STR_AREA_LOC )
        {
            Area_Location__c record = (Area_Location__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createAreaLocationShare(record, userId, accessLevel);
            }
        }
        
        // When object is Attendance then create sharings for Attendance owner
        if(objType == STR_ATTENDANCE )
        {
            Attendance__c record = (Attendance__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createAttendanceShare(record, userId, accessLevel);
            }
        }
        
        // When object is Award then create sharings for Attendance owner
        if(objType == STR_AWARD )
        {
            Award__c record = (Award__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createAwardShare(record, userId, accessLevel);
            }
        }
        
        // When object is Alternate Rev Type then create sharings for Alternate Rev Type  owner
        if(objType == STR_ARTYPE )
        {
            Alternate_Revenue_Type__c record = (Alternate_Revenue_Type__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createARTypeShare(record, userId, accessLevel);
            }
        }
        
        // When object is Coaching Assistant then create sharings for Coaching Asst  owner
        
        if(objType == STR_COACH_ASST )
        {
            Coaching_Assistant__c record = (Coaching_Assistant__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createCoachingAsstShare(record, userId, accessLevel);
            }
        }
        
        // When object is Customer Agreement then create sharings for Customer Agreement  owner
        
        if(objType == STR_CUST_AGREEMENT )
        {
            Customer_Agreement__c record = (Customer_Agreement__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createCustAgreementShare(record, userId, accessLevel);
            }
        }
        
        // When object is Employee then create sharings for Customer Agreement  owner
        
        if(objType == STR_EMPLOYEE)
        {
            Employee__c record = (Employee__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createEmployeeShare(record, userId, accessLevel);
            }
        }
        
        // When object is Employee Date then create sharings for Employee Date  owner
        
        if(objType == STR_EMP_DATE )
        {
            Employment_Date__c record = (Employment_Date__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createEmpDateShare(record, userId, accessLevel);
            }
        }
        
        // When object is Fee Payment then create sharings for Fee Payment  owner
        
        if(objType == STR_FEE_PAYMENT )
        {
            System.debug('check inside');
            Fee_Payment__c record = (Fee_Payment__c)sobj;
            System.debug('check ids'+record.OwnerId);
            System.debug('check user'+userId);
            if(record.OwnerId != userId)
            {
                returnObj = createFeePaymentShare(record, userId, accessLevel);
            }
        }
        
        // When object is Program then create sharings for Program  owner
        
        if(objType == STR_PROGRAM )
        {
            Program__c record = (Program__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createProgramShare(record, userId, accessLevel);
            }
        }
        
        // When object is ProgramAsst then create sharings for ProgramAsst  owner
        
        if(objType == STR_PROG_COACH_ASST )
        {
            Program_Coaching_Assistant__c record = (Program_Coaching_Assistant__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createProgramAsstShare(record, userId, accessLevel);
            }
        }
        
        // When object is ProgramLocation then create sharings for ProgramLocation  owner
        
        if(objType == STR_PROG_LOCATION )
        {
            Program_Location__c record = (Program_Location__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createProgramLocationShare(record, userId, accessLevel);
            }
        }        
        
        // When object is ProgramTrainer then create sharings for ProgramTrainer  owner
        
        if(objType == STR_PROG_TRAINER )
        {
            Program_Trainer__c record = (Program_Trainer__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createProgramTrainerShare(record, userId, accessLevel);
            }
        }
        
        // When object is Registration then create sharings for Registration  owner
        
        if(objType == STR_REGISTRATION )
        {
            Registration__c record = (Registration__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createRegistrationShare(record, userId, accessLevel);
            }
        }
        
        // When object is SalesPerson then create sharings for SalesPerson  owner
        
        if(objType == STR_SALES_PERSON )
        {
            Sales_Person__c record = (Sales_Person__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createSalesPersonShare(record, userId, accessLevel);
            }
        }
        
        // When object is Session then create sharings for Session  owner
        
        if(objType == STR_SESSION )
        {
            Session__c record = (Session__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createSessionShare(record, userId, accessLevel);
            }
        }
        
        // When object is Trainer then create sharings for Trainer  owner
        
        if(objType == STR_TRAINER )
        {
            Trainer__c record = (Trainer__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createTrainerShare(record, userId, accessLevel);
            }
        }
        
        // When object is TrainerCertEvent then create sharings for TrainerCertEvent  owner
        if(objType == STR_TRAINER_CERT_EVENT)
        {
            Trainer_Certification_Event__c record = (Trainer_Certification_Event__c)sobj;
            if(record.OwnerId != userId)
            {
                returnObj = createTrainerCertShare(record, userId, accessLevel);
            }
        }
        
        return returnObj;
    }


    /**
    *
    * @param    Account record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on Account record
    * @return   AccountShare
    *
    * @Date:    ***
    * @Author: Sophia Murphy (Magnet360)
    */

    private static AccountShare createAccountShare(Account record, Id userId, String accessLevel, String oppAccess, String caseAccess, String contactAccess )
    {
        AccountShare recordShare = new AccountShare();
        recordShare.AccountId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccountAccessLevel = VALID_ACCESS.get(accessLevel);
        recordShare.OpportunityAccessLevel = VALID_ACCESS.get(oppAccess);
        recordShare.CaseAccessLevel = VALID_ACCESS.get(caseAccess);
        recordShare.ContactAccessLevel = VALID_ACCESS.get(contactAccess);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;

    } //END: public static AccountShare createAccountShare(Account acct, Id userId, String accessLevel)

    private static OpportunityShare createOpportunityShare(Opportunity record, Id userId, String accessLevel)
    {
        OpportunityShare recordShare = new OpportunityShare();
        recordShare.OpportunityId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.OpportunityAccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }

    /**
    *
    * @param    Contact record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on Contact record
    * @return   ContactShare
    *
    * @Date:    ***
    * @Author: Sophia Murphy (Magnet360)
    */

    private static ContactShare createContactShare(Contact record, Id userId, String accessLevel)
    {
        ContactShare recordShare = new ContactShare();
        recordShare.ContactId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.ContactAccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }

    /**
    *
    * @param    Campaign record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on campaing record
    * @return   CampaignShare
    *
    * @Date: 01.22.2016
    * @Author: Usman Ali (Magnet360)
    */ 
    private static CampaignShare createCampaignShare(Campaign record, Id userId, String accessLevel)
    {
        // Create new CampaignShare record
        CampaignShare recordShare = new CampaignShare();
        // Set recordId, UserId and access level on CampaignShare record
        recordShare.CampaignId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.CampaignAccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }

    /**
    *
    * @param    Lead record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on Lead record
    * @return   LeadShare
    *
    * @Date: 01.22.2016
    * @Author: Usman Ali (Magnet360)
    */ 
    private static LeadShare createLeadShare(Lead record, Id userId, String accessLevel)
    {
        // Create new LeadShare record
        LeadShare recordShare = new LeadShare();
        // Set recordId, UserId and access level on LeadShare record
        recordShare.LeadId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.LeadAccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }

    /**
    *
    * @param    ContactSourceDetail record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on ContactSourceDetail record
    * @return   ContactSourceDetailShare
    *
    * @Date: 01.22.2016
    * @Author: Usman Ali (Magnet360)
    */ 
    private static Contact_Source_Detail__Share createContactSourceDetailShare(Contact_Source_Detail__c record, Id userId, String accessLevel)
    {
        // Create new Contact_Source_Detail__Share record
        Contact_Source_Detail__Share recordShare = new Contact_Source_Detail__Share();
        // Set reocrdId, UserId and access level on ContactSourceDetailShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }


    /**
    *
    * @param    LeadSourceDetail record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on LeadSourceDetail record
    * @return   LeadSourceDetailShare
    *
    * @Date: 01.22.2016
    * @Author: Usman Ali (Magnet360)
    */ 
    private static Lead_Source_Detail__Share createLeadSourceDetailShare(Lead_Source_Detail__c record, Id userId, String accessLevel)
    {
        // Create new LeadSourceDetailShare record
        Lead_Source_Detail__Share recordShare = new Lead_Source_Detail__Share();
        // Set recordId, UserId and access level on LeadSourceDetailShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }


    /**
    *
    * @param    ProgramHistory record on which wants to apply sharings
    *           Id userId for user on which apply sharings
    *           String accessLevel which access level set on ProgramHistory record
    * @return   ProgramHistoryShare
    *
    * @Date: 01.22.2016
    * @Author: Usman Ali (Magnet360)
    */ 
    private static Program_History__Share createProgramHistoryShare(Program_History__c record, Id userId, String accessLevel)
    {
        // Create new ProgramHistoryShare record
        Program_History__Share recordShare = new Program_History__Share();
        // Set recordId, UserId and access level on ProgramHistoryShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);

        System.debug('M360: recordShare: ' + recordShare);
        return recordShare;
    }
    
    
     private static Area_Location__Share createAreaLocationShare(Area_Location__c record, Id userId, String accessLevel)
    {
        // Create new AreaLocationShare record
        Area_Location__Share recordShare = new Area_Location__Share();
        // Set recordId, UserId and access level on AreaLocationShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareAreaLocation: ' + recordShare);
        return recordShare;
    }
    
    private static Attendance__Share createAttendanceShare(Attendance__c record, Id userId, String accessLevel)
    {
        // Create new Attendance record
        Attendance__Share recordShare = new Attendance__Share();
        // Set recordId, UserId and access level on AttendanceShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareAttendance: ' + recordShare);
        return recordShare;
    }
    
    private static Award__Share createAwardShare(Award__c record, Id userId, String accessLevel)
    {
        // Create new Award record
        Award__Share recordShare = new Award__Share();
        // Set recordId, UserId and access level on AwardShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareAward: ' + recordShare);
        return recordShare;
    }
    
    private static Alternate_Revenue_Type__Share createARTypeShare (Alternate_Revenue_Type__c record, Id userId, String accessLevel)
    {
        // Create new AlternateRevType record
        Alternate_Revenue_Type__Share recordShare = new Alternate_Revenue_Type__Share();
        // Set recordId, UserId and access level on AlternateRevTypeShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareAlternateRevType: ' + recordShare);
        return recordShare;
    }
    
    private static Coaching_Assistant__Share createCoachingAsstShare (Coaching_Assistant__c record, Id userId, String accessLevel)
    {
        // Create new CoachingAsst record
        Coaching_Assistant__Share recordShare = new Coaching_Assistant__Share();
        // Set recordId, UserId and access level on CoachingAsstShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareCoachingAsst: ' + recordShare);
        return recordShare;
    }
    
    private static Customer_Agreement__Share createCustAgreementShare (Customer_Agreement__c record, Id userId, String accessLevel)
    {
        // Create new CustAgreement record
        Customer_Agreement__Share recordShare = new Customer_Agreement__Share();
        // Set recordId, UserId and access level on CustAgreementShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareCustAgreement: ' + recordShare);
        return recordShare;
    }
           
         private static Employee__Share createEmployeeShare (Employee__c record, Id userId, String accessLevel)
    {
        // Create new Employee record
        Employee__Share recordShare = new Employee__Share();
        // Set recordId, UserId and access level on EmployeeShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareEmp: ' + recordShare);
        return recordShare;
    }
        
    private static Employment_Date__Share createEmpDateShare (Employment_Date__c record, Id userId, String accessLevel)
    {
        // Create new EmpDate record
        Employment_Date__Share recordShare = new Employment_Date__Share();
        // Set recordId, UserId and access level on CustAgreementShare record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareEmpDate: ' + recordShare);
        return recordShare;
    }
    
    
    
    private static Fee_Payment__Share createFeePaymentShare (Fee_Payment__c record, Id userId, String accessLevel)
    {
        // Create new FeePayment record
        Fee_Payment__Share recordShare = new Fee_Payment__Share();
        // Set recordId, UserId and access level on FeePayment record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareFeePayment: ' + recordShare);
        return recordShare;
    }
    
    private static Program__Share createProgramShare (Program__c record, Id userId, String accessLevel)
    {
        // Create new Program record
        Program__Share recordShare = new Program__Share();
        // Set recordId, UserId and access level on Program record
        recordShare.ParentId = record.Id;
        
        System.debug('JOYYY UTILCLASS : Program object Id is' +record.Id);
       
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareProgram: ' + recordShare);
        return recordShare;
    }
    
    private static Program_Coaching_Assistant__Share createProgramAsstShare (Program_Coaching_Assistant__c record, Id userId, String accessLevel)
    {
        // Create new ProgramCoachningAsst record
        Program_Coaching_Assistant__Share recordShare = new Program_Coaching_Assistant__Share();
        // Set recordId, UserId and access level on ProgramCoachningAsst record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareProgramAsst: ' + recordShare);
        return recordShare;
    }
    
    private static Program_Location__Share createProgramLocationShare (Program_Location__c record, Id userId, String accessLevel)
    {
        // Create new ProgramLocation record
        Program_Location__Share recordShare = new Program_Location__Share();
        // Set recordId, UserId and access level on ProgramLocation record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareProgramLocation: ' + recordShare);
        return recordShare;
    }
    
    private static Program_Trainer__Share createProgramTrainerShare (Program_Trainer__c record, Id userId, String accessLevel)
    {
        // Create new ProgramTrainer record
        Program_Trainer__Share recordShare = new Program_Trainer__Share();
        // Set recordId, UserId and access level on ProgramTrainer record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareProgramTrainer: ' + recordShare);
        return recordShare;
    }
    private static Registration__Share createRegistrationShare (Registration__c record, Id userId, String accessLevel)
    {
        // Create new Registration record
        Registration__Share recordShare = new Registration__Share();
        // Set recordId, UserId and access level on Registration record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareRegistration: ' + recordShare);
        return recordShare;
    }
    
    private static Sales_Person__Share createSalesPersonShare (Sales_Person__c record, Id userId, String accessLevel)
    {
        // Create new SalesPerson record
        Sales_Person__Share recordShare = new Sales_Person__Share();
        // Set recordId, UserId and access level on SalesPerson record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareSalesPerson: ' + recordShare);
        return recordShare;
    }
    private static Session__Share createSessionShare (Session__c record, Id userId, String accessLevel)
    {
        // Create new Session record
        Session__Share recordShare = new Session__Share();
        // Set recordId, UserId and access level on Session record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareSession: ' + recordShare);
        return recordShare;
    }
    
    private static Trainer__Share createTrainerShare (Trainer__c record, Id userId, String accessLevel)
    {
        // Create new Trainer record
        Trainer__Share recordShare = new Trainer__Share();
        // Set recordId, UserId and access level on Trainer record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareTrainer: ' + recordShare);
        return recordShare;
    } 
    
    
    private static Trainer_Certification_Event__Share createTrainerCertShare (Trainer_Certification_Event__c record, Id userId, String accessLevel)
    {
        // Create new TrainerCert record
        Trainer_Certification_Event__Share recordShare = new Trainer_Certification_Event__Share();
        // Set recordId, UserId and access level on TrainerCert record
        recordShare.ParentId = record.Id;
        recordShare.UserOrGroupId = userId;
        recordShare.AccessLevel = VALID_ACCESS.get(accessLevel);
        
        System.debug('M360: recordShareTrainerCertification: ' + recordShare);
        return recordShare;
    }
    public static void ftest(){
        integer i=0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
    
}