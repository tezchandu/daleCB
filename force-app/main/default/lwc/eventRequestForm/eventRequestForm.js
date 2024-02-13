import {LightningElement,api, track, wire} from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { RefreshEvent } from 'lightning/refresh';
import { CloseActionScreenEvent } from 'lightning/actions';
import getEventTypeVal from '@salesforce/apex/TrainerCertificationEventController.getEventTypeVal';
import handleSave from '@salesforce/apex/TrainerCertificationEventController.handleSave';
import getLanguageValues from '@salesforce/apex/TrainerCertificationEventController.getLanguageValues';
import getSessions from '@salesforce/apex/TrainerCertificationEventController.getSessions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getActiveAccountsPicklist from '@salesforce/apex/TrainerCertificationEventRequestForm.getActiveAccountsPicklist';

export default class EventRequestForm extends NavigationMixin(LightningElement) {
    value = '';
    @api eventId ;
    timeZone;
    @track educationRows = [{ school: '', degreeType: '', location:'',major: '' }];
    @track email = '';
    @track confirmEmail = '';
    @track emailMismatch = false;
    @track eventType = '';
    @track eventLocation = '';
    @track eventCost = '';
    @track hostFranchise = '';
    @track LCname = '';
    @track LCEmail = '';
    @track LCstreetAddress = '';
    @track fieldsInfo = [];
    @track firstName ='';
    @track middleName = '';
    @track lastName = '';
    @track jobTitle = '';
    @track streetAddress = '';
    @track streetAddress2 = '';
    @track streetAddress1 = '';
    @track city = '';
    @track state = '';
    @track country = ''; 
    @track zip = '';
    @track telephone = '';
    @track extension = ''; 
    @track sessions = []; 
    @track emailAddress = '';
    @track confemailAddress = '';
    @track trainerManFN = '';
    @track trainerManLN = '';
    @track trainerManEmail = '';
    @track prgExpose = '';
    @track language = '';
    @track school = '';
    @track major = '';
    @track location='';
    @track degreeType = '';
    @track franchise = '';
    @track onlineEvent = false;
    @track addressType = '';
    @track updatedValues = [];
     @track message = true;
    @track redirect = false;
    @track showChildComponent = true;
      @api showConfirmation  = false;
    showError = false;
    @api isLoaded = false;
    languageOptions = []; 
    accountOptions = [];
    get options(){
    return [
            
            { label: 'Capt',value: 'Capt'},
            { label: 'Chief',value: 'Chief'},
            { label: 'Dr.',value: 'Dr.'},
            { label: 'Lieutenant',value: 'Lieutenant'},
            { label: 'Lt Col',value: 'Lt Col'},
            { label: 'Lieutenant',value: 'Lieutenant'},
            { label: 'Maj',value: 'Maj'},
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Mrs.',value: 'Mrs.'},
            { label: 'Ms.', value: 'Ms.' },
            { label: 'Prof.',value: 'Prof.'},
            { label: 'Rabbi.',value: 'Rabbi.'},
            { label: 'Sergeant',value: 'Sergeant'},
             ];
    }

    degreeTypeOptions = [
        { label: 'None', value: '' },
        { label: 'Bachelors', value: 'Bachelors' },
        { label: 'Masters', value: 'Masters' },
        { label: 'PhD', value: 'PhD' },
        
    ];

    prgmExpOptions = [
        { label: 'None', value: '' },
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
        { label: 'Not Applicable', value: 'Not Applicable' },
        
    ];

    addressTypeOptions = [
            { label: 'Home', value: 'Home' },
            { label: 'Business', value: 'Business' },
        ];

   
 
    handleDependentPicklist(event){
        this.dependentValue = event.target.value;
        // send this to parent 
        let paramData = {controllerValue : this.controllerValue, dependentValue : this.dependentValue};
        let ev = new CustomEvent('childmethod', 
                                 {detail : paramData}
                                );
        this.dispatchEvent(ev); 
    }
    
    connectedCallback() {
        //Here we explicitly call our Apex method(Imperative call)
        this.getEventTypeValFun();
        this.getLanguageValuesFun();
        this.getActiveAccountsValuesFun();
        this.getSessionRecs();
    }

    getSessionRecs(){
    getSessions({ eventId: this.eventId }) 
        .then(result => {
            console.log('sessions - ' +JSON.stringify(result));
            //this.sessions = result;
            this.sessions = result.map(reg => ({
             Id: reg.Id,
             sessionNumber: reg.Session_Number__c, // Default value for attendedPartA
             sessionDate: reg.Session_Date__c,
              // Default value for attendedPartB
              
             sessionTime: this.convertMillisecondsToTime(reg.Session_Start_Time__c) ,// Default value for awardPartA
             sessionStartTime: this.convertMillisecondsToTime(reg.Session_End_Time__c) 
              // Default value for awardPartB
             
            }));
            console.log('sessions after- ' +JSON.stringify(result));
         }).catch(error => {
             console.log('error - '+JSON.stringify(error));
              console.log(error);
            // Handle error
        });
    }
    

    getEventTypeValFun(){
        getEventTypeVal({ eventId : this.eventId })
        .then(result => {
        
            console.log('fieldsInfo '+JSON.stringify(result));
            /*for(var key in data){
                this.fieldsInfo = data.map(option => ({
                    eventLocation: option.name,
                    eventType: option.Location__c
                }));*/
                const record = result[0];
                console.log('fieldsInfo '+JSON.stringify(record));
            // Assign values to variables
            this.eventLocation = record.Location__c;
            this.eventType = record.Name;

            this.LCEmail = record.Contact_Email__c;
            this.LCname = record.Local_Contact_Name__c;
            this.LCstreetAddress = record.Street__c;
            this.eventCost = record.Estimated_Cost_per_Candidate__c;
            this.hostFranchise = record.Franchisee__r.Name;
            this.onlineEvent = record.Online_Event__c;
            
            if(record.Timezone_Notes__c!=null)
            this.timeZone = 'Sessions for This Event ' + '('+record.Timezone_Notes__c +')';
            else
            this.timeZone = 'Sessions for This Event ';
            console.log('eventLocation: ' + this.eventLocation);
            console.log('timeZone: ' + this.timeZone);
            console.log('eventType: ' + this.eventType);
            console.log('onlineEvent: ' + this.onlineEvent);
                //console.log('this.obj '+JSON.stringify({label:key, value:data[key]}))
               // this.fieldsInfo.push({label:key, value:data[key]});
               //this.fieldsInfo = data;
                console.log('fieldsInfo '+JSON.stringify(data));
            console.log('registrationRecords'  +JSON.stringify(this.registrationRecords));
        }).catch(error => {
            // Handle error
        });
    }

    getLanguageValuesFun(){
        getLanguageValues({ })
        .then(result => {
            console.log(JSON.stringify(result));
            this.languageOptions = [
                { label: 'None', value: '' }, // Adjust the label and value as needed
                ...result.map(option => ({ label: option, value: option }))
            ];
            console.log('languageOptions - '+JSON.stringify(this.languageOptions));
           
        }).catch(error => {
            // Handle error
        });
    
    }

    getActiveAccountsValuesFun(){
        getActiveAccountsPicklist({ })
        .then(result => {
            
                // Transform the result into an array of objects with 'label' and 'value'
                this.accountOptions = Object.keys(result).map(key => ({ label: result[key], value: key }));
            // Add a default 'None' option at the beginning of the array
                this.accountOptions.unshift({ label: 'None', value: '' });
                // Add a default 'None' option at the beginning of the array
               

                console.log('accountOptions - ' + JSON.stringify(this.accountOptions));
            
        }).catch(error => {
            console.log('error accountOptions- '+JSON.stringify(error));
            // Handle error
        });
    
    }

    handleEmailChange(event) {
        this.emailAddress = event.target.value;
        this.validateEmails();
    }

    handleConfirmEmailChange(event) {
        this.confirmEmail = event.target.value;
        this.validateEmails();
    }

   
    areRequiredFieldsFilled() {
        // Define an array of required field names
        const requiredFields = ['firstName', 'lastName', 'jobTitle', 'addressType', 'streetAddress', 'city', 'country', 'telephone', 'emailAddress', 'confemailAddress', 'trainerManFN', 'trainerManLN', 'trainerManEmail' ,
                                'zip','state'];

        for (const fieldName of requiredFields) {
            const inputField = this.template.querySelector(`[data-id="${fieldName}"]`);
            if (!inputField.value) {
                return false;
            }
        }

        return true;
    }

    validateEmails() {
        if (this.emailAddress === this.confirmEmail) {
            // Emails match
            this.emailMismatch = false;
        } else {
            // Emails do not match
            this.emailMismatch = true;
        }
    }
    handleInputChange(event) {
        const { name, value } = event.target;
        const index = event.target.dataset.index;
        this.educationRows[index][name] = value;
        console.log(this.educationRows);
        console.log(JSON.stringify(this.educationRows));
    }

    handleAddRow() {
        this.educationRows.push({ school: '', degreeType: '', location:'',major: ''});
    }

    handleRemoveRow(event) {
        const index = event.target.dataset.index;
        this.educationRows.splice(index, 1);
    }
    handleAccountChange(event){
        this.franchise = event.detail.value;
        console.log(this.franchise);
    }
    handlePrgmExpChange(event){
        this.prgExpose = event.detail.value;
        console.log(this.prgExpose);
    }
convertMillisecondsToTime(milliseconds) {
        console.log(milliseconds);
      if (isNaN(milliseconds)) {
        return '';
        }
     var hours = milliseconds / 3600000;
     console.log('hours  ', hours );
     if (hours == 12){
        var Hour12 = hours;
     }
     else{
            var Hour12 = Math.floor(hours)%12;
     }
    
    console.log('Hour12  ', Hour12 );
    var minutes1 = (hours-Math.floor(hours))*60;
    console.log('minutes1  ', minutes1 );
    var minutes2 =""
    if(minutes1<10){
            minutes2 = '0' + minutes1 
    }
    else{
        minutes2 = minutes1;
    }
    var temp ='';
    if(hours < 12 || hours == 24){
    temp = Hour12 +':'+minutes2 + ' AM';
    console.log('temp  ', temp );
    }
    else 
    {
    temp = Hour12 +':'+ minutes2 + ' PM';
    console.log('temp  ', temp );
    }
    console.log('time - ' +temp);
        //console.log('time - ' +formattedTime);
    //return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}.${String(millisecondsRemainder).padStart(3, '0')}`;
   return temp;
    }


    convertEndMillisecondsToTime(milliseconds) {
        console.log(milliseconds);
      if (isNaN(milliseconds)) {
        return '';
        }
     const hours = Math.floor(milliseconds / 3600000);
    const minutes = Math.floor((milliseconds % 3600000) / 60000);
    const seconds = Math.floor((milliseconds % 60000) / 1000);
    const millisecondsRemainder = milliseconds % 1000;
    const timeString = "13:00:00.000Z";
    const [hours1, minutes1] = timeString.match(/\d+/g).map(Number);

        const isPM = hours >= 12;
        const hh = isPM ? hours1 - 12 : hours1;
        const period = isPM ? "PM" : "AM";

        const formattedTime = `${hh.toString().padStart(2, '0')}:${minutes1.toString().padStart(2, '0')} ${period}`;
        console.log(formattedTime);
        console.log('time - ' +formattedTime);
    //return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}.${String(millisecondsRemainder).padStart(3, '0')}`;
   return formattedTime;
    }
    handleChange(event){
        const dataId = event.target.getAttribute('data-id');
        const valGot = event.target.value;
        console.log(valGot +'event.target.getAttribute - ' +event.target.getAttribute('data-id') +'-'+ event.target.value);
        const eventId = event.target.getAttribute('data-name');
        console.log('event i d - '+eventId);
        if (dataId === 'firstName') {
                    this.firstName=valGot;
                }else if(dataId === 'salutation'){
                    this.salutation=valGot;
                }else if(dataId === 'lastName'){
                    this.lastName=valGot;
                }else if(dataId === 'middleName'){
                    this.middleName=valGot;
                }else if(dataId === 'jobTitle'){
                    this.jobTitle=valGot;
                }else if(dataId === 'streetAddress'){
                    this.streetAddress=valGot;
                }else if(dataId === 'city'){
                    this.city=valGot;
                }else if(dataId === 'country'){
                    this.country=valGot;
                }else if(dataId === 'state'){
                    this.state=valGot;
                }else if(dataId === 'zip'){
                    this.zip=valGot;
                } else if(dataId === 'telephone'){
                    this.telephone=valGot;
                } else if(dataId === 'extension'){
                    this.extension=valGot;
                } else if(dataId === 'emailAddress'){
                    this.emailAddress=valGot;
                } else if(dataId === 'confemailAddress'){
                    this.confemailAddress=valGot;
                } else if(dataId === 'trainerManFN'){
                    this.trainerManFN=valGot;
                } else if(dataId === 'trainerManLN'){
                    this.trainerManLN=valGot;
                } else if(dataId === 'trainerManEmail'){
                    this.trainerManEmail=valGot;
                } else if(dataId === 'language'){
                    this.language=valGot;
                }else if(dataId === 'addressType'){
                    this.addressType=valGot;
                }
        
            
            console.log('existingEntry - ' +this.updatedValues);
    }

    
    
    handleClickSave(){
        if (!this.areRequiredFieldsFilled()) {
            this.showError = true;
            console.log('this.showError true- ' + this.showError);
        } else {
            // Submit logic here
            this.showError = false;
             this.isLoaded = !this.isLoaded;
        const newEntry = {
            eventID :this.eventId,
            country:null,
            firstName: null,
            lastName: null,
            middleName: null,
            jobTitle: null,
            streetAddress: null,
            salutation :null,
            city:null,
            state:null,
            zip:null,
            telephone :null,
            extension :null,
            emailAddress :null,
            confemailAddress :null,
            trainerManFN :null,
            trainerManLN :null,
            trainerManEmail :null,
            language :null,
            franchise : null,
            addressType : null,
            prgExpose : null,
            educationRows: []
        };
        
            newEntry.firstName=this.firstName;
            newEntry.salutation= this.salutation;
            newEntry.lastName= this.lastName;
            newEntry.middleName= this.middleName;
            newEntry.jobTitle= this.jobTitle;
            newEntry.streetAddress= this.streetAddress;
            newEntry.city= this.city;
            newEntry.country= this.country;
            newEntry.state= this.state;
            newEntry.zip= this.zip;
            newEntry.telephone= this.telephone;
            newEntry.extension= this.extension;
            newEntry.emailAddress= this.emailAddress;
            newEntry.confemailAddress= this.confemailAddress;
             newEntry.trainerManFN= this.trainerManFN;
             newEntry.trainerManLN= this.trainerManLN;
           newEntry.trainerManEmail= this.trainerManEmail;
           newEntry.prgExpose = this.prgExpose;
            newEntry.language= this.language;
            newEntry.franchise = this.franchise;
            newEntry.addressType = this.addressType;
            newEntry.educationRows= this.educationRows;
        
        this.updatedValues.push(newEntry);
        console.log('this.updatedValues - '+ JSON.stringify(this.updatedValues));
        const updatedParams = JSON.stringify(this.updatedValues) ;
        console.log('updatedParams  - ' +updatedParams);
        console.log('this.showConfirmation - '+this.showConfirmation);
        console.log('this.redirect bef sve - '+this.redirect);
        
            console.log('this.showError- ' + this.showError);
        handleSave({ wrapParams: updatedParams })
            .then(result => {
                    const selectedEvent = new CustomEvent("submitform", {
                    detail: this.message
                    });

                    setTimeout(() => {
                    this.message = true;
                    this.redirect = true;
                    //this.redirect = true; // Set the redirect flag to true
                }, 200); 
                    //this.dispatchEvent(selectedEvent);
                    //this.message = true;
                     // Set the redirect flag to true
                    //this.showConfirmation = true;
                     console.log('this.redirect sve - '+this.redirect);
                })
                
        .catch(error => {
            console.log('error while save - ' + JSON.stringify(error));
        });
        }
        console.log('existingEntry - ' +this.updatedValues);
        //this.handlePageRefresh();
    }

    handleClickCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    
    }
    closeChildComponent() {
        // Close the modal
        this.showChildComponent = false;
       
    }
    handleCancel(){
        this.redirect1 = true;
        this.handleRedirect1();
    }
    handleRedirect1() {
        if (this.redirect1) {
            
        var customUrl = '/CLCEventCommunity/';
         window.location.href = '/CLCEventCommunity/';
        location.reload();
        console.log('this.customUrl - '+customUrl);
           // window.location.href = '/CLCEventCommunity/s/eventRequestForm';
        //    /this.handlePageRefresh();
       }
        this.redirect1 = false;
        console.log('this.showConfirmation - '+this.showConfirmation);
        console.log('this.redirect - '+this.redirect);
    }
    handleRedirect() {
        if (this.redirect) {
            // Redirect to the form page (you need to specify the URL)
            // Replace '/your-form-url' with the actual URL of your form page
        var customUrl = '/CLCEventCommunity/';
/*
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: customUrl
            }
        });*/
         window.location.href = '/CLCEventCommunity/';
        location.reload();
        console.log('this.customUrl - '+customUrl);
           // window.location.href = '/CLCEventCommunity/s/eventRequestForm';
           this.handlePageRefresh();
       }
        this.redirect = false;
        console.log('this.showConfirmation - '+this.showConfirmation);
        console.log('this.redirect - '+this.redirect);
    }
    handlePageRefresh(){
       // window.location.reload();
        window.location.href = '/CLCEventCommunity/';
        location.reload();
        //alert('save');
        console.log('ddd');
        this.dispatchEvent(new RefreshEvent());
        
        //this.handleClickCancel();
    }
}