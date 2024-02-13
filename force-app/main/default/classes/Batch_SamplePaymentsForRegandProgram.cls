public class Batch_SamplePaymentsForRegandProgram implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext BC){
    string query ='select id from program__c limit 1';
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext BC, List<sObject> scope){
   }
    public void finish(Database.BatchableContext BC){
   }

}