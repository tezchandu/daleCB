global class MultipicklistFormatUpdate4Flow {
    @invocableMethod
    public static List<list<date>> CheckValues(List<sessionDetailsWrapper> requestList) {
        list<String> values=requestList[0].picklistvalues;
        integer totalSessions = requestList[0].totalSessions;
        dateTime startDate = requestList[0].startDate;
        if(!(values.isEmpty())){
            list<list<date>> finalDateLst = new list<list<date>>();
            
            list<list<string>> finalLst = new list<list<string>>();
            
            finalLst.add(values);
            system.debug(finalLst);
			DateTime startDate1 = startDate; // Start date
            
            List<Date> datesList = new List<Date>();
            
            Integer classCount = 0;
            Integer dayOffset = 0;
            
            while (classCount < totalSessions) {
                Datetime currentDate = startDate1.addDays(dayOffset);
               // Datetime cur = (Datetime) currentDate;
                String weekday = currentDate.formatGMT('EEEE');
                
                if (values.contains(weekday)) {
                    datesList.add(currentDate.date());
                    classCount++;
                }
                
                dayOffset++;
            }
            finalDateLst.add(datesList);
            System.debug(datesList);
            System.debug(finalDateLst);
            return finalDateLst;
          }
        else return null;
    
        
   }
    public class sessionDetailsWrapper{
        @InvocableVariable
        public List<string> picklistvalues;
        
        @InvocableVariable(required=true)
        public integer totalSessions;
        
        @InvocableVariable(required=true)
        public dateTime startDate;
    }
}