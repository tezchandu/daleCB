trigger AssociateLeadToFranchise on Lead (before insert, before update) {
    if(system.label.trac_SwitchForLeadTrigger =='true'){
        FranchiseAssociation.AssociateToFranchise(trigger.new);
    }
}