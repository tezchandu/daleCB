trigger AssociateOppToFranchise on Opportunity (before insert, before update) {
    if(system.label.trac_SwitchForOppTrigger =='true'){
        FranchiseAssociation.AssociateToFranchise(trigger.new);
    }
}