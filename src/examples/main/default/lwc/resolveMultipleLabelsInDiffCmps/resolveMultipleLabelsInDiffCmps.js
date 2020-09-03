import { LightningElement } from 'lwc';
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class ResolveMultipleLabelsInDiffCmps extends LightningElement {
    names;

    connectedCallback() {
        this.init();
    }

    async init() {
        const names = [];

        for (let i = 0; i < 3; i++) {
            names.push(`Label${i}`);
        }

        this.names = names;
    }
}
