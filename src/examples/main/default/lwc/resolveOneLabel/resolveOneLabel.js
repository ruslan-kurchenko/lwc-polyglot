import { LightningElement } from 'lwc';
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class ResolveOneLabel extends LightningElement {
    labels;

    connectedCallback() {
        this.init();
    }

    async init() {
        const labels = await polyglot.getCustomLabels(['Greetings']);
        this.labels = JSON.stringify(labels, undefined, 4);
    }
}
