public class SessionAfterUpdateTrigger {
public static Boolean isExecuting = false;
    
    List<Session__c> updatedSessions = new List<Session__c>();
    List<Session__c> updatedDatesSessions = new List<Session__c>();
    Set<Id> programIds = new Set<Id>();
    Integer TotalSessions;
    Integer sessionNum;
    Integer classCount = 0;
    Integer dayOffset = 2;
    // Step 1: Collect the updated sessions and program IDs
    
    public  void handleAfterUpdate(List<Session__c> newSessions, Map<ID,Session__c> oldMap) {
    if(trigger.isafter && !isExecuting ){
        system.debug('flag-- ' +isExecuting);
    for (Session__c session : newSessions) {
        system.debug(session);
        Session__c oldSession = oldMap.get(session.Id);
        system.debug(oldSession);
        //system.debug(Integer.valueof(session.SessionNumber__c));
        system.debug(session.Program__r.TotalSessions__c);
        system.debug('session.SessionDate__c ' +session.SessionDate__c);
        system.debug('oldSession.SessionDate__c '+oldSession.SessionDate__c);
        if ((session.SessionDate__c != oldSession.SessionDate__c )&& Integer.valueOf(session.SessionNumber__c) > 1 ) {
           // TotalSessions =  Integer.valueof(session.Program__r.TotalSessions__c) - Integer.valueof(session.SessionNumber__c) ;
           sessionNum= Integer.valueof(session.SessionNumber__c) ;
            updatedSessions.add(session);
            programIds.add(session.Program__c);
        }
    
    }
    system.debug(updatedSessions);
    // Step 2: Adjust the date fields of remaining sessions
    if(!isExecuting){
        isExecuting=true;
    if (!updatedSessions.isEmpty()) {
        Map<Id, Program__c> programMap = new Map<Id, Program__c>(
            [SELECT Id, Session1StartDateTime__c, TotalSessions__c,Weekdays__c FROM Program__c WHERE Id IN :programIds]
        );
        program__c prg = [select id,TotalSessions__c from program__c where id in :programIds];
        TotalSessions = Integer.valueof(prg.TotalSessions__c) - sessionNum;
        // Step 3: Adjust date fields of remaining sessions
        
        for (Session__c session : [
            SELECT Id, SessionDate__c, SessionNumber__c, Program__c
            FROM Session__c
            WHERE Program__c IN :programIds  
            AND SessionNumber__c!='Awareness' AND SessionNumber__c !='Orientation' AND SessionNumber__c!='Sustainment'
        ]) {
            
        if(Integer.valueof(session.SessionNumber__c) > Integer.valueof(updatedSessions[0].SessionNumber__c)){
            system.debug(session.SessionNumber__c);
            Program__c program = programMap.get(session.Program__c);
            Date startDate = updatedSessions[0].SessionDate__c;
            String weekdays = program.Weekdays__c;
            //integer sessNum = (Integer)updatedSessions[0].SessionNumber__c;
            // Step 4: Determine the updated date based on session number and program start date
            Integer sessionNumberDiff = Integer.valueof(session.SessionNumber__c) - Integer.valueof(updatedSessions[0].SessionNumber__c);
           // Integer sessionNumberDif = 
            //Date adjDate = startDate.addDays(sessionNumberDiff * 7);
            Date adjDate = updatedSessions[0].SessionDate__c;
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
            Session__c updateSessDates = new Session__c();
            
            updateSessDates.SessionDate__c = currentDate.date();
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