import { LightningElement,track,wire, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
import { RefreshEvent } from 'lightning/refresh';
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import getAcademyPicklistValues from '@salesforce/apex/TrainerCertificationEventRequestForm.getAcademyPicklistValues';
import getActiveAccountsPicklist from '@salesforce/apex/TrainerCertificationEventRequestForm.getActiveAccountsPicklist';
import getweekDaysValues from '@salesforce/apex/TrainerCertificationEventRequestForm.getweekDaysValues';
import getLanguageValues from '@salesforce/apex/TrainerCertificationEventController.getLanguageValues';
import handleSave from '@salesforce/apex/TrainerCertificationEventRequestForm.handleSave';
import getCustomSettings from '@salesforce/apex/TrainerCertificationEventRequestForm.getCustomSettings';

export default class EventRegistrationForm extends NavigationMixin(LightningElement)  {
    @track selectedAcademy;
    @track selectedEvent;
   @track controllerValue;
    @track weekDays ='';
    @track dependentValue ='';
    @track selectedAccountId ='';
    @track selectedEndTime ='';
    @track selectedStartTime ='';
    @track selectedDate ='';
    @track selectedEmail ='';
    @track selectedPhone ='';
    @track email = '';
    @track name = '';
    @track selectedPhone = '';
    @track city = '';
    @track state = '';
    @track country = ''; 
    @track zip = '';
    @track street = '';
    @track eventphone = '';
    @track recHotelName = '';
    @track recstreet = ''; 
    @track reccity = '';
    @track recstate = '';
    @track reccountry = ''; 
    @track reczip = '';
    @track recphone = '';
    @track publicprivate = '';
    @track language = '';
    @track selectedTotalSessions = '';
    @track message = false;
    @track redirect = false;
    languageOptions = [];
    updatedValues =[];
    weekDays = [];
    recphone = '';
    reqMaster = '';
    eventLoc = '';
    sessNotes = '';
    showConditionalFields = false;
    blended = false;
    @track controllingValues =[];
    @track accountOptions = [];
    @track academyOptions = [];
    @track eventTypeOptions = [];
    showError = false;

    publicprivateOptions = [
        { label: 'None', value: '' },
        { label: 'Public', value: 'Public' },
        { label: 'Private', value: 'Private' },
    ];

     @api objectApiName ='Trainer_Certification_Event__c';
    @api objectRecordTypeId ='';
    @track recID ='012Uz000000C2AxIAK';
    @api controllerFieldApiName='Academy__c';
    @api controllerFieldLabel ='Academy';
    @api dependentFieldApiName='Event_Type__c';
    @api dependentFieldLabel='Event Type';
     @track enteredTimeZone;
    @track controllerValue;
    @track dependentValue;
    @track selectedAdtnlSessions = '';
    @track controllingPicklist=[];
    controllingPicklist1=[];
    dependentPicklist;
    @track finalDependentVal=[];
    @track selectedControlling="--None--";
    weekDaysOptions =[];
    showpicklist = false;
    dependentDisabled=true;
    showdependent = false;
    @track trainerceId ='';

     @wire(getCustomSettings)
    mytrainerId({ data, error }) {
        if(data){
            console.log(data);
             console.log(JSON.stringify(data));
             this.trainerceId = data;
             this.objectRecordTypeId = data;
             console.log('trainercertevent Record Id - '+this.trainerceId);
        }else{
            console.log(error);
            console.log(JSON.stringify(error));
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: '$objectApiName', recordTypeId: '$recID' })
    fetchPicklist({error,data}){
         
        if(data ){
            console.log('dependpick ' +JSON.stringify(data.picklistFieldValues));
            let optionsValue = {}
            optionsValue["label"] = "--None--";
            optionsValue["value"] = "";
            this.controllingPicklist.push(optionsValue);
            data.picklistFieldValues[this.controllerFieldApiName].values.forEach(optionData => {
                this.controllingPicklist.push({label : optionData.label, value : optionData.value});
            });
            
            this.controllingValues = [
                 // Adjust the label and value as needed
                ...this.controllingPicklist.map(option => ({ label: option.label, value: option.value }))
            ];
            
            this.dependentPicklist = data.picklistFieldValues[this.dependentFieldApiName];
            this.showpicklist = true;
            console.log('controllingPicklist - '+JSON.stringify(this.controllingValues));
             console.log('dependentPicklist - '+this.dependentFieldApiName);
        } else if(error){
            console.log('error in depend class' +JSON.stringify(error));
            console.log('controllingPicklist - '+JSON.stringify(this.controllingValues));
        }
    }
 
    fetchDependentValue(event){
        console.log(event.target.value);
        this.dependentDisabled = true;
        this.finalDependentVal=[];
        this.showdependent = false;
        const selectedVal = event.target.value;
        this.controllerValue = selectedVal;
        this.finalDependentVal.push({label : "--None--", value : ""})
        let controllerValues = this.dependentPicklist.controllerValues;
        this.dependentPicklist.values.forEach(depVal => {
            depVal.validFor.forEach(depKey =>{
                if(depKey === controllerValues[selectedVal]){
                    this.dependentDisabled = false;
                    this.showdependent = true;
                    this.finalDependentVal.push({label : depVal.label, value : depVal.value});
                }
            });
              
        });
        console.log('finalDependentVal - '+JSON.stringify(this.finalDependentVal));
    }

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
        this.getAcademyPicklistValues();
        this.getActiveAccountsValuesFun();
        this.getLanguageValuesFun();
        this.getweekDaysFun();
    }

    getAcademyPicklistValues(){
        getAcademyPicklistValues({ })
            .then(result => {
                console.log(JSON.stringify(result));
                this.academyOptions = [
                    { label: 'None', value: '' }, // Adjust the label and value as needed
                    ...result.map(option => ({ label: option, value: option }))
                ];
                console.log('academyOptions - '+JSON.stringify(this.academyOptions));
               
            }).catch(error => {
                // Handle error
            });
    }

   
    callFromChild(event){
        this.controllerValue = event.detail.controllerValue;
        this.dependentValue = event.detail.dependentValue;
        this.selectedAcademy = event.detail.controllerValue;
        this.selectedEvent =  event.detail.dependentValue;
        //alert(this.controllerValue + '----' + this.dependentValue);
        console.log(JSON.stringify(event.detail));
         console.log('academy ' +this.controllerValue);
          console.log('eventtype ' +this.dependentValue);
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
            console.log('error - '+error);
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

    getweekDaysFun(){
        getweekDaysValues({ })
        .then(result => {
            console.log(JSON.stringify(result));
            this.weekDaysOptions = [
                // Adjust the label and value as needed
                ...result.map(option => ({ label: option, value: option }))
            ];
            console.log('weekDaysOptions - '+JSON.stringify(this.languageOptions));
           
        }).catch(error => {
            // Handle error
        });
    
    }

    handleCheckboxChange(event) {
        this.showConditionalFields = event.target.checked;
        this.onlineEvent  = event.target.value;
        console.log(this.showConditionalFields);
        console.log(this.onlineEvent);
    }

    handleblendedChange(event){
        this.blended = event.target.checked;
        this.onlineEvent  = event.target.value;
        console.log('blended - ' +this.blended);
        console.log(this.onlineEvent);
    }

    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        // Handle the selected account ID as needed
    }

    areRequiredFieldsFilled() {
        // Define an array of required field names
        console.log('err ');
        console.log('this.showConditionalFields - '+this.showConditionalFields);
        var requiredFields = [];
        if(!this.showConditionalFields) {
          requiredFields = ['academy',   'selectedAccountId', 'email', 'selectedTotalSessions', 'street', 'city', 'country', 'selectedDate', 'selectedStartTime', 'selectedEndTime', 'weekDays', 'eventLoc', 'reqMaster' ,
                                'publicprivate','language','enteredTimeZone'];
        }else{
            requiredFields = ['academy',   'selectedAccountId', 'email', 'selectedTotalSessions', 'selectedDate', 'selectedStartTime', 'selectedEndTime', 'weekDays', 'reqMaster' ,
                                'publicprivate','language','enteredTimeZone'];
        }
        console.log('requiredFields - '+requiredFields);
        for (const fieldName of requiredFields) {
            const inputField = this.template.querySelector(`[data-id="${fieldName}"]`);
            if (!inputField.value) {
                return false;
            }
        }

        return true;
    }

    handleInputChange(event){
         
        const dataId = event.target.getAttribute('data-id');
        const valGot = event.target.value;
        console.log(valGot +'event.target.getAttribute - ' +event.target.getAttribute('data-id') +'-'+ event.target.value);
        const eventId = event.target.getAttribute('data-name');
        console.log('event i d - '+eventId);
        if (dataId === 'email') {
                    this.email=valGot;
                }else if(dataId === 'name'){
                    this.name=valGot;
                }else if(dataId === 'selectedPhone'){
                    this.selectedPhone=valGot;
                }else if(dataId === 'selectedEmail'){
                    this.selectedEmail=valGot;
                }else if(dataId === 'selectedDate'){
                    this.selectedDate=valGot;
                }else if(dataId === 'selectedStartTime'){
                    this.selectedStartTime=valGot;
                }else if(dataId === 'selectedEndTime'){
                    this.selectedEndTime=valGot;
                }else if(dataId === 'city'){
                    this.city=valGot;
                }else if(dataId === 'country'){
                    this.country=valGot;
                }else if(dataId === 'state'){
                    this.state=valGot;
                }else if(dataId === 'street'){
                    this.street=valGot;
                }else if(dataId === 'zip'){
                    this.zip=valGot;
                } else if(dataId === 'eventphone'){
                    this.eventphone=valGot;
                } else if(dataId === 'recHotelName'){
                    this.recHotelName=valGot;
                } else if(dataId === 'recstreet'){
                    this.recstreet=valGot;
                } else if(dataId === 'reccity'){
                    this.reccity=valGot;
                } else if(dataId === 'recstate'){
                    this.recstate=valGot;
                } else if(dataId === 'reczip'){
                    this.reczip=valGot;
                } else if(dataId === 'reccountry'){
                    this.reccountry=valGot;
                } else if(dataId === 'language'){
                    this.language=valGot;
                }else if(dataId === 'recphone'){
                    this.recphone=valGot;
                }else if(dataId === 'weekDays'){
                    this.weekDays=valGot;
                }else if(dataId === 'addInfo'){
                    this.addInfo=valGot;
                } else if(dataId === 'reqMaster'){
                    this.reqMaster=valGot;
                }else if(dataId === 'eventLoc'){
                    this.eventLoc=valGot;
                }else if(dataId === 'sessNotes'){
                    this.sessNotes=valGot;
                }else if(dataId === 'showConditionalFields'){
                    this.showConditionalFields=valGot;
                }else if(dataId === 'publicprivate'){
                    this.publicprivate=valGot;
                }else if(dataId === 'selectedTotalSessions'){
                    this.selectedTotalSessions=valGot;
                }else if(dataId === 'selectedAdtnlSessions'){
                    this.selectedAdtnlSessions=valGot;
                }else if(dataId === 'enteredTimeZone'){
                    this.enteredTimeZone=valGot;
                }
        
            
            console.log('existingEntry - ' +this.updatedValues);
    }

    handleClickSave(){
        if (!this.areRequiredFieldsFilled()) {
            this.showError = true;
            console.log('this.showError true- ' + this.showError);
        } else {
        const newEntry = {
            
            country:null,
            email: null,
            name: null,
            selectedPhone: null,
            selectedEmail: null,
            selectedDate: null,
            selectedStartTime :null,
            city:null,
            state:null,
            street : null,
            zip:null,
            selectedEndTime :null,
            eventphone :null,
            recHotelName :null,
            reccountry : null,
            reccity : null,
            recstate : null,
            recstreet : null,
            reczip : null,
            recstate : null,
            language: '',
            weekDays :'',
            selectedAccountId : '',
            recphone : null,
            addInfo : null,
            reqMaster : null,
            eventLoc : null,
            sessNotes : null,
            controllerValue : null,
            dependentValue : null,
            showConditionalFields : '',
            publicprivate : null,
            selectedTotalSessions :  '',
            selectedAdtnlSessions : '',
            blended : '',
            enteredTimeZone : ''
        };
        
            newEntry.name=this.name;
            newEntry.email= this.email;
            newEntry.selectedPhone= this.selectedPhone;
            newEntry.selectedEmail= this.selectedEmail;
            newEntry.selectedDate= this.selectedDate;
            newEntry.eventphone= this.eventphone;
            newEntry.city= this.city;
            newEntry.country= this.country;
            newEntry.state= this.state;
            newEntry.street= this.street;
            newEntry.zip= this.zip;
            newEntry.selectedEndTime= this.selectedEndTime;
            newEntry.eventphone= this.eventphone;
            newEntry.recHotelName= this.recHotelName;
            newEntry.reccountry= this.reccountry;
             newEntry.reccity= this.reccity;
             newEntry.recstate= this.recstate;
            newEntry.recstreet= this.recstreet;
            newEntry.reczip= this.reczip;
            newEntry.recstate= this.recstate;
            newEntry.language= this.language;
            newEntry.selectedAccountId = this.selectedAccountId;
            newEntry.weekDays = this.weekDays;
            newEntry.recphone= this.recphone;
            newEntry.addInfo = this.addInfo;
            newEntry.reqMaster = this.reqMaster;
            newEntry.eventLoc = this.eventLoc;
            newEntry.sessNotes = this.sessNotes;
            newEntry.controllerValue = this.controllerValue;
            newEntry.dependentValue = this.dependentValue;
            newEntry.showConditionalFields = this.showConditionalFields;
            newEntry.selectedStartTime = this.selectedStartTime;
            newEntry.publicprivate = this.publicprivate;
            newEntry.selectedTotalSessions = this.selectedTotalSessions;
            newEntry.selectedAdtnlSessions = this.selectedAdtnlSessions;
            newEntry.blended = this.blended;
            newEntry.enteredTimeZone = this.enteredTimeZone;

        this.updatedValues.push(newEntry);
        console.log('this.updatedValues - '+ JSON.stringify(this.updatedValues));
        const updatedParams = JSON.stringify(this.updatedValues) ;
        console.log('updatedParams  - ' +updatedParams);
        handleSave({ wrapParams: updatedParams })
            .then(result => {
                /*this.showSuccessMessage = true;
                
                this.saveButtonClass = 'slds-m-left_x-small slds-button_success greenButton';
                setTimeout(() => {
                    this.showSuccessMessage = false;
                  }, 5000);
                  this.dispatchEvent(new CloseActionScreenEvent());*/
                 // window.alert(' Successfully Updated.');
                  this.disableSaveButton=true;
                   //window.location.reload();
                   setTimeout(() => {
                    this.message = true;
                    this.redirect = true; // Set the redirect flag to true
                }, 2000); 
                  const event = new CustomEvent('modalclosed');
                  console.log('this.message - '+this.message);
                  console.log('this.redirect - '+this.redirect);
                  //this.dispatchEvent(event);  
    
                          })
        .catch(error => {
                 console.log('error - '+error);
            });
    }
        console.log('existingEntry - ' +this.updatedValues);
       // this.handlePageRefresh();
    }

    handleClickCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    
    }
    handleRedirect() {
        if (this.redirect) {
            // Redirect to the form page (you need to specify the URL)
            // Replace '/your-form-url' with the actual URL of your form page
            const customUrl = '/CLCEventCommunity/';

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: customUrl
            }
        });
           // window.location.href = '/CLCEventCommunity/s/eventRequestForm';
        }
        console.log('this.message - '+this.message);
                  console.log('this.redirect - '+this.redirect);
    }
    handlePageRefresh(){
        //window.location.reload();
        //alert('save');
        this.dispatchEvent(new RefreshEvent());
        
        this.handleClickCancel();
    }
}