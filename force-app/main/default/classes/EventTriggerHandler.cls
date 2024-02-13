/**
 * Name:		EventTriggerHandler
 * 
 * Purpose: 	Controller class that contains all methods for the triggers on Event object.
 * 
 * @Author:     Abdul Sattar (Magnet 360)
 * @Date:       08.27.2015
 * 
 * @Updates: 
 */
public with sharing class EventTriggerHandler {
	
	/**
     * Sets / makes events public
     * Called from EventBefore trigger
     * 
     * @param newEvents List on new Tasks
	 *
	 * @Author:  Abdul Sattar (Magnet 360)
	 * @Date:    08.27.2015
	 * 
	 * @Updates: 
     */
    public static void setEventsPublic(List<Event> newEvents) {
    	System.debug('START: setEventsPublic()');

    	// Loop through all events and make them Public, if applicable
    	for (Event e : newEvents) {
    		if (!e.IsVisibleInSelfService && !e.Set_to_Private__c)
    			e.IsVisibleInSelfService = true;
    	}
    	System.debug('END: setEventsPublic()');
    }
}