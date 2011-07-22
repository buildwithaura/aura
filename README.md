# Aura CMS
#### The gem

Starting a new Aura project:

    git clone http://github.com/aura-cms/aura.git myproject --depth 1
    rm -rf myproject/.git

### Development info

The dir structure:

    aura/
     |
     |  [Application]
     |- app/
     |  |- helpers/
     |  |- init/
     |  |- models/
     |  |- routes/
     |  |- tasks/
     |  |- views/
     |
     |  [Standard gem stuff]
     |- lib/                Lib files
     |- test/               Test
     |
     |  [Help]
     |- manual/             Documentation
     |
     |  [App stuff]
     |- config/             Default config files
     |- extensions/         Core extensions
     |- public/             Public files
     |

