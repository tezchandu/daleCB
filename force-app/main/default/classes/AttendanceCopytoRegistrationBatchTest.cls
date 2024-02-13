@isTest
public class AttendanceCopytoRegistrationBatchTest {
  @isTest
    static void attcopytoreg1() {
        
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
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Award__c aw = new Award__c(Name = 'Best Presentation', Award_Code__c = 'BP');
        insert aw;
        Award__c aw1 = new Award__c(Name = 'Human Relations Award', Award_Code__c = 'HR');
        insert aw1;
      
         List<Attendance__c> attendances = new List<Attendance__c>();
    for (Session__c session : sessions) {
        attendances.add(new Attendance__c(Registration__c = reg.Id, Session__c = session.Id, AttendedPartA__c = 'Yes', AttendedPartB__c = 'Yes', Program__c = program.Id, AwardPartA__c = aw.Id, AwardPartB__c = aw1.Id));
    }
        system.debug('attendances ' +attendances);
    insert attendances;
      

Test.startTest();
      AttendanceCopytoRegistrationBatch batch = new AttendanceCopytoRegistrationBatch();
       Database.executeBatch(batch, 200);        
Test.stopTest();
    }   
    
    
 @isTest
    static void attcopytoregAw() {
        
        Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
         Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.newInstance(2023, 12, 31), Latest_Session_Date_Attendance_Taken__c=Date.newInstance(2023, 12, 31) , Program_Location__c = pl.Id );
        insert program;
        
         Session__c sessionAw = new Session__c(SessionDate__c = Date.today(), SessionNumber__c = 'Awareness', Program__c = program.Id);
        insert sessionAw;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Award__c aw = new Award__c(Name = 'Best Presentation', Award_Code__c = 'BP');
        insert aw;
        Award__c aw1 = new Award__c(Name = 'Human Relations Award', Award_Code__c = 'HR');
        insert aw1;
      
        Attendance__c att1 = new Attendance__c(Registration__c = reg.Id,  Session__c = sessionAw.Id, AttendedPartA__c = 'Yes',AttendedPartB__c = 'Yes', Program__c = program.Id, AwardPartA__c = aw.Id, 
                                              AwardPartB__c = aw1.Id);
        insert att1;
             
      

Test.startTest();
      AttendanceCopytoRegistrationBatch batch = new AttendanceCopytoRegistrationBatch();
       Database.executeBatch(batch, 200);        
Test.stopTest();
    }    

    
     @isTest
    static void attcopytoregOr() {
        
        Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
         Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.newInstance(2023, 12, 31), Latest_Session_Date_Attendance_Taken__c=Date.newInstance(2023, 12, 31) , Program_Location__c = pl.Id );
        insert program;
        
         Session__c sessionOr = new Session__c(SessionDate__c = Date.today(), SessionNumber__c = 'Orientation', Program__c = program.Id);
        insert sessionOr;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Award__c aw = new Award__c(Name = 'Best Presentation', Award_Code__c = 'BP');
        insert aw;
        Award__c aw1 = new Award__c(Name = 'Human Relations Award', Award_Code__c = 'HR');
        insert aw1;
      
        Attendance__c att1 = new Attendance__c(Registration__c = reg.Id,  Session__c = sessionOr.Id, AttendedPartA__c = 'Yes',AttendedPartB__c = 'Yes', Program__c = program.Id, AwardPartA__c = aw.Id, 
                                              AwardPartB__c = aw1.Id);
        insert att1;
             
      

Test.startTest();
      AttendanceCopytoRegistrationBatch batch = new AttendanceCopytoRegistrationBatch();
       Database.executeBatch(batch, 200);       
Test.stopTest();
    }    

     @isTest
    static void attcopytoregSs() {
        
        Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
         Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.newInstance(2023, 12, 31), Latest_Session_Date_Attendance_Taken__c=Date.newInstance(2023, 12, 31) , Program_Location__c = pl.Id );
        insert program;
        
         Session__c sessionSs = new Session__c(SessionDate__c = Date.today(), SessionNumber__c = 'Sustainment', Program__c = program.Id);
        insert sessionSs;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Award__c aw = new Award__c(Name = 'Best Presentation', Award_Code__c = 'BP');
        insert aw;
        Award__c aw1 = new Award__c(Name = 'Human Relations Award', Award_Code__c = 'HR');
        insert aw1;
      
        Attendance__c att1 = new Attendance__c(Registration__c = reg.Id,  Session__c = sessionSs.Id, AttendedPartA__c = 'Yes',AttendedPartB__c = 'Yes', Program__c = program.Id, AwardPartA__c = aw.Id, 
                                              AwardPartB__c = aw1.Id);
        insert att1;
             
      

Test.startTest();
     AttendanceCopytoRegistrationBatch batch = new AttendanceCopytoRegistrationBatch();
       Database.executeBatch(batch, 200);        
Test.stopTest();
    }    

    @isTest
    static void attcopytoreg2() {
        
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
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Award__c aw = new Award__c(Name = 'Best Presentation', Award_Code__c = 'BP');
        insert aw;
        Award__c aw1 = new Award__c(Name = 'Human Relations Award', Award_Code__c = 'HR');
        insert aw1;
      
         List<Attendance__c> attendances = new List<Attendance__c>();
    for (Session__c session : sessions) {
        attendances.add(new Attendance__c(Registration__c = reg.Id, Session__c = session.Id, AttendedPartA__c = 'No', AttendedPartB__c = 'Makeup (Transfer)', Program__c = program.Id, AwardPartA__c = aw.Id, AwardPartB__c = aw1.Id));
    }
    insert attendances;
      

Test.startTest();
      AttendanceCopytoRegistrationBatch batch = new AttendanceCopytoRegistrationBatch();
       Database.executeBatch(batch, 200);        
Test.stopTest();
    }   
}