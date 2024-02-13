import { LightningElement,track } from 'lwc';
import dc_LOGO from '@salesforce/resourceUrl/DcHomeImage';

export default class DCImg extends LightningElement {
    @track img=dc_LOGO;
}