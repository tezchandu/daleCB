/**
     * Contorller for page ApplyProcessSharingRules
     *
     * @Date:       01.14.2016
     * @Author:     Usman Ali (Magnet360)
     * @Updates:    Usman Ali (Magnet360)
     *              01.21.2016
     *              Added code to process these objects sharing rules 
     *              Campaign, Lead, ContactSourceDetail, LeadSourceDetail, ProgramHistory
     *              Usman Ali (Magnet360)
     *              02.12.2016
     *              Add batch job inteface to process so many records becuase it was hit limit of DML rows of 10000
     */

public with sharing class ApplyProcessSharingRulesController 
{
    public Id ftId ; 
    Set<Id> jobIds ; 
    public List<AsyncApexJob> jobs {get; set; }
   
    public ApplyProcessSharingRulesController( ApexPages.StandardController sc ) {
        ftId = sc.getId() ;
        jobIds = new Set<Id>();
        jobs = new List<AsyncApexJob>(); 
    }

    public PageReference apply()
    {
        PageReference pr = null; // new PageReference('/' + ftId ) ;
        Set<String> franchiseIds = new Set<String>(); 

        // Get all FranchiseTeam records where process sharing true
        List<Franchise_Team__c> ftList = [ SELECT Id, Name FROM Franchise_Team__c WHERE Process_Sharing__c = true ];
        System.debug('M360: ftList: ' + ftList ) ;

        // When FT records found
        if( ftList.size() > 0 )
        {   
            // Get franchise Ids
            for( Franchise_Team__c ft : ftList )
            {
                franchiseIds.add(ft.Name);
                ft.Process_Sharing__c = false ; 
            }

            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_ACCOUNT) , 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_CONTACT) , 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_CAMPAIGN), 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_LEAD) , 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_CONTACTSOURCE ), 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_LEADSOURCE ) , 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_PROGRAMHISTORY ), 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_AREA_LOC ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_ATTENDANCE ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_AWARD ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_ARTYPE ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_COACH_ASST ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_CUST_AGREEMENT ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_EMPLOYEE ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_EMP_DATE ), 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_FEE_PAYMENT ), 25 )); 
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_PROGRAM ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_PROG_COACH_ASST ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_PROG_LOCATION ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_PROG_TRAINER ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_REGISTRATION ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_SALES_PERSON ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_SESSION ), 25 ));
             jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_TRAINER ), 25 ));
            jobIds.add( Database.executeBatch(new ApplySharingRulesBatch(franchiseIds, FranchiseSharingUtil.STR_TRAINER_CERT_EVENT ), 25 ));

            update ftList ;

            /*
            // Get all Accounts, Contacts, Campaigns, Leads, ContactSourceDetails, LeadSourceDetails and ProgramHistory related to frachiseIds 
            List<sObject> accounts = [ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Account WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> contacts = [ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Contact WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> campaigns =[ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Campaign WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> leads    = [ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Lead WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> csdetails =[ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Contact_Source_Detail__c WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> lsdetails =[ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Lead_Source_Detail__c WHERE Franchise_ID__c IN :franchiseIds ] ;
            List<sObject> pHistories=[ SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM Program_History__c WHERE Franchise_ID__c IN :franchiseIds ] ;
            
            System.debug('M360: accounts: ' + accounts );
            System.debug('M360: contacts: ' + contacts );
            System.debug('M360: campaigns: ' + campaigns );
            System.debug('M360: leads: ' + leads );
            System.debug('M360: csdetails: ' + csdetails );
            System.debug('M360: lsdetails: ' + lsdetails );
            System.debug('M360: pHistories: ' + pHistories );

            List<sObject> allsObjects = new List<sObject>();
            allsObjects.addAll(accounts);
            allsObjects.addAll(contacts);
            allsObjects.addAll(campaigns);
            allsObjects.addAll(leads);
            allsObjects.addAll(csdetails);
            allsObjects.addAll(lsdetails);
            allsObjects.addAll(pHistories);

            System.debug('M360: allsObjects: ' + allsObjects );

            // Get all seven objects sharing rules which was created manually
            List<sObject> accountShares =  [ SELECT Id FROM AccountShare WHERE AccountId IN :accounts AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> contactShares =  [ SELECT Id FROM ContactShare WHERE ContactId IN :contacts AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> campaignShares = [ SELECT Id FROM CampaignShare WHERE CampaignId IN :campaigns AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> leadShares =     [ SELECT Id FROM LeadShare WHERE LeadId IN :leads AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> csdetailShares = [ SELECT Id FROM Contact_Source_Detail__Share WHERE ParentId IN :csdetails AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> lsdetailShares = [ SELECT Id FROM Lead_Source_Detail__Share WHERE ParentId IN :lsdetails AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            List<sObject> pHistoryShares = [ SELECT Id FROM Program_History__Share WHERE ParentId IN :pHistories AND RowCause = :FranchiseSharingUtil.STR_MANUAL] ;
            
            // Delete all existing sharing rules
            List<sObject> sharingRulesToDelete = new List<sObject>();
            sharingRulesToDelete.addAll(accountShares);
            sharingRulesToDelete.addAll(contactShares);
            sharingRulesToDelete.addAll(campaignShares);
            sharingRulesToDelete.addAll(leadShares);
            sharingRulesToDelete.addAll(csdetailShares);
            sharingRulesToDelete.addAll(lsdetailShares);
            sharingRulesToDelete.addAll(pHistoryShares);
    
            System.debug('M360: accountShares ' + accountShares.size() );
            System.debug('M360: contactShares ' + contactShares.size() );
            System.debug('M360: campaignShares ' + campaignShares.size() );
            System.debug('M360: leadShares ' + leadShares.size() );
            System.debug('M360: csdetailShares ' + csdetailShares.size() );
            System.debug('M360: lsdetailShares ' + lsdetailShares.size() );
            System.debug('M360: pHistoryShares ' + pHistoryShares.size() );

            if( accountShares.size() > 0 ) delete accountShares ; 
            if( contactShares.size() > 0 ) delete contactShares ; 
            if( campaignShares.size() > 0 ) delete campaignShares ; 
            if( leadShares.size() > 0 ) delete leadShares ; 
            if( csdetailShares.size() > 0 ) delete csdetailShares ; 
            if( lsdetailShares.size() > 0 ) delete lsdetailShares ; 
            if( pHistoryShares.size() > 0 ) delete pHistoryShares ; 

            //if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 

            // Process for new sharing rules on all seven objects 
            Map<String, List<sObject>> handleMap = FranchiseSharingHandler.buildHandleMap(allsObjects, true);
            System.debug('M360: handleMap: ' + handleMap );
            FranchiseSharingHandler.processSharing(handleMap, '', true);*/

            /*
            if( accounts.size() > 0 )
            {
            
                // Set ProcessSharing to True and update, Account trigger will apply sharing rules
                for( Account a : accounts )
                {
                    String franchiseID = a.Franchise_ID__c ;
                    List<sObject> tmpList = handleMap.get(franchiseID);
                    if(tmpList == null)
                    {
                        tmpList = new List<sObject>();
                    }
                    tmpList.add(a);
                    handleMap.put(franchiseID, tmpList);
                }

                if(handleMap.size() > 0)
                {
                    // Delete All existing manual sharingRules 
                    List<AccountShare> sharingRulesToDelete = [ SELECT Id FROM AccountShare WHERE AccountId IN :accounts AND RowCause = 'Manual' ] ;
                    System.debug('M360: sharingRulesToDelete: ' + sharingRulesToDelete);
                    if( sharingRulesToDelete.size() > 0 ) delete sharingRulesToDelete ; 
                    FranchiseSharingHandler.processSharing(handleMap, FranchiseSharingUtil.STR_ACCOUNT);
                }
            } 
            */
            
        }
        return pr ; 
    }

    public PageReference checkStatus()
    {
        Boolean isProcessedAll = true ; 
        PageReference pr  = null ;
        jobs = [    SELECT Id, JobType, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                    FROM AsyncApexJob WHERE ID IN :jobIds ];
        for( AsyncApexJob job : jobs )
        {
            if( job.Status != 'Completed' ) isProcessedAll = false; 
        }

        if( isProcessedAll ) pr = new PageReference('/' + ftId ) ;
        return pr ; 
    }
}