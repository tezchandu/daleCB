public with sharing class ClientBuilderButtonController {
    private Opportunity record;
    //public String errorMsg {get; set;}
    public boolean doRenderMsg {get; set;}

    public ClientBuilderButtonController(ApexPages.StandardController standardController) {
        this.record = (Opportunity) standardController.getRecord();
    }

    public Pagereference fire() {
        TriggerOpportunity triggerOpp = new TriggerOpportunity();
		PageReference pr;
        if(record.StageName != 'Closed Won') {
            //errorMsg = 'You cannot push contacts into Client Builder until the Opportunity is Closed Won';
            doRenderMsg = true;
        } else {
        
            try {
                System.debug('FIRE!!');
                triggerOpp.createDCTLead(new List<Opportunity> {record});
            } catch (Exception ex) {
                System.debug(ex);
            }
            pr = new ApexPages.StandardController(record).view();
        }
        //return new Pagereference('/' + record.Id);
        //return new ApexPages.StandardController(record).view();
        return pr;

    }
}