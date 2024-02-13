public class AttendanceEmailController {
    
    public Program__c program { get; set;}
    public List<Session__c> sessions {get; set;}
    public List<AttendanceWrapper> attendanceWrappers { get; set; }
    
    public Program_Location__c progloc {get; set;}
    public List<Registration__c> registrations { get; set; }
    public List<Sales_Person__c> salespersons { get; set; }
    public List<Attendance__c> attendances {get; set;}
    public Map<Id, String> salespersonsbyRegId  { get; set; }
    public Map<Id, String> registrationToattendances { get; set; }
    public Map<Id, String> sessionsByAttendance {get; set;}
    public Map<Id, String> test {get; set;}
    public   Map<String,Decimal> proPartnersPrevCost {get; set;}
    public   Map<String,list<Decimal>> proPartnersPrev2Cost {get; set;}
    public Map<string,List<String>> sessionattendance{get; set;}
    public Map<string,String> contactsPhone{get; set;}
    public Map<string,String> repMap{get; set;}
    public Map<string,String> regTypeMap{get; set;}
    public Map<string,String> exitTypeMap{get; set;}
    public Map<string,List<String>> attendanceRegs{get; set;}
    public Map<string,List<String>> sessionattendanceNew{get; set;}
    public List<String> sessionnumbers4Iterate {get; set;}
    public Set<String> sessionnumbers {get; set;}
    public List<String> regNames {get; set;}
    public  Set<String> namesList {get; set;}
    public String programName { get; set; }
    public String sessionName { get; set; }
    public String programlocation {get; set;}
    public String trainersText { get; private set; }
    public String salespersonsText {get; set;}
    public String attendancesText {get; set;}
    public Boolean orientation { get; set; }
    public String spnames {get; set;}
    
    public String attMarkValue {get; set;}
    public String attMark{get; set;}
    
    public String showSession1 {get; set;}
    public List<String> attVal { get; set; }  
    
    public AttendanceEmailController(ApexPages.StandardController stdController) {
        program = (Program__c)stdController.getRecord();
        System.debug('inside class' +program);   
        sessionattendance = new Map<String,List<String>>();
        sessionattendanceNew = new Map<String,List<String>>();
        sessionnumbers4Iterate = new List<String>();
        attendanceRegs= new  Map<string,List<String>> ();
        contactsPhone = new  Map<string,String>(); 
        exitTypeMap = new  Map<string,String>();
        repMap=new Map<string,String> ();
        regTypeMap =new Map<string,String>();
        
        loadRegistrations();
        
        loadTrainersText();
    }
    
    public void loadRegistrations() {
        Set<String> processedContacts = new Set<String>();
        attendanceWrappers = new List<AttendanceWrapper>();
        program = [Select Name,Weekdays__c, Program_Graduation_End_Date_Time__c,Latest_Session_Number_Attendance_Taken__c,Latest_Session_Date_Attendance_Taken__c, Program_Location__r.Location_Name__c,Program_Location_Value__c  from Program__c
                   where Id = :program.Id]; 
        sessions = [Select Id, Name, SessionDate__c, SessionNumber__c from Session__c WHERE Program__c =: program.Id ];   
        registrations = [SELECT Id, Name, Contact_Full_Name__c, ContactName__r.MobilePhone, ExitType__c, RegistrationType__c
                         ,Combined_Sales_Persons__c FROM Registration__c WHERE ProgramCode__c =: program.Id /* 'winning Program'*/];
        list<session__c> sess= [select id ,SessionNumber__c,AttendanceTaken__c ,(select id,name,Session_Completed__c,
                                                                                 AttendedPartA__c,AttendedPartB__c,AwardPartA__c,AwardPartB__c from Attendances__r) from Session__c where program__c = :program.Id ];
        attendances = [Select Id, Name,Program__c, AwardPartA__c, AwardPartA__r.Award_Code__c, AwardPartB__c, AwardPartB__r.Award_Code__c, Session__c,Session__r.SessionNumber__c, Session__r.AttendanceTaken__c, AttendedPartA__c,   
                       AttendedPartB__c, Registration__c, Contact_Name__c, Registration__r.RegistrationType__c, Registration__r.Combined_Sales_Persons__c ,Registration__r.Contact_Full_Name__c, 
                       Session_Number__c,Session_Attendance_Taken__c,Contact_Full_Name__c,Session_Completed__c,
                       Registration__r.ContactName__r.MobilePhone, Registration__r.ExitType__c from Attendance__c where 
                       Program__c =: program.Id   AND   Registration__c IN :registrations  ];
        list<attendance__c> atts = [select id, Name,Program__c, AwardPartA__c, AwardPartA__r.Award_Code__c, AwardPartB__c, AwardPartB__r.Award_Code__c, Session__c, AttendedPartA__c,   
                                    AttendedPartB__c,Session_Completed__c,Contact_Full_Name__c,Session_Number__c,Registration__r.RegistrationType__c,
                                    Registration__r.ContactName__r.MobilePhone,Registration__r.Combined_Sales_Persons__c,Session_Attendance_Taken__c from attendance__c where 
                                    Program__r.Name =:program.Name and Registration__c IN :registrations];
        
        
        
        List<Id> sessionIds = new List<Id>();
        List<String> sessionnumbersAtt = new List<String>();
        for (Attendance__c att : attendances){
            if(att.Session__c != null){
                sessionIds.add(att.Session__c);
                sessionnumbersAtt.add(att.Session_Number__c);
            }
        }
        sessionsByAttendance = new Map<Id, String>();
        Set<String> uniqueSessionNumbers = new Set<String>();
        system.debug('sessionIds - ' +sessionIds);
        if (!sessionIds.isEmpty()) {
            //  String attMark = '';
            attVal = new List<String>(sessionsByAttendance.values()) ;
            List<Session__c> sessions = [SELECT Id, Name,SessionNumber__c FROM Session__c WHERE  Program__r.Name =  :program.Name];
            
            sessionnumbers = new Set<String>();
            for(Session__c session : sessions){
                sessionnumbers4Iterate.add(session.SessionNumber__c);
                if(session.SessionNumber__c == 'Awareness'){
                    sessionnumbers.add('A');
                }if(session.SessionNumber__c == 'Sustainment'){
                    sessionnumbers.add('S');
                }if(session.SessionNumber__c == 'Orientation'){
                    sessionnumbers.add('O');
                }if((session.SessionNumber__c != 'Orientation') && (session.SessionNumber__c != 'Sustainment') && (session.SessionNumber__c != 'Awareness')){
                    sessionnumbers.add(session.SessionNumber__c);
                }
                
            }
            system.debug(attendances.size());
            system.debug(sessionnumbers);
            system.debug(sessionnumbers.size());
            List<String> attendanceRelatedVals = new List<String>();
            List<String> dummyList = new List<String>();
            dummyList.add('');
            regNames = new List<String>();
            List<String> workPhonesList = new List<String>();
            List<String> repList = new List<String>();
            namesList = new Set<String>();
            List<String> regTypeList = new List<String>();
            List<String> regsValues = new List<String>();
            for(Registration__c regs:registrations ){
                
                regNames.add(regs.Contact_Full_Name__c);
                namesList.add(regs.Contact_Full_Name__c);
                workPhonesList.add(regs.ContactName__r.MobilePhone);
                regsValues.add(regs.ContactName__r.MobilePhone);
                repList.add(regs.Combined_Sales_Persons__c);
                regTypeList.add(regs.RegistrationType__c);
                attendanceRegs.put(regs.Contact_Full_Name__c,regNames);
                
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
            }
            SYSTEM.DEBUG(namesList);
            SYSTEM.DEBUG(attendanceRegs);
            SYSTEM.DEBUG(contactsPhone);
            for (Attendance__c attendance : attendances) {
                
                if (!processedContacts.contains(attendance.Registration__r.Contact_Full_Name__c)) {
                    //String attMark = displayX(attendance);
                    System.debug('attMark is' +attMark);
                    attendanceWrappers.add(new AttendanceWrapper(attendance.Registration__r.Contact_Full_Name__c, attMark));
                    processedContacts.add(attendance.Registration__r.Contact_Full_Name__c);
                }
                system.debug('attendanceRegs ' +attendanceRegs);
            } 
            
            
            system.debug('regNames ' +regNames);
            for(string st :sessionnumbers4Iterate){
                System.debug('number is' +st);
                List<String> attendanceVals = new List<String>();
                List<String> dummyVals = new List<String>();
                for (Attendance__c attendance : atts) {
                    
                    system.debug('attendance' +attendance);
                    
                    
                    System.debug('Att Name' +attendance.Name+ 
                                 'AttMarkValue' +attMarkValue+ 
                                 'full name' +attendance.Contact_Full_Name__c+
                                 'SessionNumber' +attendance.Session_Number__c +
                                 'AttendedPartA__c' +attendance.AttendedPartA__c+
                                 'AttendedPartB__c' +attendance.AttendedPartB__c);
                    
                    if(st == attendance.Session_Number__c && (sessionnumbersAtt.contains(st))){
                        
                        system.debug('inside con : ' +attendance.Session_Number__c);
                        
                        if ((attendance.Session_Completed__c == true) && (attendance.AwardPartA__c == null && attendance.AwardPartB__c == null) &&                       
                            (attendance.AttendedPartA__c == 'Yes' && attendance.AttendedPartB__c == 'Yes'))
                        {
                            
                            attMark = 'X';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('X - '+sessionattendance);
                            
                        }
                        
                        if((attendance.Session_Completed__c == false)&&(attendance.AwardPartA__c == null && attendance.AwardPartB__c == null))
                        {
                            attMark = 'N';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('N - ' +sessionattendance);
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
                                system.debug('M - '+sessionattendance);
                            }
                 
                        if((attendance.Session_Completed__c == true)&&(attendance.AwardPartA__c != null || attendance.AwardPartB__c != null)){
                            
                            attMark = attendance.AwardPartA__r.Award_Code__c!=null ?attendance.AwardPartA__r.Award_Code__c :'' + ',' +attendance.AwardPartB__r.Award_Code__c!=null ?attendance.AwardPartB__r.Award_Code__c :'';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('attMark - ' +sessionattendance);
                            
                        }if((attendance.Session_Completed__c == false)&&(attendance.AwardPartA__c != null || attendance.AwardPartB__c != null)){
                            
                            attMark = attendance.AwardPartA__r.Award_Code__c!=null ?attendance.AwardPartA__r.Award_Code__c :'' + ',' +attendance.AwardPartB__r.Award_Code__c!=null ?attendance.AwardPartB__r.Award_Code__c :'';
                            attendanceVals.add(attMark);
                            sessionattendance.put(st, attendanceVals);
                            system.debug('attMark nULL - '+sessionattendance);
                        }                        
                        
                        system.debug(sessionattendance);
                    }
                    else if( (!(sessionnumbersAtt.contains(st)))){
                        system.debug('DUM - '+sessionattendance); 
                        dummyVals.add('NA');
                        sessionattendance.put(st, dummyList);
                    }
                    dummyVals.clear();
                    sessionattendanceNew.putAll(sessionattendance);
                }
                system.debug('sessionattendanceNew :'+sessionattendanceNew);
                system.debug('sessionattendance : ' +sessionattendance);
            }
        }
        system.debug('sessionattendanceNew :'+sessionattendanceNew);
    }
    
    public String getFormattedGraduationDate() {
        if (program != null && program.Program_Graduation_End_Date_Time__c != null) {
            Datetime datetimeGMT = Datetime.valueOfGmt(program.Program_Graduation_End_Date_Time__c.formatGmt('yyyy-MM-dd HH:mm:ss'));
            return datetimeGMT.formatGMT('MMMM d, yyyy');
        }
        return '';
    }
    public String getFormattedSessionDate() {
        if (program != null && program.Latest_Session_Date_Attendance_Taken__c != null) {
            Datetime sessionDate = program.Latest_Session_Date_Attendance_Taken__c;
            Datetime datetimeGMT = Datetime.valueOfGmt(sessionDate.formatGmt('yyyy-MM-dd HH:mm:ss'));
            return datetimeGMT.formatGMT('MMMM d, yyyy');
           // return sessionDate.format('MMMM d, yyyy');
        }
        return '';
    }
    
    
    private void loadTrainersText() {
        List<String> trainerNames = new List<String>();        
        for (Program_Trainer__c programTrainer : [SELECT Trainer__r.Name
                                                  FROM Program_Trainer__c
                                                  WHERE Program__c = :program.Id AND Type_of_Trainer__c='Trainer']) {
                                                      trainerNames.add(programTrainer.Trainer__r.Name);
                                                  }
        
        trainersText =  String.join(trainerNames, ', ');
    }
    
    public class AttendanceWrapper {
        public String contactFullName { get; set; }
        public String attMark { get; set; }
        public String attMarkN { get; set; }
        public Boolean showSession1 { get; set; }
        
        public AttendanceWrapper(String contactFullName, String attMark) {
            this.contactFullName = contactFullName;
            this.attMark = attMark;
            this.attMarkN = attMarkN;
            this.showSession1 = showSession1;
        }
    } 
    
    
}