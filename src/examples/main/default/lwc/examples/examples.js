import { LightningElement } from 'lwc';
import { Polyglot } from 'c/polyglot';

const polyglot = new Polyglot();

export default class Examples extends LightningElement {
  connectedCallback() {
    const validLabel = 'Greetings';
    const invalidLabel = 'InvalidName';

    polyglot
      .getCustomLabels([validLabel, invalidLabel])
      .then(labels => {
          /*
            labels: CustomLabels
              $success: false
              $messages: {
                InvalidName: "Field $Label.InvalidName does not exist. Check spelling"
              }

              InvalidName: "InvalidName"
              Greetings: "Hello!"
          */
      });
  }
}