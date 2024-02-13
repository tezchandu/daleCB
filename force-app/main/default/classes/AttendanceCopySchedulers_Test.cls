@isTest
public class AttendanceCopySchedulers_Test {

    @isTest
    Public static void Schedulers(){
        AttendanceCopytoDigitalRegScheduler batchSch=new AttendanceCopytoDigitalRegScheduler ();
		String sch='0 0 2,8,14,20 * * ?';
		System.schedule('Att to Digital Reg Batch Schedule', sch , batchSch);
        
        AttendanceCopytoRegistrationScheduler batchSch1=new AttendanceCopytoRegistrationScheduler();
		String sch1='0 0 0,6,12,18 * * ?';
		System.schedule('Att to Reg Batch Schedule', sch1 , batchSch1);
    }
}