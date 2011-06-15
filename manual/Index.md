# Aura

Aura is a CMS. It aims to make people's lives easier. (+)

 - **For designers** and site builders:
   - Be in full control of markup, and write in whatever template language you're comfortable with.
   - Build custom page types that will the custom fields you need with the template you define.

 - **For site owners:**
   - Use a CMS with an interface you will love, rather than put up with.

 - **For developers:**
   - Easy-to-extend with a simple extension system. 
   - Built on top of Sinatra, a tried and tested microframework.

# Developers manual

- **Installation notes**
  - {file:README.md Readme file}

- **How things work**
  - {file:Extensions.md Extensions}
  - {file:Views.md Views}
  - {file:Models.md Models}
  - {file:Configuration.md Configuration}

- **Extensions**
  - {file:PageExtension.md Page extension}

- **Recipes**
  - {file:Recipes.md Recipe index} - common things to do

## API Reference

- **Singleton modules**
  - {Aura}
  - {Aura::Extension}
  - {Aura::Editor}
  - {Aura::Models}
  - {Aura::Slugs}
  - {Aura::Admin}

- **Model reference**
  - **{Sequel::Plugins::AuraModel AuraModel}** - all models (autoloaded)
    - {Sequel::Plugins::AuraModel::ClassMethods Class methods}
    - {Sequel::Plugins::AuraModel::InstanceMethods Instance methods}
  - **{Sequel::Plugins::AutoSchema     AutoSchema}** - automatic schema migration (autoloaded)
    - {Sequel::Plugins::AutoSchema::ClassMethods     Class methods}
  - **{Sequel::Plugins::AuraCustom     AuraCustom}** - custom fields
    - {Sequel::Plugins::AuraCustom::InstanceMethods  Instance methods}
  - **{Sequel::Plugins::AuraEditable   AuraEditable}** - editable records
    - {Sequel::Plugins::AuraEditable::ClassMethods     Class methods}
    - {Sequel::Plugins::AuraEditable::InstanceMethods  Instance methods}
  - **{Sequel::Plugins::AuraHierarchy  AuraHierarchy}** - parent/child relationships
    - {Sequel::Plugins::AuraHierarchy::ClassMethods     Class methods}
    - {Sequel::Plugins::AuraHierarchy::InstanceMethods  Instance methods}
  - **{Sequel::Plugins::AuraRenderable AuraRenderable}** - renderable records
    - {Sequel::Plugins::AuraRenderable::InstanceMethods  Instance methods}
  - **{Sequel::Plugins::AuraSluggable  AuraSluggable}** - records accessible via a slug
    - {Sequel::Plugins::AuraSluggable::ClassMethods     Class methods}
    - {Sequel::Plugins::AuraSluggable::InstanceMethods  Instance methods}
  - **{Sequel::Plugins::AuraSubtyped   AuraSubtyped}** - records with subtypes
    - {Sequel::Plugins::AuraSubtyped::ClassMethods     Class methods}
    - {Sequel::Plugins::AuraSubtyped::InstanceMethods  Instance methods}

- **Helpers**
  - {Main::AdminHelpers        AdminHelpers}
  - {Main::FlashHelpers        FlashHelpers}
  - {Main::JqueryHelpers       JqueryHelpers}
  - {Main::MainHelpers         MainHelpers}
  - {Main::PageHelpers         PageHelpers}
  - {Main::TemplateHelpers     TemplateHelpers}
  - {Main::WatermarkHelpers    WatermarkHelpers}

- **Auxiliary classes**
  - {JsFiles}
  - {HashArray}

- **Terra (form builder)**
  - {Terra::Field}
  - {Terra::Fields}
  - {Terra::Fieldset}
  - {Terra::Form}
