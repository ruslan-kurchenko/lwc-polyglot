import getCustomLabel from '@salesforce/apex/Polyglot.getCustomLabel';

class Polyglot {

  getCustomLabels(labelNames) {

    return new Promise((resolve, reject) => {
      const labels = {
        '$success': true,
        '$invalid': {}
      };

      const deferred = labelNames
        .map(labelName => {
          return getCustomLabel({ name: labelName })
            .then(labelValue => {
              labels[labelName] = labelValue;
            })
            .catch(e => {
              labels.$success = false;
              labels.$invalid[labelName] = e.body.message;

              labels[labelName] = labelName;
            });
        });

      Promise.all(deferred)
        .then(() => {
          resolve(labels);
        })
        .catch(e => {
          reject(e)
        });
    });
  }

  getCustomLabel(labelName) {
    return this.getCustomLabels([labelName]);
  }

}

export { Polyglot };