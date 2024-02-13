/**
 * trac_SFMCSyncService
 * @description Sync deleted contacts to a SFMC data extension
 *
 * @author Zi Zhang, Traction on Demand
 * @date 6/24/2019
 */

public with sharing class trac_SFMCSyncService {
    private String accessToken;

    public trac_SFMCSyncService() {
        accessToken = getAccessToken();

    }

    public void syncContacts(List<Contact> consToSync, Boolean isDeleted) {
        List<ContactBody> contactsBody = new List<ContactBody>();

        for(Contact c : consToSync) {
            System.debug(c);
            System.debug(c.Id);
            System.debug(c.MasterRecordId);
            KeysBody keys = new KeysBody(c.Id);
            ValuesBody values = new ValuesBody(c.MasterRecordId, String.valueOf(Date.today()), isDeleted);

            contactsBody.add(new ContactBody(keys, values));
        }
        System.debug(contactsBody);

        if(contactsBody.size() > 0) {
            makeSyncCallout(JSON.serialize(contactsBody));
        }
    }


    private void makeSyncCallout(String reqBody) {
        HttpResponse syncContactsResponse;
        System.debug('Request body' + reqBody);

        try {
            if (accessToken != null) {
                Http http = new Http();
                HttpRequest syncContactsRequest = new HttpRequest();
                syncContactsRequest.setMethod('POST');
                syncContactsRequest.setEndpoint('https://mcp3r8q8kwp-948t53rx18hk282y.rest.marketingcloudapis.com/hub/v1/dataevents/key:DeletedContact/rowset');
                syncContactsRequest.setHeader('Content-Type', 'application/json');
                syncContactsRequest.setHeader('Authorization', 'Bearer ' + accessToken);
                syncContactsRequest.setBody(reqBody);

                syncContactsResponse = http.send(syncContactsRequest);
            }
        } catch (System.Exception e){
            return;
        }
    }


    private String getAccessToken(){
        HttpRequest authRequest = new HttpRequest();
        authRequest.setEndpoint('callout:SFMC_Auth');

        AccessTokenRequest requestBody = new AccessTokenRequest('{!$Credential.UserName}', '{!$Credential.Password}');
        String body = JSON.serialize(requestBody);

        authRequest.setBody(body);

        try {
            String accessToken = sendRequest(authRequest);
            return accessToken;

        } catch (Exception e){
            return null;
        }
    }

    private String sendRequest(HttpRequest req){
        req.setMethod('POST');
        req.setTimeout(60000);
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse response = http.send(req);

        if (response.getStatusCode() == 200) {

            String responseBody = response.getBody();
            Map<String, Object> oauthMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);

            return (String) oauthMap.get('access_token');
        } else {
            if (Test.isRunningTest()) {
                return 'asdfghjkl1234567890';
            }

            return null;
        }
    }


    /* API Wrapper classes */

    public class AccessTokenRequest {
        public String grant_type;
        public String client_secret;
        public String client_id;

        public AccessTokenRequest(String client_id, String client_secret){
            this.client_id = client_id;
            this.client_secret = client_secret;
            grant_type = 'client_credentials';
        }
    }

    public class ContactBody {
        private KeysBody keys;
        private ValuesBody values;

        public ContactBody(KeysBody keys, ValuesBody values) {
            this.keys = keys;
            this.values = values;
        }
    }

    public class KeysBody {
        public String ContactID;

        public KeysBody(String conId) {
            this.ContactID = conId;
        }
    }

    public class ValuesBody {
        public String MasterRecordID;
        public String DeletedDate;
        public Boolean IsDeleted;

        public ValuesBody(String masterRecId, String deletedDate, Boolean isDeleted) {
            if(isDeleted) {
                this.MasterRecordID = masterRecId;
                this.DeletedDate = deletedDate;
                this.IsDeleted = isDeleted;
            }
        }
    }
}