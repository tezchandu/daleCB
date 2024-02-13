@isTest
private class AccountBeforeTriggerHandlerTest {
    
    static testMethod void testAccountCurrencyIsoCode() {
        TestUtil testUtil = new TestUtil();
        User u = testUtil.getUsers(1, null)[0];
        u.DefaultCurrencyIsoCode = 'GBP';
        Insert u;
        
        List<Account> accounts = testUtil.getAccounts(2, null, u.Id);
        insert accounts;
        List<Account> insertedAccounts = [Select a.CurrencyIsoCode From Account a Where a.Id IN :accounts];
        for (Account a : insertedAccounts) {
            //System.assertEquals(u.DefaultCurrencyIsoCode , a.CurrencyIsoCode);
        }
    }
}