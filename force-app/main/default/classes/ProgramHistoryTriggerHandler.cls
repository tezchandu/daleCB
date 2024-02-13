/**
* ProgramHistoryTriggerHandler - Handler class for ProgramHistoryTrigger
* 
* @Date:    10.31.2016
* @Author:  Usman Ali (Magnet 360)
* @Jira:    MSP-1142
* 
* @Updates: 
* 12.05.2016	Sophia Murphy (Magnet 360)
*				Updated to only include those with Exit Type = Graduate
*/


public with sharing class ProgramHistoryTriggerHandler 
{
	/**
	* Check checkbox on Contact when A program history record created
	* Called from ProgramHistoryTriggerHandler trigger
	* 
	* @param 	 Programs List on new Program History records
	* @Return : No Return value
	* @Author:  Usman Ali (Magnet 360)
	* @Date:    10.31.2016
	* 
	* @Updates: 
	*/
    public static void updateContact( List<Program_History__c> programs ) 
    {
    	List<Contact> contacts = new List<Contact>();
    	Set<Id> contactIds = new Set<Id>();

    	// Iteratve over ProgramHistory records and get contact Ids
        for( Program_History__c ph : programs )
        {
        	if( ph.Contact__c != null && ph.Exit_Type__c == 'Graduate') contactIds.add(ph.Contact__c);
        }
        System.debug('UAC: contactIds ' + contactIds);

        // No need to process when no contactId found
        if( contactIds.size() == 0 ) return ;

        // Create a list of Contact and upate them
        for( Id contactId : contactIds )
        {
        	contacts.add( new Contact( Id = contactId, Previous_Dale_Grad__c = true ) ) ;
        } 
        update contacts ; 
    }
}