@isTest
private class MultiSelectFlowValuesTest {
    @isTest
    static void testCheckValues() {
        // Create test data
        List<String> values = new List<String>{'Value1;Value2;Value3'};
        
        // Invoke the invocable method
        Test.startTest();
        List<List<String>> result = MultiSelectFlowValues.CheckValues(values);
        Test.stopTest();
        
        // Perform assertions on the result
        System.assertEquals(1, result.size());
        List<String> resultList = result[0];
        System.assertEquals(3, resultList.size());
        
        // Assert the expected values
        System.assertEquals('Value1', resultList[0]);
        System.assertEquals('Value2', resultList[1]);
        System.assertEquals('Value3', resultList[2]);
    }
}