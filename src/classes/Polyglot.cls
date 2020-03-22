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
    public static Object getCustomLabel(String name) {
        return getCustomLabels(new List<String>{ name }).get(name);
    }

    @AuraEnabled(Cacheable = true)
    public static Map<String, Object> getCustomLabels(List<String> names) {
        return new CustomLabelsPage(names).getContent();
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
                entries.add(name + '=' + this.params.get(name));
            }

            return new PageReference(ref + '?' + String.escapeSingleQuotes(String.join(entries, '&'))).getContent();
        }
    }


    private class CustomLabelsPage extends PolyglotPage {
        private final String PARAMETER = 'custom_labels';
        private final String SEPARATOR = ',';

        public CustomLabelsPage(List<String> names) {
            this.addParameter(PARAMETER, String.join(names, SEPARATOR));
        }

        public CustomLabelsPage(Map<String, String> params) {
            this.addParameters(params);
            this.component = createComponent();
        }

        private Component.Apex.OutputText createComponent() {
            Component.Apex.OutputText outputText = new Component.Apex.OutputText();

            List<String> names = this.getParameter(PARAMETER).split(SEPARATOR);

            List<CustomLabelTemplate> templates = new List<CustomLabelTemplate>();
            for (String name : names) {
                templates.add(new CustomLabelTemplate(name));
            }

            outputText.expressions.value = this.mergeTemplates(templates);

            return outputText;
        }

        private String mergeTemplates(List<CustomLabelTemplate> templates) {
            return templates.toString().replace('(', '{').replace(')', '}');
        }

        public Map<String, Object> getContent() {
            return (Map<String, Object>) JSON.deserializeUntyped(super.getBlobContent().toString());
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
}
