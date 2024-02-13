import { LightningElement ,api,wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { RefreshEvent } from 'lightning/refresh';
import { CloseActionScreenEvent } from 'lightning/actions';
import getEventTypeValues from '@salesforce/apex/TrainerCertificationEventController.getEventTypeValues';
import getCountryPicklistValues from '@salesforce/apex/TrainerCertificationEventController.getCountryPicklistValues';
import getDatePicklistValues from '@salesforce/apex/TrainerCertificationEventController.getDatePicklistValues';
import getTrainerCertEvent from '@salesforce/apex/TrainerCertificationEventController.getTrainerCertEvent';
import getStatusFromRecord from '@salesforce/apex/TrainerCertificationEventController.getStatusFromRecord';
const columns = [
    // Define your table columns here
    // Example: { label: 'Name', fieldName: 'Name', type: 'text' },
];
export default class CLCTrainerCertEvent extends NavigationMixin(LightningElement) {
    selectedStatus = '';
    selectedEventSubtype = '';
    selectedpublicprivate = '';
    selectedRegion = '';
    selectedDate = '';
    selectedEventtype = '';
    selectedStartDate = '';
    selectedEndDate = '';
    records = [];
    dateOptions = [];
    countryOptions = [];
    filteredRecords = [];
    regionOptions = [];
    eventTypeOptions = [];
    showChildComponent = false;
    @api eventID;
    @api showConfirmation = false; 
    @api showSuccessMessage = false;

    
    // Define column configuration for the datatable
    columns = [
        
        { label: 'Event Code', fieldName: 'Event_Code__c' },
        { label: 'Event Subtype', fieldName: 'Event_Subtype__c' },
        { label: 'Location', fieldName: 'Location__c' },
        { label: 'Date', fieldName: 'First_Online_Session_Date__c' },
        { label: 'Time', fieldName: 'First_Online_Session_Start_Time__c' },
        { label: 'Cost', fieldName: 'Estimated_Cost_per_Candidate__c' },
        { label: 'Deadline', fieldName: 'Event_Code__c' },
        { label: 'Public/Private', fieldName: 'Public_Private__c' },
        { label: 'Language', fieldName: 'Language__c' },
        { label: 'Master Trainer', fieldName: 'Master_Trainer_Fee__c' },
        { label: 'Max Seats', fieldName: 'Max_Registrations__c' },
        { label: 'Enrolled', fieldName: 'Level__c' },
        { label: 'Status', fieldName: 'Status__c' },
        // Add other fields as needed
    ];

    // Options for Status and Event Subtype comboboxes
    statusOptions = [
        { label: 'None', value: '' },
        { label: 'Forming', value: 'Forming' },
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Graduated', value: 'Graduated' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'Cancelled', value: 'Cancelled' },
    ];

    eventSubtypeOptions = [
        { label: 'None', value: '' },
        { label: 'Blended DNA', value: 'Blended DNA' },
        { label: 'Pre DNA MT Develop & Assets', value: 'Pre DNA MT Develop & Assets' },
    ];

    regionOptions = [
        { label: 'None', value: '' },
        { label: 'APAC', value: 'APAC' },
        { label: 'EMEA', value: 'EMEA' },
        { label: 'Latin America & Caribbean', value: 'Latin America & Caribbean' },
        { label: 'USA & Canada', value: 'USA & Canada' },
        { label: 'World Wide', value: 'World Wide' },
        
    ];

    publicprivateOptions = [
        { label: 'None', value: '' },
        { label: 'Public', value: 'Public' },
        { label: 'Private', value: 'Private' },
    ];

    @wire(getCountryPicklistValues)
    wiredCountryPicklistValues({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data));
            this.countryOptions = [
                { label: 'None', value: '' }, // Adjust the label and value as needed
                ...data.map(option => ({ label: option, value: option }))
            ];
            console.log('countryOptions - '+JSON.stringify(this.countryOptions));
           
        } else if (error) {
            console.error(error);
        }
    }

    @wire(getEventTypeValues)
    wiredEventTypeValues({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data));
            this.eventTypeOptions = [
                { label: 'None', value: '' }, // Adjust the label and value as needed
                ...data.map(option => ({ label: option, value: option }))
            ];
            console.log('eventTypeOptions - '+JSON.stringify(this.eventTypeOptions));
           
        } else if (error) {
            console.error(error);
        }
    }

    // Fetch picklist values for Date field
    @wire(getDatePicklistValues)
    //dateOptions;
    wiredDatePicklistValues({ error, data }) {
        if (data) {
            console.log(JSON.stringify(data));
            this.dateOptions = [
                { label: 'None', value: '' }, // Adjust the label and value as needed
                ...data.map(option => ({ label: option, value: option }))
            ];
            console.log('date - '+JSON.stringify(this.dateOptions));
           
        } else if (error) {
            console.error(error);
        }
    }
    
   
    
    // Fetch the records from the server
    @wire(getTrainerCertEvent)
    wiredTrainerCertEvent({ error, data }) {
        if (data) {
            console.log('data -' +JSON.stringify(data));
            //this.records = data;
            this.records = data.map(record => ({ ...record, isInProgress: record.Registration_Status__c === 'Open' }));

            this.filterRecords();
        } else if (error) {
            console.log(error);
        }
    }

   /* @wire(getStatusFromRecord)
    wiredStatus({ error, data }) {
        if (data) {
            // Check if the "Status" is "In Progress"
            this.isInProgress = data === 'In Progress';
        } else if (error) {
            console.error(error);
        }
    }*/

    // Handle Status filter change
    handlePublicPrivateChange(event) {
        //alert(event.detail.value);
        this.selectedpublicprivate = event.detail.value;
        this.filterRecords();
    }

    // Handle Event Subtype filter change
    handleEventtypeChange(event) {
        this.selectedEventtype = event.detail.value;
        this.filterRecords();
    }

    // Handle Country filter change
    handleRegionChange(event) {
        this.selectedRegion = event.detail.value;
        this.filterRecords();
    }

    // Handle Date filter change
    handleDateChange(event) {
        this.selectedDate = event.detail.value;
        this.filterRecords();
    }

    handleStartDateChange(event) {
        this.selectedStartDate = event.target.value;
        this.filterRecords();
    }
    
    handleEndDateChange(event) {
        this.selectedEndDate = event.target.value;
        this.filterRecords();
    }
    
    // Filter records based on selected Status and Event Subtype
    filterRecords() {
        
        //this.filteredRecords = this.records.filter(record => {
        //    if(record.status__c === 'In Progress'){
        //        record.isInProgress = true;
        //    }
        //});
        console.log('in filter - ' +JSON.stringify(this.records));
            //console.log( 'prog - '+this.isInProgress);
            const startDate = new Date(this.selectedStartDate);
            const endDate = new Date(this.selectedEndDate);
            const selectedEventtype = new Date(this.selectedEventtype);
            console.log( 'selectedEventtype - '+this.selectedEventtype);
        this.filteredRecords = this.records.filter(record => {
            return (
                
                (!this.selectedStartDate || startDate <= new Date(record.Session_One_Date_from_DateTime__c)) &&
                (!this.selectedEndDate || endDate >= new Date(record.Session_One_Date_from_DateTime__c)) &&
                (!this.selectedpublicprivate  || record.Public_Private__c === this.selectedpublicprivate) &&
                (!this.selectedEventtype || record.Event_Type__c === this.selectedEventtype) &&
                (!this.selectedRegion || record.Region__c === this.selectedRegion) && 
                (!this.selectedpublicprivate  || record.Public_Private__c === this.selectedpublicprivate ||
                (!this.selectedEventtype || record.Event_type__c === this.selectedEventtype) ||
                (!this.selectedRegion || record.Region__c === this.selectedRegion))
            );
        });
        console.log(JSON.stringify(this.filteredRecords));
    }

    handleRegister(){
        //this.showChildComponent = true;
        /*const pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__event-registration-form' // Replace 'ChildComponent' with the actual name
            }
        };

        // Navigate to the child component in a new page
        this[NavigationMixin.Navigate](pageReference);
*/
       this.showConfirmation = true;
        var compDefinition = {
            componentDef: "c:eventRegistrationForm",
            attributes: {
                propertyValue: "500"
            }
        };
        // Base64 encode the compDefinition JS object
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            }
        });
    }
    openChildComponent(event) {
        // Show the modal
         this.eventID = event.target.getAttribute('data-id');
        console.log('child - '+this.eventID);
        this.showChildComponent = true;
    }

    closeChildComponent() {
        // Close the modal
        this.showChildComponent = false;
       
    }

    handleClickSave(){
        this.handlePageRefresh();
    }
    handleClickCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    hanldeSubmitFormChange(event){
        console.log('showChildComponent - '+showChildComponent);
        this.showSuccessMessage = event.detail;
        this.showChildComponent = false;
    }
    handleRedirect() {
        if (this.redirect) {
            // Redirect to the form page (you need to specify the URL)
            // Replace '/your-form-url' with the actual URL of your form page
            const customUrl = '/CLCEventCommunity';

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: customUrl
            }
        });
           // window.location.href = '/CLCEventCommunity/s/eventRequestForm';
        }
        console.log('this.showConfirmation - '+this.showConfirmation);
                  console.log('this.redirect - '+this.redirect);
    }
    handlePageRefresh(){
        //window.location.reload();
        //alert('save');
        this.dispatchEvent(new RefreshEvent());
        
        this.handleClickCancel();
    }
}