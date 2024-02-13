public with sharing class AttendanceController {
    public List<Attendance__c> currentAttendance {get;  set;}
    public List<Registration__c> registrations { get;  set; }
    public List<Session__c> sessions { get;  set; }
    public Program__c relatedProgram {get; set;}
    public List<String> sessionnumbers4Iterate {get; set;}
    public Map<string,List<String>> sessionattendanceNew{get; set;}
    public Map<string,List<String>> sessionattendance{get; set;}
    Public Map<Id, String> attrelatedSalesReps {get; set;}
    public Map<string,String> contactsPhone{get; set;}
    public Map<Id, String> RegContactFullName {get; set;}
    public Map<String, String> repMap {get; set;}
    public Map<String,String> regTypeMap{get; set;}
    public Map<string,String> exitTypeMap{get; set;}
    public String attMark{get; set;}
    public string prgName{get;set;}
    public String GradDate {get; set;}
    public String Day {get; set;}
    public String Location {get; set;}
    public String trainersText {get; set;}
    
    public Set<String> sessionnumbers {get; set;}
    public Set<String> namesList {get; set;}
    
    
    public AttendanceController(ApexPages.StandardController stdController) {
     //   relatedProgram = (Program__c)stdController.getRecord();
      //  relatedProgram = new List<Program__c>();
        sessionnumbers4Iterate = new List<String>();
        namesList = new Set<String>();
        contactsPhone = new  Map<string,String>();
        sessionattendanceNew = new Map<String,List<String>>();
        RegContactFullName = new Map<Id, String>();
        repMap = new Map<String, String>();
        exitTypeMap = new Map<String, String>();
        regTypeMap = new Map<String, String>();
        sessionattendance = new Map<string,List<String>>();
        fetchRelatedProgram('a113J000001KDJAQA4');
    }

  
    public  void fetchRelatedProgram(String attendanceId) {
        List<Id> programIds = new List<Id>();      
        List<Id> registrationIds = new List<Id>();       
        List<Id> sessionIds = new List<Id>();
        List<String> sessionnumbersAtt = new List<String>();  
        
        
        //1. fetching current Attendance
        List<Attendance__c>  currentAttendance = [SELECT Id, Registration__c,Session_Number__c, Session__c, Program__c FROM Attendance__c WHERE Id = 'a113J000001KDJAQA4' /* :attendanceId */ ];
        
        System.debug('inside class');
        // adding attendances related programs, sessions and registrations to the list                   
        for (Attendance__c att : currentAttendance){
            if(att.Session__c != null){
                sessionIds.add(att.Session__c);
                sessionnumbersAtt.add(att.Session_Number__c);
                
                if(att.Registration__c != null){
                    registrationIds.add(att.Registration__c);
                }
                
                if(att.Program__c != null){
                    programIds.add(att.Program__c);
                }
            }
        }
        List<Attendance__c>  allAttendances = [SELECT Id,Session_Completed__c,AwardPartA__c,AwardPartB__c ,
                                               AttendedPartA__c,AttendedPartB__c,AwardPartA__r.Name,AwardPartB__r.Name,
                                               Registration__c,Session_Number__c, Session__c, Program__c,AwardPartA__r.Award_Code__c,
                                               AwardPartB__r.Award_Code__c FROM Attendance__c WHERE program__c In :programIds /* :attendanceId */ AND Registration__c IN :registrationIds];
        //2.  fetching Program related to current Attendance
        if (currentAttendance != null && !currentAttendance.isEmpty() && currentAttendance[0].Program__c != null) {
            Program__c relatedProgram = [SELECT Id, Name,Weekdays__c, Program_Graduation_End_Date_Time__c, Program_Location__r.Location_Name__c FROM Program__c WHERE Id = :currentAttendance[0].Program__c];
            System.debug('Attendance related Program is ' + relatedProgram.Name);
            prgName = relatedProgram.Name;
            Day = relatedProgram.Weekdays__c;
            Location = relatedProgram.Program_Location__r.Location_Name__c;
            
            
            if (relatedProgram != null && relatedProgram.Program_Graduation_End_Date_Time__c != null) {
             GradDate = relatedProgram.Program_Graduation_End_Date_Time__c.format('MMMM d, yyyy');
            }
            else 
           GradDate = '';
        }
    
        //3. fetching Registrations related to current Attendance's Program
        
        List<Registration__c> registrations = [Select Id,ContactName__r.MobilePhone, ExitType__c, RegistrationType__c,
                                               Combined_Sales_Persons__c, ProgramCode__c, Contact_Full_Name__c 
                                               from Registration__c where ProgramCode__c IN :programIds];
        for(Registration__c regs : registrations){
            namesList.add(regs.Contact_Full_Name__c);
            System.debug('Participant list is' +namesList);            
            String mobilePhone = (regs.ContactName__r.MobilePhone != null) ? regs.ContactName__r.MobilePhone : '';
            contactsPhone.put(regs.Contact_Full_Name__c, mobilePhone);
            
            if(regs.Combined_Sales_Persons__c!=null)
                repMap.put(regs.Contact_Full_Name__c,regs.Combined_Sales_Persons__c);
            else
                repMap.put(regs.Contact_Full_Name__c,'');
            if(regs.RegistrationType__c != null)
                regTypeMap.put(regs.Contact_Full_Name__c,regs.RegistrationType__c);
            else
                regTypeMap.put(regs.Contact_Full_Name__c,'');
            if(regs.ExitType__c != null)
                exitTypeMap.put(regs.Contact_Full_Name__c,regs.ExitType__c);
            else
                exitTypeMap.put(regs.Contact_Full_Name__c,'');
            
            System.debug('Participant list is' +namesList);        
            System.debug('Registrations related to current Program' +registrations);
            System.debug('Registrations related to current Program' +registrations.size());
        }  
            //4. Fetching current Attendance's Program related Trainers
            
            List<String> trainerNames = new List<String>();
            String trainersText= '';
            
            for (Program_Trainer__c programTrainer : [SELECT Trainer__r.Name
                                                      FROM Program_Trainer__c
                                                      WHERE Program__c IN :programIds]) {
                                                          trainerNames.add(programTrainer.Trainer__r.Name);
                                                      }
            
            trainersText =  String.join(trainerNames, ', ');
            System.Debug('Program related Trainers are' +trainersText);
            
            //5. Fetching Sessions related to current Attendance's Program
            List<session__c> sessions= [select id ,SessionNumber__c from Session__c 
                                        where program__c IN :programIds AND AttendanceTaken__c= true];
            system.debug('program related sessions are' +sessions);
            system.debug('program related sessions are' +sessions.size());

            
            sessionnumbers = new Set<String>();
            
            for (Session__c sess : sessions) {
                //sessionNumbers.add(sess.SessionNumber__c);
                
                sessionnumbers4Iterate.add(sess.SessionNumber__c);
                if(sess.SessionNumber__c == 'Awareness'){
                    sessionnumbers.add('A');
                }if(sess.SessionNumber__c == 'Sustainment'){
                    sessionnumbers.add('S');
                }if(sess.SessionNumber__c == 'Orientation'){
                    sessionnumbers.add('O');
                }if((sess.SessionNumber__c != 'Orientation') && (sess.SessionNumber__c != 'Sustainment') && (sess.SessionNumber__c != 'Awareness')){
                    sessionnumbers.add(sess.SessionNumber__c);
                }
                
			}
            system.debug('sessionnumbers4Iterate: '+sessionnumbers4Iterate.size());
            System.debug('session numbers set is' +sessionnumbers);
            List<String> dummyList = new List<String>();
            dummyList.add('');
            
            for(string st :sessionnumbers){
                List<String> attendanceVals = new List<String>();
                for (Attendance__c attendance : allAttendances) {
                    system.debug(attendance.Session_Number__c);
                    System.debug('st' +st);
                    if(st == attendance.Session_Number__c && sessionnumbers.contains(attendance.Session_Number__c)){
                        System.debug('Inside Main If');
                        if ((attendance.Session_Completed__c == true) && (attendance.AwardPartA__c == null && attendance.AwardPartB__c == null) &&                       
                            (attendance.AttendedPartA__c == 'Yes' && attendance.AttendedPartA__c == 'Yes'))
                        {                            
                            attMark = 'X';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('X attendance  ' +sessionattendance);                            
                        }
                        
                        if((attendance.Session_Completed__c == false)&&(attendance.AwardPartA__c == null && attendance.AwardPartB__c == null))
                        {
                            attMark = 'N';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('N attendance'+sessionattendance);
                        }
                        
                        if((attendance.Session_Completed__c == true)&&(attendance.AwardPartA__c == null && attendance.AwardPartB__c == null) &&
                           ((attendance.AttendedPartA__c == 'Makeup' && attendance.AttendedPartB__c == 'Yes')||
                            (attendance.AttendedPartA__c == 'Makeup' && attendance.AttendedPartB__c == 'Makeup')||
                            (attendance.AttendedPartA__c == 'Makeup' && attendance.AttendedPartB__c == 'Yes(Transfer)') ||
                            (attendance.AttendedPartA__c == 'Yes' && attendance.AttendedPartB__c == 'Makeup')||
                            (attendance.AttendedPartA__c == 'Yes(Transfer)' && attendance.AttendedPartB__c == 'Makeup'))){
                                
                                attMark = 'M';
                                attendanceVals.add(attMark);
                                sessionattendance.put(st, attendanceVals);
                                system.debug('MakeUp attendance' + sessionattendance);
                            }
                        
                        if((attendance.Session_Completed__c == true)&&(attendance.AwardPartA__c != null || attendance.AwardPartB__c != null)){
                            
                            attMark = attendance.AwardPartA__r.Award_Code__c + ',' +attendance.AwardPartB__r.Award_Code__c;
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug(sessionattendance);
                            
                        }if((attendance.Session_Completed__c == false)&&(attendance.AwardPartA__c != null || attendance.AwardPartB__c != null)){
                            
                            attMark = attendance.AwardPartA__r.Award_Code__c + ',' +attendance.AwardPartB__r.Award_Code__c;
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('AwardCodes'+sessionattendance);
                        } 
                        system.debug(sessionattendance);
                   }
                    else if(!(sessionnumbers.contains(attendance.Session_Number__c)) || (!(sessionnumbersAtt.contains(st)))){
                        system.debug('dummmy ' +sessionattendance);
                        sessionattendance.put(st, dummyList);
                    } 
                    sessionattendanceNew.putAll(sessionattendance);
                }
                system.debug('sessionattendanceNew :'+sessionattendanceNew);
                system.debug('sessionattendance : ' +sessionattendance);
                 system.debug('sessionnumbers4Iterate : ' +sessionnumbers4Iterate);
            }
}
}