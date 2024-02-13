trigger OpportunityContactRoleTrigger on OpportunityContactRole (after insert, after update, after delete) {
                                                                    
    //As opportunity contact roles come; we want to count them and put the number on the opp.
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
		OpportunityContactRoleTrgHandler.setOppCounts(trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
		OpportunityContactRoleTrgHandler.setOppCounts(trigger.old);
    }
}