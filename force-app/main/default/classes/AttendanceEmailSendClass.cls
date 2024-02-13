public class AttendanceEmailSendClass{
    @Future(callout=true) 
    public static void testSendEmail(Set<Id> sess){
        List<Id> registrationIds = new List<Id>();
        List<Id> programIds = new List<Id>();
        List<Id> sessionIds = new List<Id>();
        List<Id> accountIds = new List<Id>();
        string prgmId ;
        List<session__c> sessionsList = [select id,Program__c,Program__r.Franchise_Account__c, Program__r.name,Program__r.TotalSessions__c,program__r.Latest_Session_Number_Attendance_Taken__c,
                                         AttendanceTaken__c, SessionNumber__c, SessionDate__c, Name from Session__c where ID IN :sess];
        for(session__c session :sessionsList){
            programIds.add(session.program__c);
            accountIds.add(session.Program__r.Franchise_Account__c);            
        }
        
        Account account = [Select Id,Name, Allow_Attendance_email_for_Sales_Reps__c, Allow_Attendance_email_for_Coaching_Assi__c, 
                           Allow_Attendance_email_for_Trainers__c,Automated_Email_Notification__c from Account where Id IN :accountIds];
        
        Program__c program = [select id,Name,Latest_Session_Date_Attendance_Taken__c,Latest_Session_Number_Attendance_Taken__c,
                              Program_Manager_Email__c from program__c where id In:programIds limit 1];
         List<Registration__c> regs = [select id,Name from Registration__c where ProgramCode__c =:program.id];
        for(Registration__c rg:regs){
            registrationIds.add(rg.id);
        }
        
        System.debug('Registration IDs and ProgramIDs size' +registrationIds.size()+ ',' +programIds.size());
        System.debug('Registration IDs and ProgramIDs size' +program);
        
       
        
        Map<Id, List<Sales_Person__c>> salespersonsbyRegId = new Map<Id, List<Sales_Person__c>>(); 
        if (!registrationIds.isEmpty()) {
            List<Sales_Person__c> salesPersons = [SELECT Id, Participant__c, Primary_Email__c, Name FROM Sales_Person__c WHERE Participant__c IN :registrationIds limit 10];
            
            for (Sales_Person__c salesPerson : salesPersons) {
                if (!salespersonsbyRegId.containsKey(salesPerson.Participant__c)) {
                    salespersonsbyRegId.put(salesPerson.Participant__c, new List<Sales_Person__c>());
                }
                salespersonsbyRegId.get(salesPerson.Participant__c).add(salesPerson);
            }
            System.debug('SalesPersons related to reg size' +salespersonsbyRegId.size());
        }
        
        
        // Query Trainers related to Programs
        //List<> 
        Map<Id, List<Trainer__c>> trainersByProgramId = new Map<Id, List<Trainer__c>>();        
        List<Program_Trainer__c> programTrainers = [SELECT Id, Program__c, Trainer__c, Trainer__r.Id, Trainer__r.Email__c, Trainer__r.Primary_Email_Address__c  FROM Program_Trainer__c WHERE Program__c IN :programIds];
        Set<Id> trainerIds = new Set<Id>();
        for (Program_Trainer__c pt : programTrainers) {
            trainerIds.add(pt.Trainer__c);
        }
        List<Trainer__c> trainers = [Select Id from Trainer__c where Id IN :trainerIds];
        
        for( Program_Trainer__c programtrainer : programTrainers){
            trainersByProgramId.put(programTrainer.Program__c, new List<Trainer__c>());
            
            trainersByProgramId.get(programTrainer.Program__c).add(programTrainer.Trainer__r);
        }
        
        //Query Coaching Assistants related to Program
        Map<Id, List<Coaching_Assistant__c>> caByProgramId = new Map<Id, List<Coaching_Assistant__c>>();
        List<Program_Coaching_Assistant__c> progcoachassts = [SELECT Id, Program__c, Coaching_Assistant__r.Id, Coaching_Assistant__r.Primary_Email__c  FROM Program_Coaching_Assistant__c WHERE Program__c IN :programIds];
        Set<Id> coachasstIds = new Set<Id>();
        if(progcoachassts!=null && progcoachassts.size()>0){
        for (Program_Coaching_Assistant__c pca : progcoachassts) {
            coachasstIds.add(pca.Coaching_Assistant__c);
        }
        }
        System.debug('Coaching Assistants are' +coachasstIds);
        List<Coaching_Assistant__c> coachingassistants = [Select Id from Coaching_Assistant__c where Id IN :coachasstIds];
        System.debug('Coaching Assistants are' +coachingassistants);
        for( Program_Coaching_Assistant__c progcoachasst : progcoachassts){
            caByProgramId.put(progcoachasst.Program__c, new List<Coaching_Assistant__c>());
            
            caByProgramId.get(progcoachasst.Program__c).add(progcoachasst.Coaching_Assistant__r);
        }
        
            Set<String> uniqueEmails = new Set<String>();
        List<String> toadd = new List<String>();
        // Construct and send emails to Sales Persons
        for (Id registrationId : salespersonsbyRegId.keySet()) {
            List<Sales_Person__c> salesPersons = salespersonsbyRegId.get(registrationId);
            
            // Collect email addresses of Sales Persons
            List<String> salesPersonEmails = new List<String>();
            if(salesPersons!=null && salesPersons.size()>0){
            for (Sales_Person__c salesPerson : salesPersons) {
                if (salesPerson.Primary_Email__c != null && account.Allow_Attendance_email_for_Sales_Reps__c == true) {
                    salesPersonEmails.add(salesPerson.Primary_Email__c);   
                    //Adding salespersonemails to uniqueset                    
					for (String email : salesPersonEmails) {
                        if (!uniqueEmails.contains(email)) {
                            uniqueEmails.add(email);
                            System.debug(uniqueEmails);
                        }
                        System.debug(uniqueEmails);
                    }                                          
                }
            
                System.debug('salesPerson.Primary_Email__c: ' + salesPerson.Primary_Email__c);
                System.debug('Sales Person Emails are' +salesPersonEmails);
                System.debug('session Ids are' +sessionIds.size());
                System.debug('session Ids are' +program.id);
            }
        }
             System.debug('Sales Person Emails are' +salesPersonEmails);
             System.debug('uniqueEmails Person Emails are' +uniqueEmails);
          
        }       
        // Construct and send emails to Trainers
        for (Id programId : trainersByProgramId.keySet()) {
            
            // Collect email addresses of Trainers
            List<String> trainerEmails = new List<String>();
            if(programTrainers!=null && programTrainers.size()>0){
            for(Program_Trainer__c pts : programTrainers){
                if (pts.Trainer__r.Primary_Email_Address__c != null && account.Allow_Attendance_email_for_Trainers__c == true) {
                    trainerEmails.add(pts.Trainer__r.Primary_Email_Address__c);                    
                    for (String email : trainerEmails) {
                        if (!uniqueEmails.contains(email)) {
                            uniqueEmails.add(email);
                        }
                    }     
                }
            }
            }
            system.debug('uniqueEmails -trainers ' +uniqueEmails);
         
        }
        system.debug('uniqueEmails - ' +uniqueEmails);
        
        //Construct and send emails to coaching Assistants
        for (Id programId : caByProgramId.keySet()) {
            
            // Collect email addresses of Trainers
            List<String> coachingasstEmails = new List<String>();
            system.debug(caByProgramId);
            for(Coaching_Assistant__c ca : caByProgramId.get(programId)){
                if (ca.Primary_Email__c != null && account.Allow_Attendance_email_for_Coaching_Assi__c== true) {
                    coachingasstEmails.add(ca.Primary_Email__c);
                     for (String email : coachingasstEmails) {
                        if (!uniqueEmails.contains(email)) {
                            uniqueEmails.add(email);
                        }
                    }   
                }
            }
        }
            
            toadd.addAll(uniqueEmails);
        system.debug('toAdd - '+toadd);
            if (!uniqueEmails.isEmpty() ) {
                Datetime sessionDate = program.Latest_Session_Date_Attendance_Taken__c;
                system.debug('sessionDate -'+sessionDate);
                
            //string latestSessionDate= sessionDate.format('MMMM d, yyyy');
                //system.debug('system.debug(latestSessionDate.getUTCHours());-'+latestSessionDate);
	Datetime datetimeGMT = Datetime.valueOfGmt(sessionDate.formatGmt('yyyy-MM-dd HH:mm:ss'));
                system.debug('datetimeGMT - '+datetimeGMT);
                system.debug('datetimeGMT - '+datetimeGMT.format('MMMM d, yyyy'));
                string latestSessionDate= datetimeGMT.formatGMT('MMMM d, yyyy');
                if(( program.Program_Manager_Email__c != null &&  program.Program_Manager_Email__c != ''  )){
                    uniqueEmails.add(program.Program_Manager_Email__c);
                    System.debug( 'uni -' +uniqueEmails+ ' - ' +program.Program_Manager_Email__c);
                }
                system.debug(uniqueEmails);
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                PageReference pref = page.test;
                pref.getParameters().put('id',program.id);
                pref.setRedirect(true);
               Blob pdfBody;
                  if(Test.isRunningTest()){
           			 pdfBody = blob.valueOf('Unit.Test');
       				 }
                else{
           		 pdfBody = pref.getContent();
                } 
                Blob b = pdfBody;
                //Blob b = pref.getContent();
                attach.setFileName('AttendanceReport-'+program.Name+'.pdf');
                attach.setBody(b);
                email.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
                email.setToAddresses(toadd);
                email.setSubject('Session Attendance');
                //Datetime LatestSessionDate = program.Latest_Session_Date_Attendance_Taken__c;
                email.setHtmlBody('<p> </p><br/>'+
                                  '<p>Attached is the Session Attendance Report for Program '+ program.Name+
                                  '<br/><br/><b>Program : </b>' +program.Name+ 
                                  '<br/><b>Session Number : </b>'+program.Latest_Session_Number_Attendance_Taken__c+
                                  '<br/><b>Session Date : </b>'+latestSessionDate+
                                  '<br/><br/><br/></p>'+
                                  
                                  '');
                //email.setPlainTextBody('This is an hourly update email for sales persons.');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                System.debug('email sent' +email);
            }
        
    }
}