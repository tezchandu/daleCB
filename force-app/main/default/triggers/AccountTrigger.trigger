/**
* Trigger on all events within the Account
* 
* @Date: 01.06.2016
* @Author: Sophia Murphy (Magnet 360)
* 
* @Updates:
* 
*/
trigger AccountTrigger on Account ( before insert, before update )
{
    System.debug('START: AccountTrigger');
    
                                                 // Determine what action is 
                                                 // occurring and when, and
                                                 // pass the correct context
                                                 // variables to the Trigger
                                                 // Handler class where all the
                                                 // actions will take place.
                                                 // Comment out any actions that
                                                 // do not occur yet, or that
                                                 // are handled by pre-existing
                                                 // triggers.
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate) )
    {
        FranchiseSharingHandler.handleAccounts(Trigger.new);
    }   

    /**
    if (Trigger.isBefore && Trigger.isInsert) 
    {
                                                 // Before Insert
        Trigger%ObjectName%.beforeInsert(Trigger.new);
    }
    else if (Trigger.isBefore && Trigger.isUpdate) 
    {
          
                                                 // Before Update
        Trigger%ObjectName%.beforeUpdate (Trigger.new,
                                          Trigger.newMap,
                                          Trigger.old,
                                          Trigger.oldMap);

    }
    else if (Trigger.isBefore && Trigger.isDelete) 
    {
                                                 // Before Delete
        Trigger%ObjectName%.beforeDelete(Trigger.new, Trigger.old);
    }
    else if(Trigger.isAfter && Trigger.isInsert) 
    {
                                                 // After Insert
        Trigger%ObjectName%.afterInsert(Trigger.new);
    } 
    else if (Trigger.isAfter && Trigger.isUpdate) 
    {
                                                 // After Update
        Trigger%ObjectName%.afterUpdate( Trigger.new, 
                                         Trigger.newMap, 
                                         Trigger.old, 
                                         Trigger.oldMap);
    }
    else if (Trigger.isAfter && Trigger.isDelete) 
    {
                                                 // After Delete
        Trigger%ObjectName%.afterDelete( Trigger.new,
                                         Trigger.old);
    }
    else if (Trigger.isAfter && Trigger.isUnDelete) 
    {
                                                 // After UnDelete
        Trigger%ObjectName%.afterUnDelete( Trigger.new,
                                           Trigger.old);
    }
    */
    
    System.debug('END: AccountTrigger');

}// END class