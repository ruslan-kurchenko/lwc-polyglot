public with sharing class Polyglot {

    private static final String POLYGLOT_PAGE = '/apex/Polyglot';

    public Component.Apex.OutputText labelsPlaceholder { get; private set; }

    public Polyglot() {
        this.labelsPlaceholder = new Component.Apex.OutputText();
        labelsPlaceholder.expressions.value = getLabelsPlaceholder();
    }

    @AuraEnabled
    public static Map<String, Object> getCustomLabels(List<String> names) {
        PageReference page = new PageReference(POLYGLOT_PAGE + '?labels=' + String.join(names, ','));

        String labelsJSON = page.getContent().toString();
        Map<String, Object> labels = (Map<String, Object>) JSON.deserializeUntyped(labelsJSON);

        return labels;
    }

    @AuraEnabled
    public static Object getCustomLabel(String name) {
        return getCustomLabels(new List<String>{ name }).get(name);
    }

    private static String getLabelsPlaceholder() {
        Map<String, String> params = ApexPages.currentPage().getParameters();
        String labelsByComma = params.get('labels');

        List<String> labelsMapping = new List<String>();
        for (String label : labelsByComma.split(',')) {
            labelsMapping.add('"' + label + '":' + '"{!$Label.' + label + '}"');
        }

        String labelsPlaceholder = '{' + String.join(labelsMapping, ',') + '}';

        return labelsPlaceholder;
    }
}
