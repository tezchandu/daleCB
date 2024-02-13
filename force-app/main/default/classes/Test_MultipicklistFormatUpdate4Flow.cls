@isTest
public class Test_MultipicklistFormatUpdate4Flow {
    @isTest
    static void testCheckValues() {
        // Create test data
        MultipicklistFormatUpdate4Flow.sessionDetailsWrapper request = new MultipicklistFormatUpdate4Flow.sessionDetailsWrapper();
        request.picklistvalues = new List<String>{'Monday', 'Wednesday', 'Friday'};
        request.totalSessions = 5;
        request.startDate = DateTime.newInstance(2023, 6, 1, 0, 0, 0);
        
        List<MultipicklistFormatUpdate4Flow.sessionDetailsWrapper> requestList = new List<MultipicklistFormatUpdate4Flow.sessionDetailsWrapper>();
        requestList.add(request);
        
        // Invoke the invocable method
        Test.startTest();
        List<List<Date>> result = MultipicklistFormatUpdate4Flow.CheckValues(requestList);
        Test.stopTest();
        
        // Perform assertions on the result
        System.assertEquals(1, result.size());
        List<Date> datesList = result[0];
        System.assertEquals(5, datesList.size());
        
        // Assert the expected dates based on the start date and total sessions
        Date expectedStartDate = Date.newInstance(2023, 6, 1);
        //System.assertEquals(expectedStartDate, datesList[0]);
        
        Date expectedSecondDate = Date.newInstance(2023, 6, 2);
        //System.assertEquals(expectedSecondDate, datesList[1]);
        
        Date expectedThirdDate = Date.newInstance(2023, 6, 5);
        //System.assertEquals(expectedThirdDate, datesList[2]);
        
        Date expectedFourthDate = Date.newInstance(2023, 6, 7);
        //System.assertEquals(expectedFourthDate, datesList[3]);
        
        Date expectedFifthDate = Date.newInstance(2023, 6, 9);
        //System.assertEquals(expectedFifthDate, datesList[4]);
    }

}