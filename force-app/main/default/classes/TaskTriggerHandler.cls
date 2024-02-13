/**
 * Name:        TaskTriggerHandler
 * 
 * Purpose:     Controller class that contains all methods for the triggers on Task object.
 * 
 * @Author:     Abdul Sattar (Magnet 360)
 * @Date:       08.27.2015
 * 
 * @Updates: 
 * 09.11.2015   Abdul Sattar (Magnet 360)
 *              Updated to capture all tasks and make them public.
 * 
 */
public without sharing class TaskTriggerHandler {
    
    /**
     * Sets / makes tasks public
     * Called from TaskBefore trigger
     * 
     * @param newTasks List on new Tasks
     *
     * @Author:  Abdul Sattar (Magnet 360)
     * @Date:    08.27.2015
     * 
     * @Updates: 
     */
    public static void setTasksPublic(List<Task> newTasks) {
        System.debug('START: setTasksPublic()');

        // Loop through all tasks and make them Public, if applicable
        for (Task t : newTasks) {
            if (!t.IsVisibleInSelfService && !t.Set_to_Private__c && t.RecordTypeId != trac_Constants.dfgTaskRT)
                t.IsVisibleInSelfService = true;
        }
        System.debug('END: setTasksPublic()');
    }

    /**
     * ChangeLeadStatus
     * Called from TaskAfter trigger
     * 
     * @param tasks List on new Tasks
     *
     * @Author:  Usman Ali (Magnet 360)
     * @Date:    10.31.2016
     * 
     * @Updates: 
     */

    public static void changeLeadStatus(List<Task> tasks)
    {
        Set<Id> leadIds = new Set<Id>();

        for( Task t : tasks )
        {
            //Task must be related to a LEAD
            //Task must be completed
            if( t.WhoId != null && String.valueOf(t.WhoId).startsWith('00Q') && t.Status == 'Completed')
            {
                leadIds.add(t.WhoId);
            }
        }
        System.debug('UAC: leadIds ' + leadIds );
        if( leadIds.size() == 0 ) return ;

        List<Lead> leadsToUpdate =  [SELECT Id, Has_Activity__c FROM Lead WHERE ID IN :leadIds ] ;
        System.debug('UAC: leadsToUpdate ' + leadsToUpdate );
        if (leadsToUpdate.size() == 0) return ; 

        for( Lead l : leadsToUpdate )
        {
            l.Has_Activity__c = true ;
        }
        
        update leadsToUpdate; 
    }

}