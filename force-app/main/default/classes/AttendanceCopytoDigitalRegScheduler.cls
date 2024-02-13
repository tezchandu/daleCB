global class AttendanceCopytoDigitalRegScheduler implements Schedulable {

global void execute(SchedulableContext sc)
    {       
        AttendanceCopytoDigitalRegBatch batchjob = new AttendanceCopytoDigitalRegBatch();
        if(!Test.isRunningTest()){
Id batchJobId = Database.executeBatch(batchJob);
        }

    }
    
    /*   execute this in anonymous window to run batch for every 4 hours
      AttendanceCopytoRegistrationScheduler batchSch=new AttendanceCopytoRegistrationScheduler();
String sch='0 0 1,5,9,13,17,21 * * ?';
//System.schedule(String jobName, String cronExp, APEX_OBJECT schedulable);
System.schedule('Att to Reg Batch Schedule', sch , batchSch);      */

}