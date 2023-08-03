import { LightningElement,api ,track,wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import getRegistrationsByProgramId from '@salesforce/apex/RegistrationFecthforAttendance.getRegistrationsByProgramId';
import handleProduct from '@salesforce/apex/RegistrationFecthforAttendance.handleProduct';
import handleSave from '@salesforce/apex/RegistrationFecthforAttendance.handleSave';
import fetchRegistrationRecs from '@salesforce/apex/RegistrationFecthforAttendance.fetchRegistrationRecs';
import getRefund from '@salesforce/apex/RegistrationFecthforAttendance.getRefund';
export default class GraduationComponent extends LightningElement {
    @api recordId;
    @api programId;
    @track showScreen1 = true;
    @track showScreen2 = false;
    @api flowValue;
    @track registrationRecords = []; 
    exitTypes = [
        { label: 'Transfer', value: 'Transfer' },
        { label: 'Cancel', value: 'Cancel' },
        { label: 'Drop', value: 'Drop' }
        // Add more options if needed
    ];
    attendanceValues = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];
    isFieldDisabled =false;
    errorMessages ={};
    @track exitTypeSelected ;
    updatedValues = [];
    disableProdAttendance =false;
    disableTransferAttendance = false;
    connectedCallback() {
        // Call the function to fetch the related Registration__c records
        
       this.fetchRegistrationRecords(this.recordId);
    }
    /*@wire(getRegistrationsByProgramId, {programId: '$recordId'})
    wiredGetRegistrationsByProgramId({ data, error }) {
            console.log('recordId -- '+this.recordId);
            console.log('data '+JSON.stringify(data));
        if (data) {
            this.fetchRegistrationRecords();
        } 
        else if (error) {
            // Handle the error
            console.log(error);
        }
    }*/
    
     // Event handler to navigate to Screen2
    handleScreen() {
        console.log(this.showScreen2);
        this.showScreen1 = false;
        this.showScreen2 = true;
        console.log(this.showScreen2);
    }
    goToStepThree() {
        

        //this.template.querySelector('div.stepTwo').classList.add('slds-hide');
        this.template
            .querySelector('div.stepThree')
            .classList.remove('slds-hide');
    }
    fetchRegistrationRecords() {
        
        //this.recordId = 'a123J000003qYVMQA2';
        console.log('recordId in fetch-- '+this.recordId);
        fetchRegistrationRecs({ programId:this.recordId })
        .then(result => {
            this.registrationRecords = result.map(reg => ({
             Id: reg.Id,
             ContactName: reg.contactName, // Map ContactName__r.Name field
             isDisabled :false,
             feePaymentCount : reg.feePaymentCount,
             attendanceTaken :'',
             isDisabledTransPay : true,
             isDisabledProgramCode :true,
             isDisabledNoPay :true,
             isdisabledattendance: true,
             isDisabledRefAmount :true,
             isDisabledRefPay:true,
             refAmount:reg.totalPayment,
        }));
            console.log('registrationRecords'  +this.registrationRecords);
        }) .catch(error => {
            // Handle error
        });
        
    }
    handleExit(event){
        
        const exitTypeValue =event.target.value;
        //this.exitTypeSelected = event.target.value;
        const dataId = event.target.getAttribute('data-id');
        const contactName = event.target.dataset.contactname;
        console.log(exitTypeValue);
        console.log(dataId);
        const registrationId = event.target.name;
        //const rowElement = event.target.closest('tr');
        const programCodeInput1 = this.template.querySelector('[data-id="atttendance"]');
        console.log('tem name- '+programCodeInput1.name);
        console.log('tem programCodeInput1.disabled - '+programCodeInput1.disabled);
        console.log('tem programCodeInput1.value- '+programCodeInput1.value);
        const registrationIds = this.registrationRecords.map(reg => reg.Id);
        console.log('registrationIds ==== '+registrationIds);
        const getRefundMap = new Map();
        getRefund({ registrationIds: registrationIds })
        .then(getRefund =>{
            console.log('refund - '+JSON.stringify(getRefund));
            if(!getRefund || getRefund.length === 0){
                 //getRefundMap = new Map();
                getRefund.forEach(ref => {
                    getRefundMap.set(ref.Registration__c, ref);
                            });
            }
        })
            console.log('getRefundMap - ' +getRefundMap.get('a0v3J0000001TtuQAE'));
            this.registrationRecords = this.registrationRecords.map(registration => {
                
                if (registration.Id === registrationId) {
                    console.log('tem feePaymentCount - '+registration.feePaymentCount);
                    registration.isdisabledattendance = exitTypeValue !== 'Transfer';
                    
                    if(registration.feePaymentCount<0 || exitTypeValue !== 'Transfer' ){
                        registration.isDisabledTransPay = true;
                    }
                    registration.isDisabledProgramCode = exitTypeValue !== 'Transfer';
                    if(registration.feePaymentCount<0 || exitTypeValue === 'Transfer'){
                        registration.isDisabledRefPay = true;
                        registration.isDisabledRefAmount = true;
                        registration.refAmount = '';
                    }else if(registration.feePaymentCount>0 || exitTypeValue !== 'Transfer'){
                        const regRecord = getRefundMap.get(registration.Id);
                        console.log('regRecord - '+regRecord);
                        registration.isDisabledRefPay = false;
                        registration.isDisabledRefAmount = false;
                        //registration.refAmount = regRecord ? regRecord.TotalPayments__c  : 0.00;
                    }
                    if(registration.feePaymentCount>0){
                        registration.isDisabledNoPay = true;
                    }else{
                        registration.isDisabledNoPay = false;
                    }
                    registration.attendanceTaken=exitTypeValue;
                }
                return registration;
            });
        
        console.log('after - '+this.registrationRecords );
        

        
        //this.handleProduct();
    
    
    }
    
    handleAttendance(event){
        const dataId = event.target.getAttribute('data-id'); 
        const valGot = event.target.value;
        const prgmID = this.recordId;
        let transPay;
        let refPay;
        let attendanceTaken;
        let refAmountVal;
        const prgmAttendanceTaken = event.target.getAttribute('data-value');
        //const refAmountVal = event.target.getAttribute('data-val');
        const exitType = event.target.getAttribute('data-exitval');
        console.log('dataId - '+dataId);
        console.log('attendanceTaken - '+prgmAttendanceTaken);
        console.log('exitType - '+exitType);
        console.log('refAmountVal - '+event.target.getAttribute('data-val'));
        console.log('event.target.value - ' +event.target.value);
        const registrationId = event.target.name;
        console.log('reg 106 - '+registrationId);
        const contactName = event.target.dataset.contactname;
        const registration = this.registrationRecords.find(reg => reg.Id === registrationId);
        registration.attendanceTaken = attendanceTaken;
        if (dataId === 'atttendance') {
            attendanceTaken=valGot;
        }else if(dataId === 'transPay'){
            transPay=valGot;
        }else if(dataId === 'refPay'){
            refPay=valGot;
        }else if(dataId === 'refAmount'){
            refAmountVal=valGot;
        }
            console.log('attendanceTaken - '+attendanceTaken);
            console.log('transPay - '+transPay);
            console.log('refPay - '+refPay);
            const prgmval = JSON.stringify(event.detail);
            const  gotPrgmVal= JSON.parse(prgmval);
            console.log('program id - '+gotPrgmVal.id);
    
    if (prgmAttendanceTaken !== '' && registration.isDisabledProgramCode) {
                const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="programCode"]`);
            if (attendanceElement) {
                    attendanceElement.disabled = true;
                }
    } 
    else 
    {
        console.log(registrationId);
        const attendanceElement = this.template.querySelector(`[data-value="Transfer"] [data-id="programCode"]`);
        console.log(this.template.querySelector(`[name="a0v3J0000001Q2uQAE"] [data-id="programCode"]`));
        if(gotPrgmVal.id!=null){
            handleProduct({ registrationId: registrationId, prgmID:gotPrgmVal.id })
                .then(result => {
                    console.log('Handle Product Result:' +result);
                    if(!result){
                        //const exitType = event.target.getAttribute('data-value');
                        this.disableTransferAttendance = exitType !== 'Transfer' || !result;
                        console.log(result +' - '+exitType);
                        console.log('this.disableTransferAttendance in result- '+this.disableTransferAttendance);
                        console.log('this.disableTransferAttendance - '+this.disableTransferAttendance);
                        this.registrationRecords = this.registrationRecords.map(registration => {
                        console.log(registration.Id);
                        if (registration.Id === registrationId && (exitType === 'Transfer' || exitType==null)) {
                            registration.isdisabledattendance = this.disableTransferAttendance ;
                                this.disableTransferAttendance = registration.isdisabledattendance;
                                this.errorMessages[registration.Id] = 'Please select a program with the same product.';
                                console.log('registration.isdisabledattendance - '+registration.isdisabledattendance);
                        }
                        return registration;
                        });
                        //registration.isdisabledattendance=false;
                    }
                    else if(result){
                        //const exitType = event.target.getAttribute('data-value');
                        
                        this.disableTransferAttendance = exitType !== 'Transfer' || !result;
                        console.log(result +' - '+exitType);
                        this.registrationRecords = this.registrationRecords.map(registration => {
                            console.log(registration.Id);
                        if (registration.Id === registrationId && (exitType === 'Transfer' || exitType==null)) {
                            registration.isdisabledattendance = false ;
                                this.disableTransferAttendance = registration.isdisabledattendance;
                                console.log('registration.isdisabledattendance else- '+registration.isdisabledattendance);
                        }
                        return registration;
                        });
                    }
                    /*else{
                        this.registrationRecords = this.registrationRecords.map(registration => {
                            console.log(registration.Id);
                        if (registration.Id === registrationId && exitType === 'Transfer') {
                            registration.isdisabledattendance = false ;
                                this.disableTransferAttendance = false;
                                console.log('registration.isdisabledattendance - '+registration.isdisabledattendance);
                        }
                        return registration;
                        });
                        
                    }*/
                })
                    
                .catch(error => {
                    console.log('Error in handleProduct:', error);
                });
        }
        else if(gotPrgmVal.id==null) {
                        this.registrationRecords = this.registrationRecords.map(registration => {
                                console.log(registration.Id);
                        if (registration.Id === registrationId && exitType !== 'Transfer') {
                                registration.isdisabledattendance = false ;
                                    this.disableTransferAttendance = registration.isdisabledattendance;
                                    console.log('registration.isdisabledattendance else- '+registration.isdisabledattendance);
                        }
                            return registration;
                        });
        }
                //console.log('registration.isdisabledattendance - '+registration.isdisabledattendance);
                console.log('this.disableTransferAttendance -last '+this.disableTransferAttendance);
    }
    
    // Disable "Attendance Taken" field if "Exit Type" is "Drop"
        
                // Use the result to enable/disable the input field
                
    
    if (prgmAttendanceTaken == '' && (registration.isdisabledattendance || this.disableTransferAttendance)) {
            console.log(this.template.querySelector(`[name="a0v3J0000001Q2uQAE"] [data-id="programCode"]`));
            const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="atttendance"]`);
            console.log('disableProdAttendance-'+this.disableProdAttendance);
            console.log(  'attendanceElement - '+attendanceElement);
                if (attendanceElement ) {
                       
                        //attendanceElement.disabled = true;
                    } 
                else {
                   
                    const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="atttendance"]`);
                    if (attendanceElement) {
                        //attendanceElement.disabled = false;
                    }
                }
                
                
                //attendanceElement.disabled = true;
            
    }else if(prgmAttendanceTaken !== '' && !(registration.isdisabledattendance)){
            console.log('else - attendanceTaken - ' +prgmAttendanceTaken);
            const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="atttendance"]`);
            const attendanceElement1 = this.template.querySelector(`[name="${registrationId}"] [data-id="programCode"]`);
            console.log(attendanceElement);
            console.log(attendanceElement1);
    }
    
    
    if (transPay === '' && registration.isDisabledTransPay) {
        const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="transPay"]`);
        if (attendanceElement) {
            attendanceElement.disabled = true;
        }
    } else {
        const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="transPay"]`);
        if (attendanceElement) {
            attendanceElement.disabled = false;
        }
    }
    
    if (refPay !== '' && registration.isDisabledRefPay) {
        const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="refPay"]`);
        if (attendanceElement) {
            attendanceElement.disabled = true;
        }
    } else {
        const attendanceElement = this.template.querySelector(`[name="${registrationId}"] [data-id="refPay"]`);
        if (attendanceElement) {
            attendanceElement.disabled = false;
        }
    }

    
    let existingEntry = this.updatedValues.find(entry => entry.registrationId === registrationId);
    if (!existingEntry) {
    const  gotPrgmVal= JSON.parse(prgmval);
    this.createNewEntry(registrationId, contactName, dataId, valGot,gotPrgmVal,prgmID,exitType,refAmountVal);
    } else {
        // Update the corresponding value based on the data ID
        if (dataId === 'atttendance') {
            existingEntry.atttendance = valGot;
        } else if (dataId === 'transPay') {
            existingEntry.transPay = valGot;
        } else if (dataId === 'refPay') {
            console.log('dataId- ' +dataId);
            console.log('updatedAwardValue- ' +valGot);
            existingEntry.refPay = valGot;
        } else if (dataId === 'noPayment') {
            console.log('noPayment- ' +valGot)
            existingEntry.noPayment = valGot;
        } else if (dataId === 'programCode') {
            existingEntry.programCode = gotPrgmVal.id;
        } else if (dataId === 'refAmount') {
            existingEntry.refAmountVal = valGot;
        }
    }
    console.log('existingEntry - ' +this.updatedValues);

    }
            
    createNewEntry(registrationId, contactName, dataId, valGot,gotPrgmVal, prgmID, exitType, refAmountVal) {
    const newEntry = {
        registrationId: registrationId,
        contactName: contactName,
        attendance: null,
        noPayment: null,
        transPay: null,
        refPay: null,
        programCode: null,
        prgmID :prgmID,
        exitType :exitType,
        refAmountVal:refAmountVal
    };
   
    // Set the corresponding value based on the data ID
    if (dataId === 'atttendance') {
        newEntry.atttendance = valGot;
    } else if (dataId === 'noPayment') {
        newEntry.noPayment = valGot;
    } else if (dataId === 'transPay') {
        newEntry.transPay = valGot;
    } else if (dataId === 'refPay') {
        newEntry.refPay = valGot;
    } else if (dataId === 'programCode') {
        newEntry.programCode = gotPrgmVal.id;
    } else if (dataId === 'refAmount') {
        newEntry.refAmountVal = valGot;
    }
    console.log('reg - '+registrationId);
    this.updatedValues.push(newEntry);
    console.log(this.updatedValues);
    }
    handleClickSave(){
    this.updatedValues.forEach(entry => {
        console.log('Registration ID:', entry.registrationId);
        console.log('Contact Name:', entry.contactName);
        console.log('attendance:', entry.atttendance);
        console.log('noPay:', entry.noPayment);
        console.log('AtransPay:', entry.transPay);
        console.log('refPay:', entry.refPay);
        console.log('programCode:', entry.programCode);
        console.log('exitType:', entry.exitType);
        console.log('prgmID:', entry.prgmID);
        console.log('refAmount:', entry.refAmountVal);
    });
        const updatedParams = JSON.stringify(this.updatedValues) ;
        console.log('updatedParams  - ' +updatedParams);
        
    handleSave({ wrapParams: updatedParams, prgmID:this.recordId })
                .then(result => {
                    /*this.showSuccessMessage = true;
                    
                    this.saveButtonClass = 'slds-m-left_x-small slds-button_success greenButton';
                    setTimeout(() => {
                        this.showSuccessMessage = false;
                      }, 5000);
                      this.dispatchEvent(new CloseActionScreenEvent());*/
                      window.alert(' Successfully Updated.');
                      //window.location.href = 'https://dalecarnegie--cbdev.sandbox.lightning.force.com/lightning/r/Program__c/'+this.recordId+'/view';
                    //this.navigateToRecord(result.id);    
                    this.dispatchEvent(new CloseActionScreenEvent());
                })
                .catch(error => {
                     console.log('error - '+error)
                });
    }
    handleClickCancel(){
    this.dispatchEvent(new CloseActionScreenEvent());
    }
        
}