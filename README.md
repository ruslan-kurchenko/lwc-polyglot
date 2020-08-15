# Polyglot

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2ab1efe399f34f45936a98cda366c2c2)](https://app.codacy.com/manual/ruslan-kurchenko/lwc-polyglot?utm_source=github.com&utm_medium=referral&utm_content=ruslan-kurchenko/lwc-polyglot&utm_campaign=Badge_Grade_Dashboard)

Salesforce Lightning Web Component to facilitate multilingual applications development 

## Features

- Dynamically resolve Custom Label value by name
- (in development...): Resolve Field Label
- (in development...): Resolve Object Label
- (in development...): Resolve Picklist Options

## Usage

Resolve Custom Label

```javascript
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

          // labels.Greetings = "Hello!"
          // labels.InvalidName = "InvalidName"
      });
  }
}
```

Custom Labels Resolve Result

- `$success` - `true/false` meta information to indicate if one of labels is invalid
- `$messages` - meta information to get key/value storage of messages related to invalid labels
- `<custom_label_name>` - a value of custom label stored by its name


## License

[MIT](https://github.com/ruslan-kurchenko/sfdc-lax/blob/master/docs/LICENSE)

