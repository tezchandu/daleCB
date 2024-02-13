import { LightningElement,api ,track,wire} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import lookupInput from 'c/lookupInput'; 
//import getRegistrationsByProgramId from '@salesforce/apex/RegistrationFecthforAttendance.getRegistrationsByProgramId';
import handleProduct from '@salesforce/apex/RegistrationFecthforAttendance.handleProduct';
import handleSave from '@salesforce/apex/RegistrationFecthforAttendance.handleSave';
import fetchRegistrationRecs from '@salesforce/apex/RegistrationFecthforAttendance.fetchRegistrationRecs';
import getRefund from '@salesforce/apex/RegistrationFecthforAttendance.getRefund';
import getCustomSettings from '@salesforce/apex/AttendanceTaken.getCustomSettings';
import { loadStyle} from 'lightning/platformResourceLoader';
import { RefreshEvent } from 'lightning/refresh';
export default class GraduationComponent extends NavigationMixin(LightningElement) {
    @api recordId;
    @api programId;
    @track showScreen1 = true;
    @track showScreen2 = false;
    @api flowValue;
    @track registrationRecords = []; 
    exitTypes = [
        { label: '-None-', value: 'None' },
        
        { label: 'Cancel', value: 'Cancel' },
        { label: 'Drop', value: 'Drop' }
        // Add more options if needed
    ];
    attendanceValues = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];
    refundValues = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];
    isFieldDisabled =false;
    errorMessages ={};
    errorMessage =false;
    @track exitTypeSelected ;
    updatedValues = [];
    @track redirectURL = '';
    disableSaveButton =false;
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
             isRefundRequired : false,
             isAttendanceRequired :false,
             isCreditRequired :false,
             isTransferRequired : false,
             refAmount:reg.totalPayment,
        }));
            console.log('registrationRecords'  +JSON.stringify(this.registrationRecords));
        }) .catch(error => {
            // Handle error
        });
        
    }
    handleExit(event){
        this.disableSaveButton=false;
        
        const exitTypeValue =event.target.value;
        //this.exitTypeSelected = event.target.value;
        const dataId = event.target.getAttribute('data-id');
        const contactName = event.target.dataset.contactname;
        console.log(exitTypeValue);
        console.log(dataId);
        const registrationId = event.target.name;
        //const rowElement = event.target.closest('tr');
        const programCodeInput1 = this.template.querySelector('[data-id="atttendance"]');
        //console.log('tem name- '+programCodeInput1.name);
       // console.log('tem programCodeInput1.disabled - '+programCodeInput1.disabled);
       // console.log('tem programCodeInput1.value- '+programCodeInput1.value);
        const registrationIds = this.registrationRecords.map(reg => reg.Id);
        const registration = this.registrationRecords.find(reg => reg.Id === registrationId);
            registration.isRefundRequired = false;
             registration.isAttendanceRequired = false;
             registration.isCreditRequired  = false;
             registration.isTransferRequired  = false;
             registration.isPCRequired = false;
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
                    console.log('tem registration.Id - '+registration.Id);
                    console.log('tem feePaymentCount - '+registration.feePaymentCount);
                    registration.isdisabledattendance = exitTypeValue !== 'Transfer';
                    registration.isAttendanceRequired = exitTypeValue == 'Transfer';
                    if(exitTypeValue === 'None'){
                        registration.isDisabledRefPay = true;
                        registration.isRefundRequired = false;
                        registration.isTransferRequired = false;
                        registration.isDisabledRefAmount = true;
                        //registration.refAmount = '';
                        registration.isDisabledTransPay = true;
                        registration.isDisabledNoPay = true;
                         registration.isCreditRequired = false;
                        registration.isdisabledattendance = true;
                        registration.isAttendanceRequired = true;
                    }
                    if(registration.feePaymentCount<0 || exitTypeValue !== 'Transfer' ){
                        registration.isDisabledTransPay = true;
                        registration.isTransferRequired = false;
                       
                    }
                    if(registration.feePaymentCount>0 && exitTypeValue === 'Transfer'){
                        console.log('feePaymentCount - '+registration.feePaymentCount);
                        registration.isDisabledTransPay = false;
                        registration.isTransferRequired = true;
                        registration.isDisabledNoPay = true;
                        registration.isCreditRequired = false;
                    }
                    registration.isDisabledProgramCode = exitTypeValue !== 'Transfer';
                    registration.isPCRequired = exitTypeValue == 'Transfer';
                    if(registration.feePaymentCount<=0 && exitTypeValue === 'Transfer'){
                        registration.isDisabledRefPay = true;
                       registration.isRefundRequired = false;
                        registration.isDisabledNoPay = false;
                        registration.isCreditRequired = true;
                        registration.isDisabledRefAmount = true;
                        //registration.refAmount = '';
                    } 
                    if(registration.feePaymentCount>0 && exitTypeValue !== 'Transfer' && exitTypeValue !== 'None'){
                        const regRecord = getRefundMap.get(registration.Id);
                        console.log('regRecord - '+regRecord);
                        console.log('isDisabledRefAmount - '+registration.refAmount);
                        console.log('feePaymentCount - '+registration.feePaymentCount);
                        registration.isDisabledRefPay = false;
                        registration.isRefundRequired = true;
                        registration.isDisabledRefAmount = false;
                        
                        registration.isDisabledNoPay = true;
                        //registration.refAmount = registration.refAmount;
                        //registration.refAmount = regRecord ? regRecord.TotalPayments__c  : 0.00;
                    }
                    if(registration.feePaymentCount>0 && exitTypeValue === 'None'){
                        registration.isDisabledNoPay = true;
                        
                    }
                     if(registration.feePaymentCount<=0 && exitTypeValue !== 'None' && exitTypeValue !== 'Transfer'){
                        console.log('isDisabledNoPay - '+registration.isDisabledNoPay);
                        registration.isDisabledNoPay = false;
                         registration.isCreditRequired = true;
                    }
                    registration.attendanceTaken=exitTypeValue;
                }
                return registration;
            });
        
        console.log('after - '+JSON.stringify(this.registrationRecords) );
        
        //this.updateSaveButtonState();
        
        //this.handleProduct();
    
    
    }
    
    handleAttendance(event){
        this.disableSaveButton=false;
        const dataId = event.target.getAttribute('data-id'); 
        const valGot = event.target.value;
        const prgmID = this.recordId;
        let transPay;
        let noPay;
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
        const prgmval = JSON.stringify(event.detail);
            const  gotPrgmVal= JSON.parse(prgmval);
        const registration = this.registrationRecords.find(reg => reg.Id === registrationId);
        registration.attendanceTaken = attendanceTaken;
        if (dataId === 'atttendance') {
            attendanceTaken=valGot;
            registration.isAttendanceRequired = false;
        }else if(dataId === 'transPay'){
            transPay=valGot;
            registration.isTransferRequired = false;
        }else if(dataId === 'refPay'){
            refPay=valGot;
            registration.attendanceTaken = refPay;
            registration.isRefundRequired = false;
        }else if(dataId === 'refAmount'){
            refAmountVal=valGot;
           
        }else if (dataId === 'noPayment') {
            console.log('noPayment- ' +valGot)
            noPay = valGot;
            registration.attendanceTaken = noPay;
            registration.isCreditRequired = false;
        }else if (dataId === 'programCode') {
           // programCodeVal = gotPrgmVal.id;
            registration.isPCRequired = false;
        }
            console.log('attendanceTaken - '+attendanceTaken);
            console.log('transPay - '+transPay);
            console.log('refPay - '+refPay);
            
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
                                registration.isFutureDateSelected  = true;
                                this.errorMessages[registration.Id] = 'Please select a program with the same product.';
                                console.log('registration.isdisabledattendance - '+registration.isdisabledattendance +' - ' +registration.isFutureDateSelected);
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
                            registration.isAttendanceRequired = true;
                                this.disableTransferAttendance = registration.isdisabledattendance;
                                registration.isFutureDateSelected  = false;
                                console.log('registration.isdisabledattendance else- '+registration.isdisabledattendance +' - '+registration.isFutureDateSelected);
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
                                registration.isAttendanceRequired = false;
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

     //this.updateSaveButtonState();
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

    updateSaveButtonState() {
        console.log('came here');
        // Check if all required fields are filled
        const isFormValid = this.registrationRecords.every(registration => {
            // Check each field's validity
            return (
                (!registration.isexitRequired || registration.exitTypeSelected) &&
                (!registration.isPCRequired || registration.programCodeSelected) &&
                (!registration.isAttendanceRequired || registration.attendanceTaken) &&
                (!registration.isCreditRequired || registration.creditSelected) &&
                (!registration.isTransferRequired || registration.transferSelected) &&
                (!registration.isRefundRequired || registration.refundSelected)
            );
        });
        console.log(isFormValid);
        // Update the disabled state of the Save button
        this.disableSaveButton = isFormValid;
    }

    handleClickSave(){
         //this.disableSaveButton=true;
         console.log('save');
         console.log(this.myredirectURLS);
         const isFormValid = this.registrationRecords.every(registration => {
            // Check each field's validity
            return (
                (!registration.isexitRequired || registration.exitTypeSelected) &&
                (!registration.isPCRequired || registration.programCodeSelected) &&
                (!registration.isAttendanceRequired || registration.attendanceTaken) &&
                (!registration.isCreditRequired || registration.creditSelected) &&
                (!registration.isTransferRequired || registration.transferSelected) &&
                (!registration.isRefundRequired || registration.refundSelected)
            );
        });
        console.log('isFormValid = '+isFormValid);
        if (isFormValid) {
            this.disableSaveButton=true;
            this.errorMessage = false;
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
        if(this.updatedValues.length !== 0){
    handleSave({ wrapParams: updatedParams, prgmID:this.recordId })
                .then(result => {
                    /*this.showSuccessMessage = true;
                    
                    this.saveButtonClass = 'slds-m-left_x-small slds-button_success greenButton';
                    setTimeout(() => {
                        this.showSuccessMessage = false;
                      }, 5000);
                      this.dispatchEvent(new CloseActionScreenEvent());*/
                      window.alert(' Successfully Updated.');
                     
                      const event = new CustomEvent('modalclosed');
                      this.dispatchEvent(event);  
        
                              })
                .catch(error => {
                     console.log('error - '+error)
                });
                //this.showSuccessMessage = true;
        }else{
            window.alert(' Nothing Updated');
             const timeout = setTimeout(()=>{
                        window.close()  
                        },1000);
            window.location.href = this.redirectURL+this.recordId+'/view';
            
        }
    }else {
            // Display error message
            this.disableSaveButton=false;
            console.log('this.errorMessage - '+this.errorMessage);
            this.errorMessage = 'Please fill in all required fields';
        }
}
    

    handlePageRefresh(){
        //window.location.reload();
        //alert('save');
        this.dispatchEvent(new RefreshEvent());
        //this.handleClickCancel();
    }
    handleClickCancel(){
       //alert('cancel');
       const event = new CustomEvent('modalclosed');
        
        
        this.dispatchEvent(event);
        //window.close();
        //const handleClose = new CustomEvent('close');
        // Dispatches the event.
        //this.dispatchEvent(handleClose);
       /* this[NavigationMixin.Navigate]({
            type: "standard__recordPage",
            attributes: {
                objectApiName: "Program__c",
                actionName: "view",
                recordId: this.recordId
            }
          });*/
        this.flowValue = false;
        //this.dispatchEvent(new CloseActionScreenEvent());
    }
        
}