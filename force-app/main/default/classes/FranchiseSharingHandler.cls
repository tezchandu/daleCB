/**
* Core handler for the FranchiseSharing logic
* 
* @Date: 01.06.2016
* @Author: Sophia Murphy (Magnet 360)
* 
* @Updates: Usman Ali (Magnet 360)
*           Code to delete sharing rules before inserting fresh records
* 02.09.2016    Sophia Murphy (Magnet 360)
*               Updated to without sharing, so items can run as Partner Users
*               Usman Ali (Magnet 360 )
*               Added new boolean parameter to ProcessSharing() method 
*/
public without sharing class FranchiseSharingHandler implements Queueable {
    
    /**
     * Called from AccountTrigger - BEFORE INSERT or UPDATE
     *
     * @param List<Account> acctList : Trigger.new
     * @return void : No return value
     *
     * @Date: 01.06.2016
     * @Author: Sophia Murphy (Magnet360)
     */
    public static void handleAccounts(List<Account> acctList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(acctList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<AccountShare> sharingRulesToDelete = [ SELECT Id 
                                                        FROM AccountShare 
                                  WHERE AccountId IN :recordList 
                                                        AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_ACCOUNT, true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleAccounts(List<Account> acctList)

    /**
     * Called from ContactTrigger - BEFORE INSERT or UPDATE
     *
     * @param List<Contact> contactList : Trigger.new
     * @return void : No return value
     *
     * @Date: 01.21.2016
     * @Author: Sophia Murphy (Magnet360)
     */
    public static void handleContacts(List<Contact> contactList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(contactList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<ContactShare> sharingRulesToDelete = [ SELECT Id 
                                                        FROM ContactShare 
                                                        WHERE ContactId IN :recordList 
                                                        AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_CONTACT, true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleContacts(List<Contact> contactList)


    /**
     * Called from CampaignTrigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Campaign> campaignList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   01.22.2016
     * @Author: Usman Ali (Magnet360)
     */
    public static void handleCampaigns(List<Campaign> campaignList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(campaignList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<CampaignShare> sharingRulesToDelete = [    SELECT Id 
                                                            FROM CampaignShare 
                                                            WHERE CampaignId IN :recordList 
                                                            AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_CAMPAIGN , true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleCampaigns(List<Campaign> campaignList)


    /**
     * Called from LeadTrigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Lead> leadList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   01.22.2016
     * @Author: Usman Ali (Magnet360)
     */
    public static void handleLeads(List<Lead> leadList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(leadList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<LeadShare> sharingRulesToDelete = [    SELECT Id 
                                                        FROM LeadShare 
                                                        WHERE LeadId IN :recordList 
                                                        AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_LEAD, true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleLeads(List<Lead> leadList)


    /**
     * Called from ContactSourceDetail Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Contact_Source_Detail__c> leadList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   01.22.2016
     * @Author: Usman Ali (Magnet360)
     */
    public static void handleContactSourceDetails(List<Contact_Source_Detail__c> csdList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(csdList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Contact_Source_Detail__Share> sharingRulesToDelete = [ SELECT Id 
                                                                        FROM Contact_Source_Detail__Share 
                                                                        WHERE ParentId IN :recordList 
                                                                        AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_CONTACTSOURCE, true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleContactSourceDetails(List<Contact_Source_Detail__c> csdList) 


    /**
     * Called from ContactSourceDetail Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Lead_Source_Detail__c> lsdList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   01.22.2016
     * @Author: Usman Ali (Magnet360)
     */
    public static void handleLeadSourceDetails(List<Lead_Source_Detail__c> lsdList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(lsdList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Lead_Source_Detail__Share> sharingRulesToDelete = [    SELECT Id 
                                                                        FROM Lead_Source_Detail__Share 
                                                                        WHERE ParentId IN :recordList 
                                                                        AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_LEADSOURCE , true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleLeadSourceDetails(List<Lead_Source_Detail__c> lsdList)


    /**
     * Called from ProgramHistory Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Program_History__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   01.22.2016
     * @Author: Usman Ali (Magnet360)
     */
    
    public static void handleProgramHistory(List<Program_History__c> phList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(phList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Program_History__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Program_History__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_PROGRAMHISTORY, true );

        } //END: if(handleMap.size() > 0)

    } //END: public static void handleProgramHistory(List<Program_History__c> phList)

   /**
     * Called from AreaLocationTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Area_Location__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */
    
     public static void handleAreaLocation(List<Area_Location__c> alList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(alList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Area_Location__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Area_Location__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_AREA_LOC, true );

        } //END: if(handleMap.size() > 0)

    }
    
     /**
     * Called from AttendanceTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Attendance__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */

      public static void handleAttendance(List<Attendance__c> attList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(attList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Attendance__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Attendance__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_ATTENDANCE, true );

        } //END: if(handleMap.size() > 0)

    }
    
     /**
     * Called from AwardTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Award__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */
    
         public static void handleAward(List<Award__c> awrdList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(awrdList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Award__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Award__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_AWARD, true );

        } //END: if(handleMap.size() > 0)

    }
  /**
     * Called from AlternateRevenueTypeTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Alternate_Revenue_Type__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */
     public static void handleAlternateRevenueType(List<Alternate_Revenue_Type__c> awrdList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(awrdList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Alternate_Revenue_Type__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Alternate_Revenue_Type__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_ARTYPE, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from CoachingAssistantTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Coaching_Assistant__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */
     public static void handleCoachingAsst(List<Coaching_Assistant__c> chgastList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(chgastList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Coaching_Assistant__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Coaching_Assistant__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_COACH_ASST, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from CustomerAgreementTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Customer_Agreement__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */    
    public static void handleCustomerAgreement(List<Customer_Agreement__c> custagList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(custagList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Customer_Agreement__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Customer_Agreement__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_CUST_AGREEMENT, true );

        } //END: if(handleMap.size() > 0)

    }
    
    /**
     * Called from EmployeeTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Employee__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */    
    public static void handleEmployee(List<Employee__c> emplist)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(emplist, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Employee__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Employee__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_EMPLOYEE, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from EmployeeDateTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Employment_Date__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */        
    public static void handleEmployeeDate(List<Employment_Date__c> edList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(edList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Employment_Date__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Employment_Date__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_EMP_DATE, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from feePaymentTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Fee_Payment__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */        
    public static void handleFeePayment(List<Fee_Payment__c> fpList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(fpList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Fee_Payment__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Fee_Payment__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_FEE_PAYMENT, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from ProgramTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Program__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */        
     public static void handleProgram(List<Program__c> proList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(proList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Program__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Program__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('JOYYYYYYYYYYYY: sharingRulesToDelete IN Program: ' + sharingRulesToDelete.size());
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_PROGRAM, true );

        } //END: if(handleMap.size() > 0)

    }
    public void execute(QueueableContext context) {
        
    }
 /**
     * Called from ProgramCoachingAssistantTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Program_Coaching_Assistant__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */     
    public static void handleProgCoachAsst(List<Program_Coaching_Assistant__c> progchList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(progchList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Program_Coaching_Assistant__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Program_Coaching_Assistant__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_PROG_COACH_ASST, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from ProgramLocationTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Program_Location__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */         
    public static void handleProgLocation(List<Program_Location__c> proglocList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(proglocList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Program_Location__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Program_Location__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_PROG_LOCATION, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from ProgramTrainerTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Program_Trainer__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */         
     public static void handleProgTrainer(List<Program_Trainer__c> ptList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(ptList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Program_Trainer__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Program_Trainer__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_PROG_TRAINER, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from RegistrationTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Registration__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */       
    public static void handleRegistration(List<Registration__c> regList)
    {
        Boolean isFirstTime = true;
        if(isFirstTime){
            isFirstTime = false;
            system.debug('regList  '+ regList);
        Map<String, List<sObject>> handleMap = buildHandleMap(regList, false);
            system.debug('handleMap.size()  '+ handleMap.size() );
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Registration__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Registration__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_REGISTRATION, true );

        } //END: if(handleMap.size() > 0)
        }
    }
/**
     * Called from SalesPersonTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Sales_Person__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */     
    public static void handleSalesPerson(List<Sales_Person__c> spList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(spList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Sales_Person__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Sales_Person__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_SALES_PERSON, true );

        } //END: if(handleMap.size() > 0)

    }
/**
     * Called from SessionTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Session__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */    
    
     public static void handleSession(List<Session__c> sessionList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(sessionList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Session__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Session__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            System.debug('JOY :' +Session__Share.ParentId);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_SESSION, true );

        } //END: if(handleMap.size() > 0)

    }
 /**
     * Called from TrainerTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Trainer__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */      
     
    /*public static void handleTrainer(List<Trainer__c> trainerList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(trainerList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Trainer__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Trainer__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_TRAINER, true );

        } //END: if(handleMap.size() > 0)

    }*/
 /**
     * Called from TrainerCertificationTrigger Trigger - BEFORE INSERT or UPDATE
     *
     * @param   List<Trainer_Certification_Event__c> phList : Trigger.new
     * @return  void : No return value
     *
     * @Date:   26-07-2023
     * @Author: Joylin Karupalli (SpringML)
     */      
      public static void handleTrainerCertification(List<Trainer_Certification_Event__c> tcList)
    {
        Map<String, List<sObject>> handleMap = buildHandleMap(tcList, false);
        if(handleMap.size() > 0)
        {
            List<sObject> recordList = buildRecordList(handleMap);

            // Delete All existing manual sharingRules 
            List<Trainer_Certification_Event__Share> sharingRulesToDelete = [   SELECT Id 
                                                                    FROM Trainer_Certification_Event__Share 
                                                                    WHERE ParentId IN :recordList 
                                                                    AND RowCause = :FranchiseSharingUtil.STR_MANUAL ] ;
            System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
            
            if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
            
            processSharing(handleMap, FranchiseSharingUtil.STR_TRAINER_CERT_EVENT, true );

        } //END: if(handleMap.size() > 0)

    }
     
    private static List<sObject> buildRecordList(Map<String, List<sObject>> handleMap)
    {
        //Get a list of all the records that need their sharing rules cleared out
        List<sObject> returnRecords = new List<sObject>();
        for(List<sObject> sobjList : handleMap.values())
        {
            returnRecords.addAll(sobjList);
        }
        return returnRecords;
    }

    //Assume every object that's passed in here 
    //has a field called "Process_Sharing__c"
    //and a field called "Franchise_ID__c"
    public static Map<String, List<sObject>> buildHandleMap(List<sObject> objList, Boolean bypassProcessSharing)
    {
        //Create a list of sObjects, only if "Process_Sharing__c" is checked
        //Add that list to a map with the Franchise ID as the key
        //The list of sObjects is sent to the processSharing method

        Map<String, List<sObject>> returnMap = new Map<String, List<sObject>>();
        for(sObject so : objList)
        {
            system.debug('so.get("Process_Sharing__c")  '+ so.get('Process_Sharing__c'));
            //if(so.Process_Sharing__c == true)
            if(so.get('Process_Sharing__c') == true || bypassProcessSharing)
            {
                //String franchiseID = so.Franchise_ID__c;
                String franchiseID = String.valueOf(so.get('Franchise_ID__c'));
                List<sObject> tmpList = returnMap.get(franchiseID);
                if(tmpList == null)
                {
                    tmpList = new List<sObject>();
                }
                tmpList.add(so);
                returnMap.put(franchiseID, tmpList);
                //Reset process sharing.  Since this is called from a BEFORE
                //trigger we don't need to re-update
                //so.Process_Sharing__c = false;
                so.put('Process_Sharing__c', false);
            }
        }
        return returnMap;
    }

    //This method can be used for ALL objects!
    public static List<SObject> processSharing(Map<String, List<sObject>> processMap, String objName, Boolean doInsert )
    {
        //The processMap contains all the necessary Franchise IDs in the keyset.
        //Query for all the Franchise Object Access FOA records
        //  and all the Franchise Team Members FTM records
        List<Franchise_Object_Access__c> foaList = new List<Franchise_Object_Access__c>();

        System.debug('M360: processMap.keySet(): ' + processMap.keySet());
        System.debug('M360: objName: ' + objName);
        String objectLabel = FranchiseSharingUtil.apiNamesToLabelObjects.get(objName);
        System.debug('M360: objectLabel: ' + objectLabel);

        if(objectLabel == '' || objectLabel == null )
        {
            foaList = ([SELECT  Id, Admin_Access__c, Franchise_ID__c, Franchise_ID__r.Name, Manager_Access__c, Object_Name__c, Sales_Access__c ,
                                Opp_Admin_Access__c, Opp_Manager_Access__c, Opp_Sales_Access__c,
                                Case_Admin_Access__c, Case_Manager_Access__c, Case_Sales_Access__c,
                                Contact_Admin_Access__c, Contact_Manager_Access__c, Contact_Sales_Access__c
                        FROM Franchise_Object_Access__c
                        WHERE Franchise_ID__r.Name IN :processMap.keySet()]);
        } else {
            foaList = ([SELECT  Id, Admin_Access__c, Franchise_ID__c, Franchise_ID__r.Name, Manager_Access__c, Object_Name__c, Sales_Access__c ,
                                Opp_Admin_Access__c, Opp_Manager_Access__c, Opp_Sales_Access__c,
                                Case_Admin_Access__c, Case_Manager_Access__c, Case_Sales_Access__c,
                                Contact_Admin_Access__c, Contact_Manager_Access__c, Contact_Sales_Access__c
                        FROM Franchise_Object_Access__c
                        WHERE Franchise_ID__r.Name IN :processMap.keySet()
                        AND Object_Name__c = :objectLabel]);
        }

        System.debug('M360: foaList: ' + foaList);

        Map<String, Map<String, Franchise_Object_Access__c>> franchiseToAccess = new Map<String, Map<String, Franchise_Object_Access__c>>();
        for(Franchise_Object_Access__c foa : foaList)
        {
            String franchiseID = foa.Franchise_ID__r.Name;
            Map<String, Franchise_Object_Access__c> tmpMap = franchiseToAccess.get(franchiseID);
            if(tmpMap == null)
            {
                tmpMap = new Map<String, Franchise_Object_Access__c>();
            }
            String objAPIName = FranchiseSharingUtil.labelToAPINamesObjects.get(foa.Object_Name__c) ;
            tmpMap.put(objAPIName, foa);
            franchiseToAccess.put(franchiseID, tmpMap);
        }
        System.debug('M360: franchiseToAccess: ' + franchiseToAccess);

        Map<String, List<Franchise_Team_Member__c>> franchiseToUsers = new Map<String, List<Franchise_Team_Member__c>>();
        for(Franchise_Team_Member__c ftm : [SELECT Id, Access__c
                                        , Franchise_ID__c, User__c 
                                        , Franchise_ID__r.Name
                                    FROM Franchise_Team_Member__c
                                    WHERE Franchise_ID__r.Name IN :processMap.keySet()
                                    AND User__r.IsActive = true])
        {
            system.debug('ftm   '+ ftm);
            String franchiseID = ftm.Franchise_ID__r.Name;
            List<Franchise_Team_Member__c> tmpList = franchiseToUsers.get(franchiseID);
            if(tmpList == null)
            {
                tmpList = new List<Franchise_Team_Member__c>();
            }
            tmpList.add(ftm);
            franchiseToUsers.put(franchiseID, tmpList);
        }
        system.debug('franchiseToUsers  '+franchiseToUsers);

        //Now - loop through the process Map....
        List<sObject> sharingRulesForInsert = new List<sObject>();
        for(String franchiseID : processMap.keySet())
        {
            //These are all the sobjects we need to populate sharing rules too...
            List<sObject> sobjList = processMap.get(franchiseID);

            //These are the access levels per object...
            Map<String, Franchise_Object_Access__c> accessByObject = franchiseToAccess.get(franchiseID);

            //These are the users to give access to the sObjects....
            List<Franchise_Team_Member__c> teamMembers = franchiseToUsers.get(franchiseID);

            system.debug('teamMembers ' + teamMembers);
            Boolean doContinue = true;
            system.debug('M360: sobjList: ' + sobjList);
            if(sobjList == null || sobjList.size() <= 0)
            {
                doContinue = false;
            }

            system.debug('M360: accessByObject: ' + accessByObject);
            if(accessByObject == null || accessByObject.size() <= 0)
            {
                doContinue = false;
            }

            system.debug('M360: teamMembers: ' + teamMembers);  
            if(teamMembers == null || teamMembers.size() <= 0)
            {
                doContinue = false;
            }       

            //We have the objects... we have the accessByObject... and the users...
            if(doContinue)
            {
                sharingRulesForInsert.addAll(FranchiseSharingUtil.createShares(sobjList, accessByObject, teamMembers));
            }
        } //END: for(String franchiseID : processMap.keySet())

        //system.debug('M360: sharingRulesForInsert: ' + sharingRulesForInsert);
        
        //BECAUSE OF THIS ERROR - We need to split the SHARES
        //System.TypeException: Cannot have more than 10 chunks in a single operation. Please rearrange the data to reduce chunking
        if(sharingRulesForInsert.size() > 0)
        {
            List<sObject> accountShares =  new List<SObject>();
            List<sObject> contactShares =  new List<SObject>();
            List<sObject> campaignShares = new List<SObject>();
            List<sObject> leadShares =     new List<SObject>();
            List<sObject> csdetailShares = new List<SObject>();
            List<sObject> lsdetailShares = new List<SObject>();
            List<sObject> pHistoryShares = new List<SObject>();
            List<sObject> abcShares = new List<SObject>();
            List<sObject> arealocationShares = new List<SObject>();
            List<sObject> attendanceShares = new List<SObject>();
            List<sObject> awardShares = new List<SObject>();
            List<sObject> alternateRevTypeShares = new List<SObject>();
            List<sObject> coachingasstShares = new List<SObject>();
            List<sObject> custAgreementShares = new List<SObject>();
            List<sObject> empShares = new List<SObject>();
            List<sObject> empDateShares = new List<SObject>();
            List<sObject> feePaymentShares = new List<SObject>();
            List<sObject> programShares = new List<SObject>();
            List<sObject> progCoachAsstShares = new List<SObject>();
            List<sObject> progLocationShares = new List<SObject>();
            List<sObject> progTrainerShares = new List<SObject>();
            List<sObject> registrationShares = new List<SObject>();
            List<sObject> salesPersonShares = new List<SObject>();
            List<sObject> sessionShares = new List<SObject>();
            List<sObject> trainerShares = new List<SObject>();
            List<sObject> trainerCertificationEvntShares = new List<SObject>();

            for( SObject so : sharingRulesForInsert )
            {
                Schema.SObjectType objectType = so.getSObjectType();
                if( objectType == AccountShare.getSobjectType() )
                {
                    accountShares.add(so);
                } 
                if( objectType == ContactShare.getSobjectType() )
                {
                    contactShares.add(so);
                } 
                if( objectType == CampaignShare.getSobjectType() )
                {
                    campaignShares.add(so);
                } 
                if( objectType == LeadShare.getSobjectType() )
                {
                    leadShares.add(so);
                } 
                if( objectType == Contact_Source_Detail__Share.getSobjectType() )
                {
                    csdetailShares.add(so);
                } 
                if( objectType == Lead_Source_Detail__Share.getSobjectType() )
                {
                    lsdetailShares.add(so);
                }  
                if( objectType == Program_History__Share.getSobjectType() )
                {
                    pHistoryShares.add(so);
                } 
                if( objectType == Area_Location__Share.getSobjectType() )
                {
                    arealocationShares.add(so);
                }
                if( objectType == Attendance__Share.getSobjectType() )
                {
                    attendanceShares.add(so);
                }
                if( objectType == Alternate_Revenue_Type__Share.getSobjectType() )
                {
                    alternateRevTypeShares.add(so);
                }
                if( objectType == Award__Share.getSobjectType() )
                {
                    awardShares.add(so);
                }
                if( objectType == Coaching_Assistant__Share.getSobjectType() )
                {
                    coachingasstShares.add(so);
                }
                if( objectType == Customer_Agreement__Share.getSobjectType() )
                {
                    custAgreementShares.add(so);
                }
                
                if( objectType == Employee__Share.getSobjectType() )
                {
                    empShares.add(so);
                }
                if( objectType == Employment_Date__Share.getSobjectType() )
                {
                    empDateShares.add(so);
                }
                if( objectType == Fee_Payment__Share.getSobjectType() )
                {
                    feePaymentShares.add(so);
                }
                if( objectType == Program__Share.getSobjectType() )
                {
                    programShares.add(so);
                    System.debug('programs is shared with' +so);
                    System.debug('program records are ' +programShares.size());
                    
                }
                if( objectType == Program_Coaching_Assistant__Share.getSobjectType() )
                {
                    progCoachAsstShares.add(so);
                }
                if( objectType == Program_Location__Share.getSobjectType() )
                {
                    progLocationShares.add(so);
                }
                if( objectType == Program_Trainer__Share.getSobjectType() )
                {
                    progTrainerShares.add(so);
                }
                if( objectType == Registration__Share.getSobjectType() )
                {
                    registrationShares.add(so);
                }
                system.debug('registrationShares  ' +registrationShares);
                if( objectType == Sales_Person__Share.getSobjectType() )
                {
                    salesPersonShares.add(so);
                }
                if( objectType == Session__Share.getSobjectType() )
                {
                    sessionShares.add(so);
                }
                 if( objectType == Trainer__Share.getSobjectType() )
                {
                    trainerShares.add(so);
                }
                 if( objectType == Trainer_Certification_Event__Share.getSobjectType() )
                {
                    trainerCertificationEvntShares.add(so);
                }
            }
            
            System.debug('M360: accountShares ' + accountShares.size() );
            System.debug('M360: contactShares ' + contactShares.size() );
            System.debug('M360: campaignShares ' + campaignShares.size() );
            System.debug('M360: leadShares ' + leadShares.size() );
            System.debug('M360: csdetailShares ' + csdetailShares.size() );
            System.debug('M360: lsdetailShares ' + lsdetailShares.size() );
            System.debug('M360: pHistoryShares ' + pHistoryShares.size() );

            if( doInsert && accountShares.size() > 0 ) insert accountShares ; 
            if( doInsert && contactShares.size() > 0 ) insert contactShares ; 
            if( doInsert && campaignShares.size() > 0 ) insert campaignShares ; 
            if( doInsert && leadShares.size() > 0 ) insert leadShares ; 
            if( doInsert && csdetailShares.size() > 0 ) insert csdetailShares ; 
            if( doInsert && lsdetailShares.size() > 0 ) insert lsdetailShares ; 
            if( doInsert && pHistoryShares.size() > 0 ) insert pHistoryShares ;
            if( doInsert && arealocationShares.size() > 0 ) insert arealocationShares ; 
            if( doInsert && attendanceShares.size() > 0 ) insert attendanceShares ; 
            if( doInsert && awardShares.size() > 0 ) insert awardShares ; 
            if( doInsert && alternateRevTypeShares.size() > 0 ) insert alternateRevTypeShares ; 
            if( doInsert && coachingasstShares.size() > 0 ) insert coachingasstShares ; 
            if( doInsert && custAgreementShares.size() > 0 ) insert custAgreementShares ; 
            if( doInsert && empShares.size() > 0 ) insert empShares ; 
            if( doInsert && empDateShares.size() > 0 ) insert empDateShares ; 
            if( doInsert && feePaymentShares.size() > 0 ) insert feePaymentShares ; 
            if( doInsert && programShares.size() > 0 ) insert programShares ; 
            if( doInsert && progCoachAsstShares.size() > 0 ) insert progCoachAsstShares ; 
            if( doInsert && progLocationShares.size() > 0 ) insert progLocationShares ; 
            if( doInsert && progTrainerShares.size() > 0 ) insert progTrainerShares ; 
            system.debug('registrationShares  '+ registrationShares);
            system.debug('registrationShares.size()' + registrationShares.size());
            if( doInsert && registrationShares.size() > 0 )
               // database.insert (registrationShares,false);
                for(sObject s:registrationShares ){
                    system.debug('s  '+ s);
                     insert s;
                    system.debug('safter  '+ s.id);
                }
                //insert registrationShares ; 
        
            if( doInsert && salesPersonShares.size() > 0 ) insert salesPersonShares ; 
            if( doInsert && sessionShares.size() > 0 ) insert sessionShares ; 
            if( doInsert && trainerShares.size() > 0 ) insert trainerShares ;
            if( doInsert && trainerCertificationEvntShares.size() > 0 ) insert trainerCertificationEvntShares ;

            //insert sharingRulesForInsert;
        }
        
        /**if( doInsert ) 
        {
            sharingRulesForInsert.sort();
            insert sharingRulesForInsert ; 
        }
		*/
        return sharingRulesForInsert ; 

    } //END: private static void processSharing(Map<String, List<sObject>> processMap, String objName)
}