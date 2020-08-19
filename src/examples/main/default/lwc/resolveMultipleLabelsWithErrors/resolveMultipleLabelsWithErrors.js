import { LightningElement } from "lwc";
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class ResolveMultipleLabelsWithErrors extends LightningElement {
  labels;

  connectedCallback() {
    this.init()
  }

  async init() {
    const names = [];

    for (let i = 190; i < 215; i++) {
      names.push(`Label${i}`);
    }

    const labels = await polyglot.getCustomLabels(names);
    this.labels = JSON.stringify(labels, undefined, 4);
  }
}