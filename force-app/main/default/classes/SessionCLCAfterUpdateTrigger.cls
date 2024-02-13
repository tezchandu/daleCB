public class SessionCLCAfterUpdateTrigger {

public static Boolean isExecuting = false;
    
    List<Session_CLC_Event__c> updatedSessions = new List<Session_CLC_Event__c>();
    List<Session_CLC_Event__c> oldSessionslst = new List<Session_CLC_Event__c>();
    List<Session_CLC_Event__c> updatedDatesSessions = new List<Session_CLC_Event__c>();
    Set<Id> programIds = new Set<Id>();
    Integer TotalSessions;
    Integer sessionNum;
    Integer classCount = 0;
    Integer dayOffset = 2;
    // Step 1: Collect the updated sessions and program IDs
    
    public  void handleAfterUpdate(List<Session_CLC_Event__c> newSessions, Map<ID,Session_CLC_Event__c> oldMap) {
    if( !isExecuting ){
        system.debug('flag-- ' +isExecuting);
        if(newSessions!=null && newSessions.size()>0){
            system.debug('newSessions - ' +newSessions);
    for (Session_CLC_Event__c session : newSessions) {
        system.debug(session);
        Session_CLC_Event__c oldSession = oldMap.get(session.Id);
        system.debug(oldSession);
        //system.debug(Integer.valueof(session.Session_Number__c));
        //system.debug(session.Trainer_Certification_Event__r.Total_Sessions_with_Additional__c);
        if ((session.Session_Date__c != oldSession.Session_Date__c )&& Integer.valueOf(session.Session_Number__c) > 1 ) {
           // TotalSessions =  Integer.valueof(session.Trainer_Certification_Event__r.Total_Sessions_with_Additional__c) - Integer.valueof(session.Session_Number__c) ;
            sessionNum= Integer.valueof(session.Session_Number__c) ;
            updatedSessions.add(session);
            programIds.add(session.Trainer_Certification_Event__c);
            oldSessionslst.add(oldSession);
        }
    
    }
        }
    system.debug(updatedSessions);
    // Step 2: Adjust the date fields of remaining sessions
    if(!isExecuting){
        isExecuting=true;
    if (!updatedSessions.isEmpty()) {
        
        Map<Id, Trainer_Certification_Event__c> programMap = new Map<Id, Trainer_Certification_Event__c>(
            [SELECT Id, Session_One_Start_DateTime__c, Total_Sessions_with_Additional__c,Weekdays__c FROM Trainer_Certification_Event__c WHERE Id IN :programIds]
        );
        Trainer_Certification_Event__c prg = [select id,Total_Sessions_with_Additional__c from Trainer_Certification_Event__c where id in :programIds];
        TotalSessions = Integer.valueof(prg.Total_Sessions_with_Additional__c) - sessionNum;
        // Step 3: Adjust date fields of remaining sessions
        
        for (Session_CLC_Event__c session : [
            SELECT Id, Session_Date__c, Session_Number__c, Trainer_Certification_Event__c
            FROM Session_CLC_Event__c
            WHERE Trainer_Certification_Event__c IN :programIds 
        ]) {
            if(Integer.valueof(session.Session_Number__c) > Integer.valueof(updatedSessions[0].Session_Number__c))
            {
            
            system.debug(session.id);
            Trainer_Certification_Event__c program = programMap.get(session.Trainer_Certification_Event__c);
            Date startDate = updatedSessions[0].Session_Date__c;
            String weekdays = program.Weekdays__c;
            //integer sessNum = (Integer)updatedSessions[0].Session_Number__c;
            // Step 4: Determine the updated date based on session number and program start date
            Integer sessionNumberDiff = Integer.valueof(session.Session_Number__c) - Integer.valueof(updatedSessions[0].Session_Number__c);
           // Integer sessionNumberDif = 
            //Date adjDate = startDate.addDays(sessionNumberDiff * 7);
            Date adjDate = updatedSessions[0].Session_Date__c;
            Datetime adjustedDate = datetime.newInstance(adjDate.year(), adjDate.month(), adjDate.day());
            // Step 5: Adjust date field based on weekdays
            Set<Integer> selectedWeekdays = new Set<Integer>();
            String[] selectedWeekdaysList ;
           if (weekdays != null ) {
                selectedWeekdaysList = weekdays.split(';');
                
                 for (String weekday : selectedWeekdaysList) {
                    if (weekday == 'Sunday') {
                        selectedWeekdays.add(0);
                    } else if (weekday == 'Monday') {
                        selectedWeekdays.add(1);
                    } else if (weekday == 'Tuesday') {
                        selectedWeekdays.add(2);
                    } else if (weekday == 'Wednesday') {
                        selectedWeekdays.add(3);
                    } else if (weekday == 'Thursday') {
                        selectedWeekdays.add(4);
                    } else if (weekday == 'Friday') {
                        selectedWeekdays.add(5);
                    } else if (weekday == 'Saturday') {
                        selectedWeekdays.add(6);
                    }
                }
            }
            
            string adjustedWkday = adjustedDate.format('u');
            Integer adjustedWeekday = Integer.valueof(adjustedWkday);
            
            List<Date> datesList = new List<Date>();
            Datetime currentDate;
            
            
            while (classCount < totalSessions) {
                 currentDate = startDate.addDays(dayOffset);
               // Datetime cur = (Datetime) currentDate;
                String weekday = currentDate.format('EEEE');
                system.debug(currentDate);
                if (selectedWeekdaysList.contains(weekday)) {
                    datesList.add(currentDate.date());
                    classCount++;
                    break;
                }
                
                dayOffset++;
            }
            dayOffset++;
            system.debug(currentDate);
            system.debug('datesList--' +datesList);
         /**  while (!selectedWeekdaysList.contains(getWeekdayName(adjustedWeekday))) {
                adjustedDate = adjustedDate.addDays(1);
                adjustedWkday = adjustedDate.format('u');
                adjustedWeekday = Integer.valueof(adjustedWkday);
            }**/

            // Step 6: Update the adjusted session record
            Session_CLC_Event__c updateSessDates = new Session_CLC_Event__c();
            
            updateSessDates.Session_Date__c = currentDate.date();
            //updateSessDates.AttendanceTaken__c= true;
            updateSessDates.id=session.id;
            updatedDatesSessions.add(updateSessDates);
            }
        }
        
        system.debug(updatedDatesSessions);
        // Step 7: Update the adjusted sessions in the database
        update updatedDatesSessions;
        isExecuting= true;
        }
       // isExecuting= false;
    }
    }
    }
    private String getWeekdayName(Integer weekdayNumber) {
    String[] weekdays = new String[] { 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' };
    return weekdays[weekdayNumber - 1];
}
    
}