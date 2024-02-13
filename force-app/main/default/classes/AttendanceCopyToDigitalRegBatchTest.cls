@isTest 
public class AttendanceCopyToDigitalRegBatchTest {
    
      @isTest
    static void reg1() {
        
        Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
         Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.newInstance(2023, 12, 31), Latest_Session_Date_Attendance_Taken__c=Date.newInstance(2023, 12, 31) , Program_Location__c = pl.Id );
        insert program;
        
       List<Session__c> sessions = new List<Session__c>();
    for (Integer i = 1; i <= 16; i++) {
        sessions.add(new Session__c(SessionDate__c = Date.today().addDays(i - 1), SessionNumber__c = String.valueOf(i), Program__c = program.Id));
    }
    insert sessions;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship', 
                                                 Confirm_Share_with_Franchisee__c = true , Responsible_Franchise__c = at.Id, Session_1_Award__c = 'Best Presentation', 
                                                 Session_2_Award__c = 'Test', Session_3_Award__c = 'Human Relations', Session_4_Award__c = 'Test', Session_5_Award__c = 'Test award',
                                                 Session_6_Award__c = 'HY award', Session_7_Award__c = 'Aw award', Session_8_Award__c = '8 award', Session_9_Award__c = '9 award',
                                                 Session_10_Award__c = '10 award', Session_11_Award__c = '11 award', Session_12_Award__c = '12 award', Session_13_Award__c = '13 award', 
                                                 Session_14_Award__c = '14 award' , Session_15_Award__c = '15 award', Session_16_Award__c = '16 award', Awareness_Award__c = 'Awareness award',
                                                  Orientation_Award__c = 'Or award',Sustainment_Award__c = 'Ss award', Session_1_Date__c = Date.today(),
                                                 Session_2_Date__c = Date.today()+5, Session_3_Date__c = Date.today()+7, Session_4_Date__c = Date.today()+9, Session_5_Date__c = Date.today()+11, 
                                                 Session_6_Date__c = Date.today()+14, Session_7_Date__c = Date.today()+16, Session_8_Date__c = Date.today()+18, Session_9_Date__c = Date.today()+20,
                                                 Session_10_Date__c = Date.today()+25, Session_11_Date__c = Date.today()+26, Session_12_Date__c = Date.today()+30, Session_13_Date__c = Date.today()+34,
                                                 Session_14_Date__c = Date.today()+38, Session_15_Date__c = Date.today()+40, Session_16_Date__c = Date.today()+42, /*Awareness_Date__c = Date.today()+42, */
                                                 Sustainment_Date__c = Date.today()+45, Orientation_Date__c = Date.today()+48, 
                                                 Attended_Session_1__c = 'Yes', Attended_Session_2__c = 'Yes', Attended_Session_3__c = 'Yes', Attended_Session_4__c = 'Yes', Attended_Session_5__c = 'No',
                                                 Attended_Session_6__c = 'Yes', Attended_Session_7__c = 'Yes', Attended_Session_9__c = 'Yes', Attended_Session_10__c = 'Yes',
                                                 Attended_Session_11__c = 'Yes', Attended_Session_12__c = 'Yes' , Attended_Session_13__c = 'Yes', Attended_Session_14__c = 'Yes', Attended_Session_15__c = 'Yes',
                                                  Attended_Session_16__c = 'Yes', Attended_Awareness__c = 'Yes' , Attended_Orientation__c = 'Yes' , Attended_Sustainment__c = 'Yes');
        insert reg;
        
         Registration__c rcopy = new Registration__c(ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship', Digital_Shared_Copy__c = true, 
                                                  Source_Registration_ID_Digital__c = reg.Id);
        insert rcopy;
        
      

Test.startTest();
      AttendanceCopytoDigitalRegBatch batch = new AttendanceCopytoDigitalRegBatch();
       Database.executeBatch(batch, 200);        
Test.stopTest();
    }   

}