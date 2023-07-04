import { LightningElement, wire, api ,track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getSessionNumberPicklistValues from '@salesforce/apex/AttendanceTaken.getSessionNumberPicklistValues';
import getRegistrationsByProgramId from '@salesforce/apex/RegistrationFecthforAttendance.getRegistrationsByProgramId';
export default class attendanceTakingScreen extends LightningElement {
    @api recordId;
    @track selectedSessionNumber;
    @track selectedSessionDate;
    @track fieldsInfo=[];
    @track awardPartA;
    @track awardPartB;
    @track attendedPartA;
    @track attendedPartB;

    errorMessage;
    sessionNumberPicklistValues = [];
    registrationRecords = []; 

    @wire(getSessionNumberPicklistValues, {id: '$recordId'})
    wiredSessionNumberPicklistValues({ data, error }) {
        console.log('data '+JSON.stringify(data));
        console.log('recordId -- '+this.recordId);
        if (data) {
            for(var key in data){
           
                this.fieldsInfo = data.map(option => ({
                    label: option.sessionNumber,
                    value: option.sessionNumber,
                    sessionDate: option.sessionDate
                }));
                console.log('this.obj '+JSON.stringify({label:key, value:data[key]}))
               // this.fieldsInfo.push({label:key, value:data[key]});
               //this.fieldsInfo = data;
                console.log('fieldsInfo '+this.fieldsInfo)
        }
     } else if (error) {
            // Handle the error
        }
    }
    fetchRegistrationRecords() {
        getRegistrationsByProgramId({ programId: this.recordId })
        .then(result => {
            this.registrationRecords = result.map(reg => ({
            Id: reg.Id,
             ContactName: reg.ContactName__r ? reg.ContactName__r.Name : '', // Map ContactName__r.Name field
           
        }));
            console.log('registrationRecords'  +this.registrationRecords);
        }) .catch(error => {
            // Handle error
        });
        
    }
    get computedClass() {
        return this.isFutureDateSelected ? 'error' : '';
    }
    get isFutureDateSelected() {
        
        const sessionDate = new Date(this.selectedSessionDate);
        const currentDate = new Date();
        return sessionDate > currentDate;
    }
    selectionChangeHandler(event) {
		this.selectedSessionNumber = event.target.value;
       console.log('selectedSessionNumber - ' +event.target.value);
        //console.log('selectedSessionNumber - ' );
		//	this.selectedSessionNumber = event.target.value;
         //   console.log('selectedSessionNumber - ' +selectedSessionNumber);
         const selectedSession = this.fieldsInfo.find(
            option => option.value === this.selectedSessionNumber
        );
        console.log('selectedSession== ' +selectedSession);
        if (selectedSession) {
            const sessionDate = new Date(selectedSession.sessionDate);
            const currentDate = new Date();
            console.log('sessionDate== ' +sessionDate);
            if (this.isFutureDateSelected) {
                this.selectedSessionNumber = null;
                this.selectedSessionDate = null;
                this.registrationRecords = []; // Clear registration records
                alert('Please select a session number with a past or current date.');
            } else {
                this.fetchRegistrationRecords();
                this.selectedSessionDate = selectedSession.sessionDate;
                console.log('selectedSessionDate 49== ' +this.selectedSessionDate);
                this.errorMessage = null;
            }
        }
       // this.selectedSessionDate = selectedSession ? selectedSession.sessionDate : null;    
	}
    handleAward(event){
        if(event.target.dataset.id === 'attendedPartA')
        this.attendedPartA = event.target.value;
        console.log('this.attendedPartA - '+this.attendedPartA);
        if(event.target.dataset.id === 'attendedPartB')
        this.attendedPartB = event.target.value;
        console.log('this.attendedPartB - '+this.attendedPartB);
        
        if(event.target.dataset.id === 'awardPartB')
        this.awardPartB = event.target.value;
        console.log('this.awardPartB - '+this.awardPartB);


    }
    handleSelectionChange(event){
        console.log('this.awardPartA ');
        this.awardPartA = event.detail;
        console.log('data '+JSON.stringify(this.awardPartA))
        console.log('this.awardPartA - '+this.awardPartA);
        

    }
	displayError(error) {
		this.error = 'Unknown error';
		if (Array.isArray(error.body)) {
			this.error = error.body.map(e => e.message).join(', ');
		} else if (typeof error.body.message === 'string') {
			this.error = error.body.message;
		}
	}
	get isPicklistDisabled() {
		return (this.options &&
			this.contrFieldValue !== 'Select') ? false : true;
	}
}