import getCustomLabel from '@salesforce/apex/Polyglot.getCustomLabel';

class CustomLabels {
  $success = true;
  $messages = {};
}

/**
 * Provides the list of methods to resolve internalization information
 * using dynamic names of entries
 */
class Polyglot {

  /**
   * Resolves Custom Labels values by names.
   *
   * @param names {String[]}
   * @returns {Promise<CustomLabels>}
   */
  getCustomLabels(names) {

    return new Promise((resolve, reject) => {
      const labels = new CustomLabels();

      let numOfResolvedLabels = 0;
      names.forEach(name => {
        setTimeout(() => {
          getCustomLabel({ name })
            .then(value => {
              labels[name] = value;
            })
            .catch(e => {
              labels.$success = false;
              labels.$messages[name] = e.body.message;

              labels[name] = name;
            })
            .finally(() => {
              numOfResolvedLabels++;

              if (numOfResolvedLabels === names.length) {
                resolve(labels);
              }
            });
        }, 0);
      });
    });
  }

  /**
   * Resolves Custom Label value by name.
   *
   * @param name {String}
   * @returns {Promise<CustomLabels>}
   */
  getCustomLabel(name) {
    return this.getCustomLabels([name]);
  }

}

export { Polyglot };