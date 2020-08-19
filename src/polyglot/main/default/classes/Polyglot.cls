public with sharing class Polyglot {
    private static final String PAGE_TYPE = 'type';

    private final PageFactory pageFactory = new PageFactory();

    public PolyglotPage page { get; private set; }

    public Polyglot() {
        this.page = this.pageFactory.newInstance();
    }

    class PageFactory {
        public PolyglotPage newInstance() {
            PolyglotPage instance;

            Map<String, String> params = ApexPages.currentPage().getParameters();
            String type = params.get(PAGE_TYPE);

            if (type == 'CustomLabelsPage') {
                instance = new CustomLabelsPage(params);
            }

            return instance;
        }
    }

    @AuraEnabled(Cacheable = true)
    public static CustomLabelsResult getCustomLabels(List<String> names) {
        CustomLabelsResult result;

        try {
            result = resolveCustomLabels(names);
        } catch (Exception ex) {
            result = new CustomLabelsResult();

            result.success = false;
            for (String name : names) {
                result.messages.put(name, ex.getMessage());
                result.labels.put(name, name);
            }
        }

        return result;
    }

    private static CustomLabelsResult resolveCustomLabels(List<String> names) {
        CustomLabelsResult result = new CustomLabelsResult();

        if (!names.isEmpty()) {
            resolveCustomLabels(new Set<String>(names), result);
        }

        return result;
    }

    private static CustomLabelsResult resolveCustomLabels(Set<String> names, CustomLabelsResult result) {
        try {
            result.labels.putAll(
                    new CustomLabelsPage(names).getContent()
            );
        } catch (VisualforceException ex) {
            String invalidLabelName = ex.getMessage().substringBetween('Field $Label.', ' does not exist');

            result.success = false;
            result.messages.put(invalidLabelName, ex.getMessage());
            result.labels.put(invalidLabelName, invalidLabelName);

            names.remove(invalidLabelName);

            if (result.messages.size() == 100) {
                Integer numbOfAllCustomLabels = result.messages.size() + names.size();
                for (String name : names) {
                    result.messages.put(name, 'The system reached the limit of 100 tries to resolve ' + numbOfAllCustomLabels + ' custom labels. The custom label $Label.' + name + ' is not resolved. Please, contact your System Administrator.');
                    result.labels.put(name, name);
                }
            } else if (names.size() > 0) {
                resolveCustomLabels(names, result);
            }
        }

        return result;
    }


    private virtual class PolyglotPage {
        private final String ref = '/apex/Polyglot';
        private final Map<String, String> params = new Map<String, String>();

        public Component.Apex.OutputText component { get; private set; }

        public void addParameter(String name, String value) {
            this.params.put(name, value);
        }

        public void addParameters(Map<String, String> params) {
            this.params.putAll(params);
        }

        public String getParameter(String name) {
            return this.params.get(name);
        }

        public Blob getBlobContent() {
            this.addParameter(PAGE_TYPE, String.valueOf(this).substringBefore( ':' ));

            List<String> entries = new List<String>();
            for (String name : this.params.keySet()) {
                entries.add(name + '=' + this.params.get(name).replaceAll('#', '%23').escapeHtml4());
            }

            return new PageReference(ref + '?' + String.join(entries, '&')).getContent();
        }
    }


    private class CustomLabelsPage extends PolyglotPage {
        private final String PARAMETER = 'custom_labels';
        private final String SEPARATOR = ',';

        public CustomLabelsPage(Set<String> names) {
            this.addParameter(PARAMETER, String.join(new List<String>(names), SEPARATOR));
        }

        public CustomLabelsPage(Map<String, String> params) {
            this.addParameters(params);
            this.component = createComponent();
        }

        private Component.Apex.OutputText createComponent() {
            Component.Apex.OutputText outputText = new Component.Apex.OutputText();

            List<String> names = this.getParameter(PARAMETER).unescapeHtml4().split(SEPARATOR);

            List<CustomLabelTemplate> templates = new List<CustomLabelTemplate>();
            for (String name : names) {
                templates.add(new CustomLabelTemplate(name));
            }

            outputText.expressions.value = this.mergeTemplates(templates);

            return outputText;
        }

        private String mergeTemplates(List<CustomLabelTemplate> templates) {
            List<String> expressions = new List<String>();

            for (CustomLabelTemplate template : templates) {
                expressions.add(template.toString());
            }

            return '{' + String.join(expressions, SEPARATOR) + '}';
        }

        public Map<String, String> getContent() {
            String content = super.getBlobContent().toString();

            return (Map<String, String>) JSON.deserialize(content, Map<String, String>.class);
        }
    }

    private class CustomLabelTemplate {
        public String name;

        public CustomLabelTemplate(String name) {
            this.name = name;
        }

        public override String toString() {
            return '"' + this.name + '":' + '"{!$Label.' + this.name + '}"';
        }
    }

    public class CustomLabelsResult {
        @AuraEnabled
        public Boolean success { get; set; }
        @AuraEnabled
        public Map<String, String> messages { get; set; }
        @AuraEnabled
        public Map<String, Object> labels { get; set; }

        public CustomLabelsResult() {
            this.success = true;
            this.messages = new Map<String, String>();
            this.labels = new Map<String, String>();
        }
    }
}
