/**
 * trac_SFMCSyncQueueable
 * @description Apex queueable to make async api callout from trigger
 *
 * @author Zi Zhang, Traction on Demand
 * @date 6/26/2019
 */

public class trac_SFMCSyncQueueable implements Queueable, Database.AllowsCallouts {
    private List<Contact> cons;
    private Boolean isDeleted;

    public trac_SFMCSyncQueueable(List<Contact> cons, Boolean isDeleted) {
        this.cons = cons;
        this.isDeleted = isDeleted;
    }

    public void execute(QueueableContext context) {
        (new trac_SFMCSyncService()).syncContacts(cons, isDeleted);
    }
}