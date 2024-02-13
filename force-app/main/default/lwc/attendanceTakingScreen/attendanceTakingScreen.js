import { LightningElement, wire, api ,track} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import insertAttendanceRec from '@salesforce/apex/AttendanceTaken.insertAttendanceRec';
import getSessionNumberPicklistValues from '@salesforce/apex/AttendanceTaken.getSessionNumberPicklistValues';
import getRegistrationsByProgramId from '@salesforce/apex/AttendanceTaken.getRegistrationsByProgramId';
import getSessionAttendance from '@salesforce/apex/AttendanceTaken.getSessionAttendance';
import checkAttendanceTransfer from '@salesforce/apex/AttendanceTaken.checkAttendanceTransfer';
import checkAttendanceExists from '@salesforce/apex/AttendanceTaken.checkAttendanceExists';
import getCustomSettings from '@salesforce/apex/AttendanceTaken.getCustomSettings';

import { RefreshEvent } from 'lightning/refresh';
export default class attendanceTakingScreen extends LightningElement {
    @api recordId;
    @track selectedSessionNumber;
    @track selectedSessionDate;
    @track fieldsInfo=[];
    @track awardPartA;
    @track awardPartB;
    @track attendedPartA;
    @track attendedPartB;
    @track errorBoo;
    @api selectedAwardId;
    @api sessionId ;
    @api sessionName;
    @api regID;
    @api contName;
    @track redirectURL='';
    errorMessage;
    saveDisabled = false;
    sessId;
    hideEditButton =false;
    @track attendedVal ='Yes';
    @track showSuccessMessage = false;
    @track saveButtonClass = 'slds-m-left_x-small';
    sessionNumberPicklistValues = [];
    registrationRecords = []; 
    registrationRecordsWithAttendance =[];
    attendedVals = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' },
        { label: 'Makeup', value: 'Makeup' },
        { label: 'Yes (Transfer)', value: 'Yes (Transfer)' },
        { label: 'No (Transfer)', value: 'No (Transfer)' },
        { label: 'Makeup (Transfer)', value: 'Makeup (Transfer)' },
        // Add more options if needed
    ];
    awardMapA = new Map() ;
    awardMapB = new Map();
     attendMapA = new Map();
      attendMapB = new Map();
      updatedValues = [];

    @wire(getSessionNumberPicklistValues, {id: '$recordId'})
    wiredSessionNumberPicklistValues({ data, error }) {
        console.log('data '+JSON.stringify(data));
        console.log('recordId -- '+this.recordId);
        if (data) {
            for(var key in data){
           
                this.fieldsInfo = data.map(option => ({
                    label: option.sessionNumber,
                    value: option.sessionNumber,
                    sessionDate: option.sessionDate,
                    id : option.id,
                    name : option.sessionName
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

    @wire(getCustomSettings)
    myredirectURLS({ data, error }) {
        if(data){
            console.log(data);
             console.log(JSON.stringify(data));
             this.redirectURL = data;
             console.log('redirectURL - '+this.redirectURL);
        }else{
            console.log(error);
            console.log(JSON.stringify(error));
        }
    }

    fetchRegistrationRecords() {
        getRegistrationsByProgramId({ programId: this.recordId })
        .then(result => {
            this.registrationRecords = result.map(reg => ({
             Id: reg.Id,
             ContactName: reg.ContactName__r ? reg.ContactName__r.Name : '', // Map ContactName__r.Name field
             atPartA: 'Yes', // Default value for attendedPartA
             atPartB: 'Yes', // Default value for attendedPartB
             awPartA: null, // Default value for awardPartA
             awPartB: null  // Default value for awardPartB
             
            }));
            console.log('registrationRecords'  +this.registrationRecords);
            const selectedSession = this.fieldsInfo.find(
                option => option.value === this.selectedSessionNumber
            );
            this.sessionId = selectedSession.id;
            console.log('sess  id ==== ' +this.sessionId);
            const registrationIds = this.registrationRecords.map(reg => reg.Id);
            console.log('registrationIds ==== '+registrationIds);
            getSessionAttendance({ sessionIds: [this.sessionId], registrationIds: registrationIds })
            
            .then(attendanceResult => {
                if(!attendanceResult || attendanceResult.length === 0){
                   
                    this.hideEditButton = true;
                    this.registrationRecords = this.registrationRecords.map(registration => {
                        console.log(registration.Id);
                        registration.hideEditButton=true;
                        registration.editMode = false ;
                        const attendanceMap = new Map();
                            attendanceResult.forEach(att => {
                                attendanceMap.set(att.Registration__c, att);
                            });

                            // Create a new list to hold registration records with attendance data
                            this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                const attendanceRecord = attendanceMap.get(reg.Id);
                                return {
                                    ...reg,
                                    atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
                                    atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                    awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                    awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null
                                };
                            });
                        console.log('registration.isdisabledattendance else- '+registration.editMode);
                        const selectedValues = {}; 
                        this.registrationRecords.forEach(reg => {
                            selectedValues[reg.Id] = reg.awPartA; // Assuming you are updating awPartA here
                        });
        
                        // Call the updateSelectedValues method of LookupInput component to update the values
                        const lookupInput = this.template.querySelector('c-lookup-Input');
                        console.log('in - '+lookupInput);
                        if (lookupInput) {
                            console.log(lookupInput);
                            //lookupInput.updateSelectedValues(selectedValues);
                        }
                        return registration;
                    });
                    console.log('hide in if - '+this.hideEditButton);
                }
                else
				{
                    this.hideEditButton=false;
                    const selectedSession = this.fieldsInfo.find(
                        option => option.value === this.selectedSessionNumber
                    );
                    this.sessionId = selectedSession.id;
                    console.log('sess  id ==== ' +this.sessionId);
                    const registrationIds = this.registrationRecords.map(reg => reg.Id);
                    console.log('registrationIds ==== '+registrationIds);
                    /*const attendanceMap = new Map();
                            attendanceResult.forEach(att => {
                                attendanceMap.set(att.Registration__c, att);
                            });
                            console.log('before attendanceMap - ' +attendanceMap);
                    this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
					const attendanceRecord = attendanceMap.get(reg.Id);
					return {
							...reg,
							atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
							atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
							awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
							awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
							hideEditButton: false, // Set hideEditButton to false when attendance exists
							editMode: true, // Set editMode to true when attendance exists
					};
                
					});*/
                 checkAttendanceTransfer({ sessionIds: [this.sessionId], registrationIds: registrationIds , programId : this.recordId})
                    .then(checkAttendanceTransfer => {
                        if(checkAttendanceTransfer){
                            this.registrationRecords.forEach(reg => {
                            const attendanceRecord = checkAttendanceTransfer.find(att =>  att.Registration__c === reg.Id);
                                if (attendanceRecord) {
                                    reg.hideEditButton=false;
                                    reg.editMode=true;
                                    const attendanceMap = new Map();
                                    attendanceResult.forEach(att => {
                                        attendanceMap.set(att.Registration__c, att);
                                    });
									console.log('transfer attendanceMap - ' +JSON.stringify(attendanceMap));
                                    // Create a new list to hold registration records with attendance data
                                    this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                        const attendanceRecord = attendanceMap.get(reg.Id);
                                        const hasAttendance = !!attendanceRecord;
                                        return {
                                            ...reg,
                                            atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes' ) : 'Yes',
                                            atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                            awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                            awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
                                             hideEditButton: !hasAttendance, // Set hideEditButton to true if no attendance exists
                                             editMode: hasAttendance,
                                        };
                                    });
                                
                                    console.log('registration.isdisabledattendance attendanceRecord- '+JSON.stringify(this.registrationRecordsWithAttendance));
                                    
                                } 
                                else {
                                    checkAttendanceExists({ programId : this.recordId,sessionIds: this.sessionId })
                                    .then(checkAttendanceExists => {
                                        if(checkAttendanceExists){
                                            this.registrationRecords.forEach(reg => {
                                            const regRecord = checkAttendanceExists.find(regs =>  regs.Id === reg.Id);
                                            if(regRecord){
                                             reg.hideEditButton=true;
                                            reg.editMode=false;
                                            const attendanceMap = new Map();
                                            attendanceResult.forEach(att => {
                                                attendanceMap.set(att.Registration__c, att);
                                            });
                                            this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                                const attendanceRecord = attendanceMap.get(reg.Id);
                                                const hasAttendance = !!attendanceRecord;
                                                return {
                                                    ...reg,
                                                    atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
                                                    atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                                    awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                                    awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
                                                    hideEditButton: !hasAttendance, // Set hideEditButton to true if no attendance exists
                                                    editMode: hasAttendance,
                                                };
                                            });
                                            console.log(' if no attendance - '+JSON.stringify(this.registrationRecordsWithAttendance));
                                            }
                                        else{
                                            reg.hideEditButton=false;
                                            reg.editMode=true;
                                            const attendanceMap = new Map();
                                            attendanceResult.forEach(att => {
                                                attendanceMap.set(att.Registration__c, att);
                                            });
                                            this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                                const attendanceRecord = attendanceMap.get(reg.Id);
                                                 const hasAttendance = !!attendanceRecord;
                                                return {
                                                    ...reg,
                                                    atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
                                                    atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                                    awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                                    awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
                                                    hideEditButton: !hasAttendance, // Set hideEditButton to true if no attendance exists
                                                    editMode: hasAttendance,
                                                };
                                            });

                                            }
                                            });
                                             console.log('else there are attendance - '+JSON.stringify(this.registrationRecordsWithAttendance));
                                        }
                                    });
                                    console.log('registration.isdisabledattendance attendanceRecordese- '+reg.editMode);
                                    console.log('after reg- '+JSON.stringify(this.registrationRecordsWithAttendance));
                                    
                                }
                                return reg;
                            })
                        }
						else
						{
                            checkAttendanceExists({ programId : this.recordId,sessionIds: this.sessionId })
                            .then(checkAttendanceExists => {
                                console.log('checkAttendanceExists ef - '+checkAttendanceExists);
                            if(checkAttendanceExists)
                            {
                                console.log('checkAttendanceExists - '+checkAttendanceExists);
                                this.registrationRecords.forEach(reg => {
                                 const regRecord = checkAttendanceExists.find(regs =>  regs.Id === reg.Id);
                                    if(regRecord)
                                    {
                                        console.log('regRecord - '+regRecord);
                                             reg.hideEditButton=true;
                                            reg.editMode=false;
                                            const attendanceMap = new Map();
                                            attendanceResult.forEach(att => {
                                                attendanceMap.set(att.Registration__c, att);
                                            });
                                            this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                                const attendanceRecord = attendanceMap.get(reg.Id);
                                                 const hasAttendance = !!attendanceRecord;
                                                return {
                                                    ...reg,
                                                    atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
                                                    atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                                    awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                                    awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
                                                    hideEditButton: !hasAttendance, // Set hideEditButton to true if no attendance exists
                                                    editMode: hasAttendance,
                                                };
                                            });
                                            console.log('no attendance - '+this.registrationRecordsWithAttendance);
                                    }
                                    else
                                    {
                                            reg.hideEditButton=false;
                                            reg.editMode=true;
                                            const attendanceMap = new Map();
                                            attendanceResult.forEach(att => {
                                                attendanceMap.set(att.Registration__c, att);
                                            });
                                            this.registrationRecordsWithAttendance = this.registrationRecords.map(reg => {
                                                const attendanceRecord = attendanceMap.get(reg.Id);
                                                 const hasAttendance = !!attendanceRecord;
                                                return {
                                                    ...reg,
                                                    atPartA: attendanceRecord ? (attendanceRecord.AttendedPartA__c || 'Yes') : 'Yes',
                                                    atPartB: attendanceRecord ? (attendanceRecord.AttendedPartB__c || 'Yes') : 'Yes',
                                                    awPartA: attendanceRecord ? attendanceRecord.AwardPartA__c : null,
                                                    awPartB: attendanceRecord ? attendanceRecord.AwardPartB__c : null,
                                                    hideEditButton: !hasAttendance, // Set hideEditButton to true if no attendance exists
                                                    editMode: hasAttendance,
                                                };
                                            });

                                    }
                                    console.log('registration.isdisabledattendance attendanceRecordese- '+reg.editMode);
                                    return reg;
                                });
                                             console.log('else attendance - '+this.registrationRecordsWithAttendance);
                            }
                            console.log('registrationRecordsWithAttendance 239 - ' +JSON.stringify(this.registrationRecordsWithAttendance));
                            
                                    console.log('after reg- '+JSON.stringify(this.registrationRecordsWithAttendance));
                            
                            });
                                    
                                    
						}
                    })        
					
                }
            });
                
        });
    }
    
    handleEditRow(event){
        const regId = event.target.getAttribute('data-id');
        console.log('regId - '+regId);
        /*const selectedRegId = this.registrationRecordsWithAttendance.find(reg =>  reg.Id === regId);
        if(selectedRegId){

        }*/
        this.registrationRecordsWithAttendance = this.registrationRecordsWithAttendance.map(registration => {
            console.log(registration.Id);
        if (registration.Id === regId ) {
            registration.editMode = false ;
            console.log('registration.isdisabledattendance else- '+registration.editMode);
        }
            return registration;
        });
        
        //console.log('vv'+registration.editMode);
    }
    get isFutureDateSelected() {
        
        const sessionDate = new Date(this.selectedSessionDate);
        const currentDate = new Date();
        return sessionDate > currentDate;
    }
    selectionChangeHandler(event) {
		this.selectedSessionNumber = event.target.value;
       console.log('selectedSessionNumber - ' +event.target.value);
         const selectedSession = this.fieldsInfo.find(
            option => option.value === this.selectedSessionNumber
        );
        const selectedSessionId = this.fieldsInfo.find(
            option => option.value === this.selectedSessionNumber
        );
        const selectedSessionName = this.fieldsInfo.find(
            option => option.value === this.selectedSessionNumber
        );
        console.log('selectedSession== ' +selectedSession);
        console.log('selectedSessionName== ' +selectedSessionName);
        if (selectedSession) {
            const sessionDate = new Date(selectedSession.sessionDate);
            const currentDate = new Date();
            this.selectedSessionDate = sessionDate;

            console.log('sessionDate== ' +sessionDate);
            if (this.isFutureDateSelected) {
                this.selectedSessionNumber = null;
                this.selectedSessionDate = selectedSession.sessionDate;
                this.registrationRecords = []; // Clear registration records
                //alert('Please select a session number with a past or current date.');
            } else {
                
                this.registrationRecords = null;
                console.log('making null - '+this.registrationRecords);
                this.registrationRecordsWithAttendance=null;
                console.log('making registrationRecordsWithAttendance null - '+this.registrationRecordsWithAttendance);
                this.fetchRegistrationRecords();
                this.selectedSessionDate = selectedSession.sessionDate;
                this.sessionId = selectedSession.id;
                this.sessionName = selectedSession.name;

                //this.awardPartA = '';
                console.log('selectedSessionDate 49== ' +this.selectedSessionDate);
                this.errorMessage = null;
                
                console.log(this.awardPartA + ' look up values ');

               /* const childComponent = this.template.querySelector('c-lookup-input');
                    console.log('childComponent - ' +childComponent);
                    // Dispatch the custom event to the child component
                    if(childComponent){
                    const clearFieldEvent = new CustomEvent('clearfield');
                    childComponent.dispatchEvent(clearFieldEvent);
                    } */
            }
        }
       // this.selectedSessionDate = selectedSession ? selectedSession.sessionDate : null;    
	}
    
    handleAttendance(event){
        const updatedValue = event.target.value; // Get the updated value
        const registrationId = event.target.name; // Get the registration record ID
        const contactName = event.target.dataset.contactname; // Get the contact name
        //const val = JSON.stringify(event.detail);
        const sessionId = this.sessionId;
        const sessionName = this.sessionName;
        const prgmID = this.recordId;
        console.log('val -'+JSON.stringify(event.detail));
         var updatedAwardValueA='';
         var updatedAwardValueB ='';
        //const  updatedAwardValue= JSON.parse(val);

        const dataId = event.target.getAttribute('data-id'); // Get the data ID (attendedPartA or attendedPartB)
       if (dataId === 'awardPartA') {
                const valA = JSON.stringify(event.detail);
                  updatedAwardValueA= JSON.parse(valA);
                console.log('dataId- ' +dataId);
                console.log('updatedAwardValueA- ' +updatedAwardValueA.id);
                //existingEntry.awardPartA = updatedAwardValue.id;
            } else if (dataId === 'awardPartB') {
                const valB = JSON.stringify(event.detail);
                  updatedAwardValueB= JSON.parse(valB);
                console.log('updatedAwardValueB- ' +updatedAwardValueB.id);
               // existingEntry.awardPartB = updatedAwardValueB.id;
            }
        console.log('event.detail - '+JSON.stringify(event.detail));
        //console.log('award - ' +updatedAwardValue.id);
        console.log('prgmID - ' +prgmID);
        console.log('contactName - ' +contactName);
        console.log('sessionName  - ' +sessionName +' - '+sessionId);
        // Find the existing entry in updatedValues for the current registration ID
        let existingEntry = this.updatedValues.find(entry => entry.registrationId === registrationId);

        // If no existing entry is found, create a new entry
        if (!existingEntry) {
            this.createNewEntry(registrationId, contactName, dataId, updatedValue, updatedAwardValueA,updatedAwardValueB,sessionId, sessionName,prgmID);
        } else {
            // Update the corresponding value based on the data ID
            if (dataId === 'attendedPartA') {
                existingEntry.attendedPartA = updatedValue;
            } else if (dataId === 'attendedPartB') {
                existingEntry.attendedPartB = updatedValue;
            } else if (dataId === 'awardPartA') {
                const valA = JSON.stringify(event.detail);
                  const updatedAwardValueA= JSON.parse(valA);
                console.log('dataId- ' +dataId);
                console.log('updatedAwardValueA- ' +updatedAwardValueA.id);
               existingEntry.awardPartA = updatedAwardValueA.id;
            } else if (dataId === 'awardPartB') {
                const valB = JSON.stringify(event.detail);
                const updatedAwardValueB= JSON.parse(valB);
               existingEntry.awardPartB = updatedAwardValueB.id;
            }
        }
        console.log('existingEntry - ' +JSON.stringify(this.updatedValues));
    }
    
    createNewEntry(registrationId, contactName, dataId, updatedValue,updatedAwardValueA,updatedAwardValueB, sessionId, sessionName, prgmID) {
        const newEntry = {
            registrationId: registrationId,
            contactName: contactName,
            attendedPartA: null,
            attendedPartB: null,
            awardPartA: null,
            awardPartB: null,
            sessionId: sessionId,
            sessionName: sessionName,
            prgmID :prgmID
        };
       
        // Set the corresponding value based on the data ID
        if (dataId === 'attendedPartA') {
            newEntry.attendedPartA = updatedValue;
        } else if (dataId === 'attendedPartB') {
            newEntry.attendedPartB = updatedValue;
        } else if (dataId === 'awardPartA') {
            newEntry.awardPartA = updatedAwardValueA.id;
        } else if (dataId === 'awardPartB') {
            newEntry.awardPartB =updatedAwardValueB.id;
        }
    
        this.updatedValues.push(newEntry);
        console.log('nww - '+JSON.stringify( this.updatedValues));
    }
    handleClickSave(){
        this.saveDisabled = true;
        const sessionId = this.sessionId;
        const sessName = this.sessionName;
        const prgmID = this.recordId;

        console.log('existingEntry - ' +this.updatedValues);
        console.log('updatedvals - ' +JSON.stringify(this.updatedValues));
        //console.log('updatedvals parse - ' +JSON.parse(this.updatedValues));
        this.updatedValues.forEach(entry => {
            console.log('Registration ID:', entry.registrationId);
            console.log('Contact Name:', entry.contactName);
            console.log('Attended Part A:', entry.attendedPartA);
            console.log('Attended Part B:', entry.attendedPartB);
            console.log('Award Part A:', entry.awardPartA);
            console.log('Award Part B:', entry.awardPartB);
        });
        const updatedParams = JSON.stringify(this.updatedValues) ;
        console.log('updatedParams  - ' +updatedParams);
        console.log('sessionName  - ' +sessName +' - '+sessionId);
            insertAttendanceRec({ wrapParams: updatedParams, sessionId:sessionId,prgmID:prgmID,sessName:sessName })
                .then(result => {
                    /*this.showSuccessMessage = true;
                    
                    this.saveButtonClass = 'slds-m-left_x-small slds-button_success greenButton';
                    setTimeout(() => {
                        this.showSuccessMessage = false;
                      }, 5000);
                      this.dispatchEvent(new CloseActionScreenEvent());*/
                      window.alert(' Successfully added Attendance.');
                      //this.handlePageRefresh();
                      const timeout = setTimeout(()=>{
                        window.close()  
                        },1000);
                    //window.open('https://dalecarnegie--cbdev.sandbox.lightning.force.com/lightning/r/Program__c/'+this.recordId+'/view');
        
                     window.location.href = this.redirectURL+this.recordId+'/view';
                    //this.navigateToRecord(result.id);    
        
                                })
                .catch(error => {
        console.log('error - '+JSON.stringify(error));
            });


    }
     
    handleClickCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
       // location.reload();
    }
    handlePageRefresh(){
        //window.location.reload();
        //alert('save');
        this.dispatchEvent(new RefreshEvent());
      
        this.handleClickCancel();
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
    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId,
                actionName: 'view'
            }
        });
    }
}