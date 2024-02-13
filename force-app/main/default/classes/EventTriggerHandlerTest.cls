/******************************************************************************
 * Name:		EventTriggerHandlerTest
 * 
 * Purpose:		Tests against the EventTriggerHandler Class & Triggers on Event object
 * 				and provides code coverage.
 * 				
 * @Author: 	Abdul Sattar (Magnet360)
 * @Date: 		08.27.2015
 * 
 * @Updates:
 */
@isTest
private class EventTriggerHandlerTest {
	
    private static Integer NUM_OF_RECORDS = 10;	// Number of records to test

	// Tests against EventTriggerHandler.setEventsPublic()
    private static testMethod void setEventsPublicTest () {
    	
    	// Create test Events
    	List<Event> events = new List<Event>();

    	Event t = new Event (Subject = 'Call'
    						,CurrencyIsoCode = 'USD'
    						,StartDateTime = System.today()
    						,EndDateTime = System.today()
    						,Set_to_Private__c = false
    						,IsVisibleInSelfService = false );

    	for (Integer i = 0; i < NUM_OF_RECORDS; i++ ) {
    		events.add(t.clone());
    	}

    	// Run test
    	Test.startTest();
    		INSERT events;
    	Test.stopTest();

    	// Perform asserts
    	List<Event> newEvents = [SELECT Id, IsVisibleInSelfService FROM Event WHERE Id IN :events];

    	for (Event evt : newEvents) {
    		System.assertEquals(true, evt.IsVisibleInSelfService, 'Value for Public field is not correct.');
    	}
    }
}