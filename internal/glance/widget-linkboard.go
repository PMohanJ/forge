package glance

import (
	"html/template"
)

var linkboardWidgetTemplate = mustParseTemplate("linkboard.html", "widget-base.html")

type linkboardCard struct {
	Title       string `yaml:"title"`
	Description string `yaml:"description"`
	URL         string `yaml:"url"`
	LogoURL     string `yaml:"logo-url"`
	ButtonText  string `yaml:"button-text"`
}

type linkboardWidget struct {
	widgetBase `yaml:",inline"`
	Cards      []linkboardCard `yaml:"cards"`
	CardHeight int             `yaml:"card-height"`
}

func (widget *linkboardWidget) initialize() error {
	widget.withTitle("Links").withError(nil)

	// Set default card height if not specified
	if widget.CardHeight <= 0 {
		widget.CardHeight = 200
	}

	return nil
}

func (widget *linkboardWidget) Render() template.HTML {
	return widget.renderTemplate(widget, linkboardWidgetTemplate)
}
