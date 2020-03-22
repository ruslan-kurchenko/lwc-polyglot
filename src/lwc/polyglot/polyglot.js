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

      const deferred = names
        .map(name => {
          return getCustomLabel({ name })
            .then(value => {
              labels[name] = value;
            })
            .catch(e => {
              labels.$success = false;
              labels.$messages[name] = e.body.message;

              labels[name] = name;
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