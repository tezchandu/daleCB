@isTest
private class ContactBeforeTriggerHandlerTest {
    
    static testMethod void testContactCurrencyIsoCode() {
        TestUtil testUtil = new TestUtil();
        User u = testUtil.getUsers(1, null)[0];
        u.DefaultCurrencyIsoCode = 'USD';
        Insert u;
        
        Account account = testUtil.getAccounts(2, null, u.Id)[0];
        insert account;
        
        List<Contact> contacts = testUtil.getContacts(2, account.Id);
        for(Contact c : contacts) {
            c.OwnerId = u.Id;
        }
        insert contacts;
        List<Contact> insertedContacts = [Select c.CurrencyIsoCode From Contact c Where c.Id IN :contacts];
        for (Contact c : insertedContacts) {
            System.assertEquals(u.DefaultCurrencyIsoCode , c.CurrencyIsoCode);
        }
    }
}