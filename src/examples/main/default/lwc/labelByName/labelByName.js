import { LightningElement, api } from "lwc";
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class LabelByName extends LightningElement {
  @api
  name;
  labels;

  connectedCallback() {
    this.init()
  }

  async init() {
    const labels = await polyglot.getCustomLabels([this.name]);
    this.labels = JSON.stringify(labels, undefined, 4);
  }
}