@isTest(seealldata = false)
private class SessionAfterUpdateTriggerTest {
    
    
     @testSetup
    static void setup(){
        
        Id FranchiseRecTypeId = [select id,DeveloperName from RecordType where DeveloperName = 'Franchisee' and SobjectType ='Account'][0].id;
        Account acc = new Account();
        acc.Name = 'Test Acc';
        acc.RecordTypeId = FranchiseRecTypeId;
        acc.Allow_Attendance_email_for_Sales_Reps__c = true;
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Con';
        con.AccountId = acc.Id;
        con.Email = 'con@gmail.com';
        insert con;
        
        
        Program__c program = new Program__c();
        program.Name = 'Session Test Class1';
        program.Weekdays__c = 'Monday;Wednesday;Friday';
        program.TotalSessions__c = 3;
        program.Session1StartDateTime__c=DateTime.Now();
        program.Franchise_Account__c = acc.Id ;
        insert program;
        
        Registration__c reg = new Registration__c();
        reg.ProgramCode__c = program.Id;
        reg.RegistrationType__c = 'Registration';
        reg.RegistrationDate__c = Date.Today();
        reg.Lead_Source__c = 'Event';
        reg.ContactName__c = con.Id;
        insert reg;
        
        Employee__c E = new Employee__c();
        E.Name = 'Test Employee';
        E.Contact_Name__c = con.Id;
        E.Franchise__c = acc.Id;
        E.Status__c = 'Active';
        insert E;
        
        Sales_Person__c SP = new Sales_Person__c();
        SP.Program__c = program.Id;
        SP.Participant__c = reg.Id;
        SP.Sales_Person__c = E.Id;
        SP.Process_Sharing__c = true;
        insert SP;
        
        Trainer__c Tr = new Trainer__c();
        Tr.Name = 'TestTrainer';
        Tr.First_Name__c = 'TTF';
        Tr.Last_Name__c = 'TTL';
        Tr.Status__c = 'Active';
        Tr.Contracted_By__c = acc.Id;
        Tr.Primary_Email_Address__c = 'TTF.TTL@gmail.com';
        insert Tr;
        
        Program_Trainer__c PTr = new Program_Trainer__c();
        PTr.Program__c = program.Id;
        PTr.Trainer__c = Tr.Id;
        insert PTr;
        
        
        Coaching_Assistant__c CA = new Coaching_Assistant__c();
        CA.Name = 'Test CA';
        CA.Status__c = 'Active';
        CA.Franchise_Account__c = acc.Id;
        CA.ContactName__c = con.Id;
        //CA.ProductsQualified__c = 'DCC';
        insert CA;
        
        Program_Coaching_Assistant__c PCA = new Program_Coaching_Assistant__c();
        PCA.Coaching_Assistant__c = CA.Id;
        PCA.Program__c = program.Id;
        insert PCA;
        
        Fee_Payment__c fp= new Fee_Payment__C();
        fp.Payment_Amount__c = 100;
        fp.Payment_Type__c = 'Web';
        fp.Payment_Date__c = Date.Today();
        fp.Program_Code__c = program.Id;
        fp.Process_Sharing__c = true;
        //insert fp;
        
        Customer_Agreement__c CAM = new Customer_Agreement__c();
        CAM.Name = 'Test CA';
        CAM.AccountName__c = acc.Id;
        CAM.ContactName__c = con.Id;
        CAM.AgreementAmount__c = 1000;
        CAM.Process_Sharing__c = TRUE;
        INSERT CAM;
    }
    
    @isTest
    static void testHandleAfterUpdate1() {
        
        Id programId = [select id from Program__c][0].id;
        
        List<Session__c> s = [select Id, Program__c, SessionDate__c, SessionNumber__c 
                       from Session__c where Program__c =:programId];
        
        s[0].SessionDate__c = Date.Today()+5;
        s[0].AttendanceTaken__c = true;
        s[0].SessionNumber__c = '2';

        Test.startTest();
        update s; 
        Blob content = Blob.valueOf('UNIT.TEST');
            SessionAfterUpdateTrigger.isExecuting=true; 
        Test.stopTest();
       
    }
    
    
}