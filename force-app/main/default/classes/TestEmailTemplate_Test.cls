@isTest
public class TestEmailTemplate_Test {
    

    //program = [Select Name,Weekdays__c, Program_Graduation_End_Date_Time__c, Program_Location__r.Location_Name__c  
    //from Program__c where Name = 'winning Program']; 
    @isTest
    static void testEmailTemplateConstructor() {
        
        Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
         Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.newInstance(2023, 12, 31), Latest_Session_Date_Attendance_Taken__c=Date.newInstance(2023, 12, 31) , Program_Location__c = pl.Id );
        insert program;
        
         Session__c session1 = new Session__c(SessionDate__c = Date.today(), SessionNumber__c = '1', Program__c = program.Id);
        insert session1;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);

        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Sales_Person__c sp = new Sales_Person__c(Participant__c = reg.Id , Program__c = program.Id);
        insert sp;
      
        Attendance__c att1 = new Attendance__c(Registration__c = reg.Id,  Session__c = session1.Id, AttendedPartA__c = 'Yes',AttendedPartB__c = 'Yes', Program__c = program.Id,Process_Sharing__c = true);
        insert att1;
             
        AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);  
                String formattedDate = emailTemplateInstance.getFormattedGraduationDate();

Test.startTest();
     emailTemplateInstance.loadRegistrations();
      //  System.assertEquals('December 31, 2023', formattedDate);
       emailTemplateInstance.getFormattedSessionDate();

        
Test.stopTest();
    }    
    
    @isTest
    static void testEmailTemplateConstructor2() {
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);

        Session__c session2 = new Session__c(Program__c = program.Id, SessionNumber__c = 'Awareness', SessionDate__c = Date.today());
        insert session2;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id,ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Sales_Person__c sp = new Sales_Person__c(Participant__c = reg.Id , Program__c = program.Id);
        insert sp;
        
        Attendance__c att2 = new Attendance__c(Registration__c = reg.Id, Session__c = session2.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Yes');
		insert att2;
        
        AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
    @isTest
    static void testEmailTemplateConstructor3() {
                Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
		
        Session__c session3 = new Session__c(Program__c = program.Id, SessionNumber__c = 'Orientation', SessionDate__c = Date.today()+2);
		insert session3;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id, ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Sales_Person__c sp = new Sales_Person__c(Participant__c = reg.Id , Program__c = program.Id);
        insert sp;

        Attendance__c att3 = new Attendance__c(Registration__c = reg.Id, Session__c = session3.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Yes');
		insert att3;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
     @isTest
    static void testEmailTemplateConstructor4() {
        
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
        
        Session__c session4 = new Session__c(Program__c = program.Id, SessionNumber__c = 'Sustainment', SessionDate__c = Date.today()-2 );
		insert session4;
        
       
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id, ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
        
        Sales_Person__c sp = new Sales_Person__c(Participant__c = reg.Id , Program__c = program.Id);
        insert sp;
        
        Award__c aw = new Award__c();
        aw.Award_Code__c = 'BP';
        aw.Name = 'Best Presentation';
        insert aw;
        
        Award__c aww = new Award__c();
        aww.Award_Code__c = 'GR';
        aww.Name = 'Great Rep';
        insert aww;
        
         Attendance__c att4 = new Attendance__c(Registration__c = reg.Id, Session__c = session4.Id, Program__c = program.Id,AwardPartA__c=aw.Id,AwardPartB__c=aww.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Yes');
		insert att4;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
		
    }
    
     @isTest
    static void testEmailTemplateConstructor5() { 
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
        
        Session__c session5 = new Session__c(Program__c = program.Id, SessionNumber__c = '5', SessionDate__c = Date.today()-2 );
		insert session5;
        
         Registration__c reg = new Registration__c(ProgramCode__c = program.Id, ExitType__c = 'Graduate');
        insert reg;
        
        Award__c aw = new Award__c();
        aw.Award_Code__c = 'BP';
        aw.Name = 'Best Presentation';
        insert aw;
        
        Award__c aww = new Award__c();
        aww.Award_Code__c = 'GR';
        aww.Name = 'Great Rep';
        insert aww;
        
          Attendance__c att5 = new Attendance__c(Registration__c = reg.Id, Session__c = session5.Id, AwardPartA__c=aw.Id,AwardPartB__c=aw.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'No');
		insert att5;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
     @isTest
    static void testEmailTemplateConstructor6() { 
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program', Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
        
        Session__c session6 = new Session__c(Program__c = program.Id, SessionNumber__c = 'Awareness', SessionDate__c = Date.today() );
		insert session6;
        
         Registration__c reg = new Registration__c(ProgramCode__c = program.Id, ExitType__c = 'Graduate');
        insert reg;
        
     
        
          Attendance__c att6 = new Attendance__c(Registration__c = reg.Id, Session__c = session6.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Makeup');
		insert att6;
        System.debug('Attendance record is' +att6);
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
     @isTest
    static void testEmailTemplateConstructor7() { 
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
        
        Session__c session7 = new Session__c(Program__c = program.Id, SessionNumber__c = '7', SessionDate__c = Date.today()-2 );
		insert session7;
        
         Registration__c reg = new Registration__c(ProgramCode__c = program.Id, ExitType__c = 'Drop');
        insert reg;
        
        Award__c aw = new Award__c();
        aw.Award_Code__c = 'BP';
        aw.Name = 'Best Presentation';
        insert aw;
        
          Attendance__c att7 = new Attendance__c(Registration__c = reg.Id, Session__c = session7.Id,AwardPartA__c=aw.Id,AwardPartB__c=aw.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Makeup (Transfer)');
		insert att7;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
        @isTest
    static void testEmailTemplateConstructor8() { 
         Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise'); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
        
        Session__c session7 = new Session__c(Program__c = program.Id, SessionNumber__c = 'Sustainment', SessionDate__c = Date.today()-2 );
		insert session7;
        
         Registration__c reg = new Registration__c(ProgramCode__c = program.Id, ExitType__c = 'Drop');
        insert reg;
        
        Award__c aw = new Award__c();
        aw.Award_Code__c = 'BP';
        aw.Name = 'Best Presentation';
        insert aw;
        
          Attendance__c att7 = new Attendance__c(Registration__c = reg.Id, Session__c = session7.Id,AwardPartA__c=aw.Id,AwardPartB__c=aw.Id, Program__c = program.Id, AttendedPartA__c = 'Yes' , AttendedPartB__c = 'Makeup (Transfer)');
		insert att7;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
    
     @isTest
    static void testEmailTemplateConstructor9() {
                Account at = new Account(Name = 'Test Account');
        insert at;
        
        Contact cc = new Contact(AccountId = at.Id,FirstName = 'Joy',LastName = 'K', MobilePhone = '9997890656');  
        insert cc;
        
        Program_Location__c pl = new Program_Location__c(Name = 'Phoenix Franchise', Process_Sharing__c = true); 
        insert pl;
        
        Program__c program = new Program__c(Name = 'Winning Program',Franchise_Account__c = at.Id, Weekdays__c = 'Monday', Program_Graduation_End_Date_Time__c = Date.today(), Program_Location__c = pl.Id );
        insert program;
        
		ApexPages.StandardController stdController = new ApexPages.StandardController(program);
		
        Session__c session3 = new Session__c(Program__c = program.Id, SessionNumber__c = '3', SessionDate__c = Date.today()+2);
		insert session3;
        
        Registration__c reg = new Registration__c(ContactName__c = cc.Id, ProgramCode__c = program.Id, RegistrationType__c = 'Scholarship');
        insert reg;
 
        Attendance__c att3 = new Attendance__c(Registration__c = reg.Id, Session__c = session3.Id, Program__c = program.Id, AttendedPartA__c = 'No' , AttendedPartB__c = 'No');
		insert att3;
        
         AttendanceEmailController emailTemplateInstance = new AttendanceEmailController(stdController);        
Test.startTest();
     emailTemplateInstance.loadRegistrations();
Test.stopTest();
    }
}