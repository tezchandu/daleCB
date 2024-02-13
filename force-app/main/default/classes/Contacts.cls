public class Contacts extends SObjectDomain {

    public List<Contact> contacts;
    public static SFMCTriggerBypass__c sfmcSettings;
    public static Boolean bypass;
    static {
        sfmcSettings = SFMCTriggerBypass__c.getOrgDefaults();
        if(sfmcSettings != null){
            bypass = sfmcSettings.bypass__c;
        }
    }

    public Contacts() {
        super();

        // Cast 'records' list for easy use
        this.contacts = (List<Contact>) records;
    }

    public Contacts(List<Contact> contacts) {
        super(contacts);

        // Cast 'records' list for easy use
        this.contacts = (List<Contact>) records;
    }

    @future
    public static void postMergeRollUp(Set<Id> parentIds) {
//        Opportunities.playRollups = false;
//        RollUp eager = new trac_OpportunityRollUps.OpportunityToContact();
//        eager.parentIds = parentIds;
//        List<SObject> sobjs = eager.updateRollUp();
//        update sobjs;
        //Opportunities.playRollups = true;
    }

    public override void onApplyDefaults() {

    }

    public override void onValidate() {

    }

    public override void onValidate(Map<Id,SObject> existingRecords) {

    }

    public override void onBeforeInsert() {

    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) {

    }

    public override void onBeforeDelete() {
    }

    public override void onAfterInsert() {
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
    }

    public override void onAfterDelete() {
        System.enqueueJob(new trac_SFMCSyncQueueable(contacts, true));
    }

    public override void onAfterMergeDelete(List<SObject> mergeLoserRecords) {

        Set<Id> mergeWinners = new Set<Id>();
        for (Contact c : (List<Contact>) mergeLoserRecords) {
            mergeWinners.add(c.MasterRecordId);
        }
        if (!mergeWinners.isEmpty()) {
            // Update the merge winners
            postMergeRollUp(mergeWinners);
        }

        if (bypass != null && bypass) {
            System.enqueueJob(new trac_SFMCSyncQueueable((List<Contact>) mergeLoserRecords, true));
        }

    }

    public override void onAfterUndelete() {
//        update (new RollupExamples.ContactToAccount()).execute();
//        LazyRollUp.execute(new RollUpExamples.ContactToAccountLazy());
        //new trac_SyncDeletedContactsHelper(contacts);
    }
}