import { LightningElement } from 'lwc';
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class CatchLimitOf100InvalidLabelNames extends LightningElement {
    labels;

    connectedCallback() {
        this.init();
    }

    async init() {
        const names = [];

        for (let i = 0; i < 110; i++) {
            names.push(`It_is_invalid_label_name_${i}`);
        }

        const labels = await polyglot.getCustomLabels(names);
        this.labels = JSON.stringify(labels, undefined, 4);
    }
}
