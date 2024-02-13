/******************************************************************************
 * A schedule batch job that runs through Opportunity Contact Roles 
 * and associates / assigns last contact source and primary contact on Opportunity.
 * 
 * This could be scheduled, or run manually.  If the ContactSourceAssignment
 * custom settings are NULL, we would want to run this to reprocess all
 * the opportunity contact roles.
 *
 * @Author:         Abdul Sattar (Magnet360)
 * @Date:           2015-04-28
 *
 * @Updates
 * 2015-05-14       Abdul Sattar (Magnet360)
 *                          Updated code to fix duplicate list item APEX bug.
 * 2015-05-26       Abdul Sattar (Magnet360)
 *                          Added LIMIT clause in query.
 *                          
 */

global with sharing class ContactSourceAssignment_Batch implements Database.Batchable<sObject>, Schedulable {
        public String query;
        public Boolean isFirstRun = FALSE;
        public Integer lastNDays = 7;
        public String dfgOppRT = Schema.SObjectType.Opportunity.RecordTypeInfosByName.get('DFG Opportunity').RecordTypeId;
        public String dfgConRT = Schema.SObjectType.Contact.RecordTypeInfosByName.get('DFG Contacts').RecordTypeId;
        
        /**
         * Constructor - Initializes custom settings and prepares query for batch
         */
        global ContactSourceAssignment_Batch() {
            // Initialize custom settings
            this.initCustomSettings();

            // Prepare batch query
            this.query  =   'SELECT Id, OpportunityId, ContactId, '
                                        + 'Opportunity.Id, Opportunity.Name, Opportunity.Primary_Contact__c, Opportunity.Primary_Contact_Last_Source_Key_Code__c, ' 
                                        + 'Contact.Id , Contact.Name, Contact.Last_Contact_Source_Key_Code__c, IsPrimary, LastModifiedDate, Opportunity.recordTypeId, Contact.RecordTypeId '
                                        + 'FROM OpportunityContactRole '
                                        + 'WHERE IsPrimary = TRUE AND Opportunity.OppProductNotNull__c != 0 AND Contact.Last_Contact_Source_Key_Code__c != null AND Opportunity.recordTypeId !=: dfgOppRT AND Contact.RecordTypeId !=: dfgConRT';

            this.query  +=  ( isFirstRun ? '' : ' AND LastModifiedDate = LAST_N_DAYS:' +  lastNDays);
            this.query  +=  ' ORDER BY CreatedDate DESC';
            this.query  +=  (Test.isRunningTest() ? ' LIMIT 200' : '');
        }
        
        /**
         * Batch job start-up
         * @param  bc - Current BatchableContext for batch
         * @return Returns appropriate Query Locator for batch query
         */
        global Database.QueryLocator start(Database.BatchableContext bc) {
            System.debug('SCS: this.query = ' + this.query);
            return Database.getQueryLocator(query);
        } //END: start
        
        /**
         * Batch job execute implementation
         * @param  BC           Current BatchableContext for batch
         * @param  ocrsList List of Opportunity Contact Roles
         */
        global void execute(Database.BatchableContext BC, list<OpportunityContactRole> ocrsList) {
            this.doContactSourceOppAssignments(ocrsList);
        } //END: execute

        /**
         * Batch job finish
         * @param  BC Current BatchableContext for batch
         */
        global void finish(Database.BatchableContext BC) {
            this.updateCustomSettings();
        }   //END: finish


        /**
        * Executes this schedule-able batch job
        * @param  sc - SchedulableContext for batch
        */
        global void execute(SchedulableContext sc) {
                ContactSourceAssignment_Batch batchClass = new ContactSourceAssignment_Batch(); 
                Database.ExecuteBatch(batchClass, 200);
        }   // END: execute(SchedulableContext sc)

        /**
         * Loop through all Opportunity Contact Roles and assign / associate the 
         * primary contact role & last contact source on related opportunities.
         * 
         * NOTE: An opportunity which is already associated to a primary contact role or 
         * last contact source is already populated on it, will be ignored.
         * 
         * @param ocrsList  List of Opportunity Contact Roles
         */
        public void doContactSourceOppAssignments(List<OpportunityContactRole> ocrsList) {
            System.debug('START: ContactSourceAssignment.doContactSourceOppAssignments');
            
            // List of update-able opportunities
            Map<Id, Opportunity> oppsToUpdate = new Map<Id, Opportunity>();

            // Loop through all OCS and update primary contact 
            // and last contact source, if applicable
            for (OpportunityContactRole ocr : ocrsList) {
                if(ocr.Opportunity.Primary_Contact__c == NULL || 
                    String.isBlank(ocr.Opportunity.Primary_Contact_Last_Source_Key_Code__c)) {
                    Opportunity opp = new Opportunity( Id = ocr.OpportunityId ,Primary_Contact__c = ocr.ContactId,
                                                        Primary_Contact_Last_Source_Key_Code__c = ocr.Contact.Last_Contact_Source_Key_Code__c);
                    oppsToUpdate.put(ocr.OpportunityId, opp);
                }
            }

            // Save to database
            if (oppsToUpdate.size() > 0) {
                UPDATE oppsToUpdate.values();
            }

            System.debug('END: ContactSourceAssignment.doContactSourceOppAssignments');
        }   // END: doContactSourceOppAssignments

        /**
         * Initialize custom settings for batch job
         */
        public void initCustomSettings() {
            ContactSourceAssignmentBatch__c cs = ContactSourceAssignmentBatch__C.getOrgDefaults();
                System.debug('SCS: ' + cs);
                 
                if (cs != NULL) {
                    isFirstRun = cs.First_Run__c;
                    lastNDays = (Integer) cs.Last_N_Days__c;
                }
        }   // END: initCustomSettings
        
        /**
         * Update custom settings for batch job, if needed
         */
        public void updateCustomSettings() {
            ContactSourceAssignmentBatch__c cs = ContactSourceAssignmentBatch__C.getOrgDefaults();
                System.debug('SCS: ' + cs);
                 
                if (cs != NULL && isFirstRun) {
                    cs.First_Run__c = FALSE;
                    UPDATE cs;
                }
        }   // END: initCustomSettings
}   // END: ContactSourceAssignment_Batch