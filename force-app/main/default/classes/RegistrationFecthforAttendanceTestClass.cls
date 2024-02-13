@isTest
public class RegistrationFecthforAttendanceTestClass {

    @isTest
    static void test() {
        // Create test data
        Test.startTest();
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        Account acc =  new Account();
        acc.Name = 'Test Acc';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        Program__c program = new Program__c();
        program.Name = 'Test Program';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        program.Program_Graduation_Start_Date_Time__c = DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Program_Graduation_End_Date_Time__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        insert program;
        
        
        
        /*Registration__c reg2 = new Registration__c();
        reg2.ProgramCode__c = program.Id;
        reg2.RegistrationType__c = 'Registration';
        reg2.RegistrationDate__c = Date.Today();
        reg2.Lead_Source__c = 'Event';
        reg2.ContactName__c = null;
        reg2.Completed_Sessions_Count__c = 5;
        reg2.ExitType__c = null;
        insert reg2;*/
        
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 5;
        reg.ExitType__c = null;
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        RegistrationFecthforAttendance.getRegistrationsByProgramId(program.Id);
        
        RegistrationFecthforAttendance.fetchRegistrationRecs(program.Id);
        
        RegistrationFecthforAttendance.updateRegistrationGraduate(program.Id);
        
        RegistrationFecthforAttendance.handleProduct(reg.Id,program.Id);
        
        RegistrationFecthforAttendance.handleProgramifSame(reg.Id,program.Id,program.Id);
        
        RegistrationFecthforAttendance.getRefund(ids);
        
        
        RegistrationFecthforAttendance.handleSave(TestcreateAttendancePayments(),program.Id);
        Test.stopTest();
        
        
    	
        //RegistrationFecthforAttendance.createAttendancenPayments
            
            
        
        //Test.stopTest();
    }
    
	@isTest
    static void test123() {
        // Create test data
        Test.startTest();
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        Product2 prdct = new Product2();
        prdct.Name ='Test Product1';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        Account acc =  new Account();
        acc.Name = 'Test Acc';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        Program__c program = new Program__c();
        program.Name = 'Test Program4';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
        
        
        
        /*Registration__c reg2 = new Registration__c();
        reg2.ProgramCode__c = program.Id;
        reg2.RegistrationType__c = 'Registration';
        reg2.RegistrationDate__c = Date.Today();
        reg2.Lead_Source__c = 'Event';
        reg2.ContactName__c = null;
        reg2.Completed_Sessions_Count__c = 5;
        reg2.ExitType__c = null;
        insert reg2;*/
        
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 5;
        reg.ExitType__c = null;
        insert reg;
        
        /*Fee_Payment__c fp = new Fee_Payment__c();
        fp.Payment_Amount__c = 100;
        fp.Participant_Registration__c = reg.id;
        fp.Payment_Type__c = 'Web';
        fp.Payment_Date__c = Date.Today();
        fp.Program_Code__c = program.Id;
        insert fp;*/
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);

        
        RegistrationFecthforAttendance.handleSave(TestcreateAttendancePayments1(),program.Id);
        Test.stopTest();
        
    	
        //RegistrationFecthforAttendance.createAttendancenPayments
            
            
        
        //Test.stopTest();
    }
    
    
    private static string TestcreateAttendancePayments() {
                
        RegistrationFecthforAttendance.createAttendancenPayments testWrapper = new RegistrationFecthforAttendance.createAttendancenPayments();
            
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        
        Program__c program = new Program__c();
        program.Name = 'Test Program';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
         Account acc =  new Account();
        acc.Name = 'Test Acc11';
        acc.BillingCity = 'wert';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con2';
        con.AccountId = acc.Id;
        con.Email = 'con2@gmail.com';
        insert con;
         Registration__c reg1 = new Registration__c();
        reg1.ProgramCode__c = program.Id;
        reg1.RegistrationType__c = 'Registration';
        reg1.RegistrationDate__c = Date.Today();
        reg1.Lead_Source__c = 'Event';
        reg1.ContactName__c = con.Id;
        reg1.Completed_Sessions_Count__c = 5;
        insert reg1;
        
        testWrapper.prgmID =program.id ;
        testWrapper.exitType = 'Drop';
        testWrapper.atttendance = '';
        testWrapper.noPayment = 'Yes';
        testWrapper.refAmountVal =50.00;
        testWrapper.transPay ='Yes';
        testWrapper.refPay ='Yes';
        testWrapper.programCode ='';
        testWrapper.registrationId = reg1.id;
        testwrapper.contactName = 'Testing Con';
        List<RegistrationFecthforAttendance.createAttendancenPayments> attendanceList = new List<RegistrationFecthforAttendance.createAttendancenPayments>();
		attendanceList.add(testwrapper);
        String wrapParams = JSON.serialize(attendanceList);
        return wrapParams;
        
    }
    private static string TestcreateAttendancePayments1() {
                
        RegistrationFecthforAttendance.createAttendancenPayments testWrapper = new RegistrationFecthforAttendance.createAttendancenPayments();
            
        Product2 prdct = new Product2();
        prdct.Name ='Test Product';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        
        Program__c program = new Program__c();
        program.Name = 'Test Program';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
         Account acc =  new Account();
        acc.Name = 'Test Acc11';
        acc.BillingCity = 'asdf';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con3';
        con.AccountId = acc.Id;
        con.Email = 'con3@gmail.com';
        insert con;
         Registration__c reg1 = new Registration__c();
        reg1.ProgramCode__c = program.Id;
        reg1.RegistrationType__c = 'Registration';
        reg1.RegistrationDate__c = Date.Today();
        reg1.Lead_Source__c = 'Event';
        reg1.ContactName__c = null;
        reg1.Completed_Sessions_Count__c = 5;
        insert reg1;
        
                Program__c program1 = new Program__c();
        program1.Name = 'Test Program123';
        program1.Weekdays__c = 'Monday;Wednesday;Friday';
        program1.TotalSessions__c = 10;
        program1.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program1.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program1.MinimumSessions__c = 2;
        program1.Product__c = prdct.Id;
        program1.AllSessionsAttendanceTaken__c = true;
        insert program1;
        
        testWrapper.prgmID =program.id ;
        testWrapper.exitType = 'Transfer';
        testWrapper.atttendance = '';
        testWrapper.noPayment = 'Yes';
        testWrapper.refAmountVal =50.00;
        testWrapper.transPay ='Yes';
        testWrapper.refPay ='Yes';
        testWrapper.programCode =program1.id;
        testWrapper.registrationId = reg1.id;
        testwrapper.contactName = 'Test Cont';
        List<RegistrationFecthforAttendance.createAttendancenPayments> attendanceList = new List<RegistrationFecthforAttendance.createAttendancenPayments>();
		attendanceList.add(testwrapper);
        String wrapParams = JSON.serialize(attendanceList);
        return wrapParams;
        
    }
    @isTest
    static void testRegRecs() {
        // Create test data
        Test.startTest();
        Id RecTypeId = [select id from RecordType where DeveloperName = 'Client_Builder_Master' and SobjectType ='Product2'][0].id;
        Product2 prdct = new Product2();
        prdct.Name ='Test Product1234';
        prdct.Product_Type__c = '10 Sessions';
        prdct.Product_Group__c = 'Leadership';
        prdct.Product_Subgroup__c = 'DCD-MGSEE-2';
        //prdct.CurrencyIsoCode = 'USD - U.S. Dollar';
        prdct.Product_Availability__c = 'DCDigital';
        prdct.Total_Sessions__c = 10;
        prdct.Minimum_Registrations__c = 1;
        prdct.Maximum_Registrations__c = 5;
        prdct.Minimum_Sessions__c = 1;
        prdct.Continuing_Education_Units__c = 2;
        prdct.RecordTypeId = RecTypeId;
        insert prdct;
        
        Account acc =  new Account();
        acc.Name = 'Test Acc124';
        insert acc;
        Contact con = new Contact();
        con.LastName = 'Test Con1234';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        Program__c program = new Program__c();
        program.Name = 'Test Program1234';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 10;
        program.Session1StartDateTime__c=DateTime.newInstance(2023, 1, 1,1,0,0);
        program.Session1EndDateTime__c = DateTime.newInstance(2023, 1, 1,3,0,0);
        program.MinimumSessions__c = 2;
        program.Product__c = prdct.Id;
        program.AllSessionsAttendanceTaken__c = true;
        insert program;
    
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        reg.Completed_Sessions_Count__c = 1;
        reg.ExitType__c = null;
        insert reg;
        List<Id> ids =new List<Id>();
        ids.add(reg.Id);
        
        //RegistrationFecthforAttendance.getRegistrationsByProgramId(program.Id);
        
        RegistrationFecthforAttendance.fetchRegistrationRecs(program.Id);
        
        Test.stopTest();
        
        
    	
        //RegistrationFecthforAttendance.createAttendancenPayments
            
            
        
        //Test.stopTest();
    }
}