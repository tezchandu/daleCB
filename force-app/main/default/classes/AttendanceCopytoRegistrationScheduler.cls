global class AttendanceCopytoRegistrationScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {       
        AttendanceCopytoRegistrationBatch b = new AttendanceCopytoRegistrationBatch ();
        if(!Test.isRunningTest()){
        database.executebatch(b,200);
        }

    }
    
    /*   execute this in anonymous window to run batch for every 4 hours
      AttendanceCopytoRegistrationScheduler batchSch=new AttendanceCopytoRegistrationScheduler();
String sch='0 0 0,4,8,12,16,20 * * ?';
//System.schedule(String jobName, String cronExp, APEX_OBJECT schedulable);
System.schedule('Att to Reg Batch Schedule', sch , batchSch);      */
   
}