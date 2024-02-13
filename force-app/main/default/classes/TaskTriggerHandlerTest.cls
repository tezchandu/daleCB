/******************************************************************************
 * Name:		TaskTriggerHandlerTest
 * 
 * Purpose:		Tests against the TaskTriggerHandler Class & Triggers on Task object
 * 				and provides code coverage.
 * 				
 * @Author: 	Abdul Sattar (Magnet360)
 * @Date: 		08.27.2015
 * 
 * @Updates:
 */
@isTest
private class TaskTriggerHandlerTest {
	
    private static Integer NUM_OF_RECORDS = 10;	// Number of records to test

	// Tests against TaskTriggerHandler.setTasksPublic()
    private static testMethod void setTasksPublicTest () {
        //Added to associated task to a Lead
        List<Lead> ldList = new List<Lead>();
        Lead ldObj = new Lead();
        ldObj.LastName= 'Chris Test Lead';
        ldObj.Company = 'Chris Company test';
        ldObj.LeadSource = 'Cold Call';
        ldObj.Email = 'Chris.Test@abc.com';
        
        Insert ldObj;
    	
    	// Create test tasks
    	List<Task> tasks = new List<Task>();

    	Task t = new Task (	 Subject = 'Call'
    						,CurrencyIsoCode = 'USD'
    						,Status = 'Completed'
    						,Priority = 'Normal'
    						,Set_to_Private__c = false
                           , WhoId = ldObj.Id
    						,IsVisibleInSelfService = false );

    	for (Integer i = 0; i < NUM_OF_RECORDS; i++ ) {
    		tasks.add(t.clone());
    	}

    	// Run test
    	Test.startTest();
    		INSERT tasks;
    	Test.stopTest();

    	// Perform asserts
    	List<Task> newTasks = [SELECT Id, IsVisibleInSelfService FROM Task WHERE Id IN :tasks];

    	for (Task tsk : newTasks) {
    		System.assertEquals(true, tsk.IsVisibleInSelfService, 'Value for Public field is not correct.');
    	}
    }
}