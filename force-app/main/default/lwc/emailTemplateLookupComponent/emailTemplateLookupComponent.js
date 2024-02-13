import { LightningElement ,api, wire} from 'lwc';
import handleSave from '@salesforce/apex/EmailTemplateIdSave.handleSave';
import getProgramRec from '@salesforce/apex/EmailTemplateIdSave.getProgramRec';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class EmailTemplateLookupComponent extends LightningElement {
     emailId ='';
     @api recordId;
     existingEmailTempName ='';
     flag =false;
     @wire(getProgramRec, {id: '$recordId'})
     wiredgetProgramRec({ data, error }) {
         console.log('data '+JSON.stringify(data));
         console.log('recordId -- '+this.recordId);
         if (data) {
            
            this.existingEmailTempName = JSON.stringify(data);
            if(this.existingEmailTempName != null || this.existingEmailTempName!=''){
                this.flag=true;
            }else{
                this.flag=false;
            }
            console.log('data '+JSON.stringify(data));
            console.log('flag '+this.flag);
        } else if (error) {
            console.log('data '+JSON.stringify(data));
            // Handle the error
        }
    }

    handleEmail(event){
        console.log('recordId -- '+this.recordId);
        const val = JSON.stringify(event.detail);
        const  gotEmailVal= JSON.parse(val);
        this.emailId  = gotEmailVal.id;
    const dataId = event.target.getAttribute('data-id');
     //this.emailId = event.target.value;
    console.log('emailId - '+this.emailId);
    console.log('dataId - '+dataId);
    
    }
    handleClickSave(){
        handleSave({ emailId:this.emailId, prgmID:this.recordId })
                .then(result => {
                    
                      //window.alert(' Successfully Updated.');
                      
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