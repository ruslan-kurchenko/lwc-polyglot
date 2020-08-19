import { LightningElement } from 'lwc';
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class ResolveOneErrorLabel extends LightningElement {
  labels;

  connectedCallback() {
    this.init()
  }

  async init() {
    const labels = await polyglot.getCustomLabels(['InvalidLabelName']);
    this.labels = JSON.stringify(labels, undefined, 4);
  }
}