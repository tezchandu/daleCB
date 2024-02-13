/**
* Batch job to process sharing rules, it called froom ApplyProcessSharingRulesController
* 
* @Date: 	02.12.2016
* @Author: 	Usman Ali (Magnet 360)
* 
*/
global class ApplySharingRulesBatch implements Database.Batchable<sObject> 
{
	// Instance variables
    public String query;
    public Set<String> franchiseIds ;
    public String objName ; 

    // Map for objects to hold where clause to use in dynamic query
    public Map<String,String> whereClauseMap 
    { 	get 
    	{
			if( whereClauseMap == null )
			{
				whereClauseMap = new Map<String,String>();
				whereClauseMap.put( FranchiseSharingUtil.STR_ACCOUNT, 'AccountShare WHERE AccountId');
				whereClauseMap.put( FranchiseSharingUtil.STR_CONTACT , 'ContactShare WHERE ContactId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_CAMPAIGN , 'CampaignShare WHERE CampaignId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_LEAD , 'LeadShare WHERE LeadId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_CONTACTSOURCE, 'Contact_Source_Detail__Share WHERE ParentId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_LEADSOURCE, 'Lead_Source_Detail__Share WHERE ParentId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_PROGRAMHISTORY, 'Program_History__Share WHERE ParentId' ); 
                whereClauseMap.put( FranchiseSharingUtil.STR_AREA_LOC, 'Area_Location__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_ATTENDANCE, 'Attendance__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_AWARD, 'Award__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_ARTYPE, 'Alternate_Revenue_Type__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_COACH_ASST, 'Coaching_Assistant__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_CUST_AGREEMENT, 'Customer_Agreement__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_EMPLOYEE, 'Employee__Share WHERE ParentId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_EMP_DATE, 'Employment_Date__Share WHERE ParentId' );
				whereClauseMap.put( FranchiseSharingUtil.STR_FEE_PAYMENT, 'Fee_Payment__Share WHERE ParentId' ); 
				whereClauseMap.put( FranchiseSharingUtil.STR_PROGRAM, 'Program__Share WHERE ParentId' );  
               whereClauseMap.put( FranchiseSharingUtil.STR_PROG_COACH_ASST, 'Program_Coaching_Assistant__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_PROG_LOCATION, 'Program_Location__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_PROG_TRAINER, 'Program_Trainer__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_REGISTRATION, 'Registration__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_SALES_PERSON, 'Sales_Person__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_SESSION, 'Session__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_TRAINER, 'Trainer__Share WHERE ParentId' );
                whereClauseMap.put( FranchiseSharingUtil.STR_TRAINER_CERT_EVENT, 'Trainer_Certification_Event__Share WHERE ParentId' ); 
			} 
			return whereClauseMap;
		}
		private set; 
    } 

    // Constructor of class
    global ApplySharingRulesBatch( Set<String> franchiseIds, String objName ) 
    {
    	this.franchiseIds = franchiseIds ;
    	this.objName = objName ; 
       

    	// Make dynamic query for passing object 
    	this.query = 'SELECT Id, Process_Sharing__c, Franchise_ID__c, OwnerId FROM ' + objName + ' WHERE Franchise_ID__c IN :franchiseIds' ;
    	System.debug('UAC: objName ' + objName + ' franchiseIds ' + franchiseIds );
    	System.debug('UAC: query '+ query);
    }
    
    // Start method 
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
    	return Database.getQueryLocator(query);
    }
    
    // Execute method
    global void execute(Database.BatchableContext BC, list<Sobject> scope) 
    {
    	System.debug('UAC: scope' + scope );
    	
    	// Make query for Sharings of passing object 
    	String deleteQuery = 'SELECT Id FROM ' + whereClauseMap.get(objName) + ' IN :scope AND RowCause = \'' + FranchiseSharingUtil.STR_MANUAL + '\'' ;
    	// Get Sharings records of passing object 
    	List<sObject> sharingToDelete = Database.query(deleteQuery); 
    	System.debug('UAC: sharingToDelete ' + sharingToDelete.size()  );
    	// Delete existing sharing records 
    	if( sharingToDelete.size() > 0 ) delete sharingToDelete ;

    	// Process for new sharing rules 
        Map<String, List<sObject>> handleMap = FranchiseSharingHandler.buildHandleMap(scope, true);
        // Get sharingRulesToInsert by passing hanldeMap, objectName and false( which means don't need to insert )
        List<sObject> sharingRulesToInsert = FranchiseSharingHandler.processSharing(handleMap, objName, false ); 
        // Insert new sharing rules 
        if( sharingRulesToInsert.size() > 0 ) insert sharingRulesToInsert ;
        System.debug('UAC: sharingRulesToInsert ' + sharingRulesToInsert.size() );

    }

    global void finish(Database.BatchableContext BC) 
    {
    	System.debug('Batch job finished') ;
    }
}