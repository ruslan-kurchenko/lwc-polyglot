import getCustomLabels from '@salesforce/apex/Polyglot.getCustomLabels';

class CustomLabels {
  success;
  messages;
  labels;
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
    return getCustomLabels({names});
  }

}

export { Polyglot };