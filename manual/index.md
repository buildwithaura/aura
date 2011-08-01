title: Aura manual
--
Aura is a CMS. It aims to make people's lives easier.

#### Installation
Assuming you have Ruby installed (at least 1.8.7), just install the gem.

    $ gem install aura --pre

    $ aura

Getting started
---------------

#### Start a new project
Start a new project using [aura new](aura_new.html). This creates a folder with a simple bare-bone Aura project.

    $ aura new myproject
       create  myproject/
       create  myproject/config.ru
       create  myproject/init.rb
       create  myproject/app/
       create  myproject/app/models/
       create  myproject/app/models/page.rb.example
       ...

#### Install the needed gems
Using Bundler, this is pretty easy.

    $ cd myproject/
    $ bundle install
      ...

#### Configure a database (optional)
Sequel uses Sqlite by default. To point it to another database, edit the `config/database.rb.example` file.

    [config/database.rb (rb)]
    Main.configure do |m|
      m.set :database_url, "mysql://root:pickles@localhost/db_name"
    end


#### Start it up
Your app is a Rack app. Visit *http://localhost:4833* to see it. (Default user is `test@sinefunc.com`/`password`)

    $ thin start
    * Starting server...
    >> Thin web server (v1.2.11 codename Bat-Shit Crazy)
    >> Maximum connections set to 1024
    >> Listening on 0.0.0.0:4833, CTRL+C to stop

## Features

* **For designers** and site builders:
  * Be in full control of markup, and write in whatever template language you're comfortable with.
  * Build custom page types that will the custom fields you need with the template you define.

* **For site owners:**
  * Use a CMS with an interface you will love, rather than put up with.

* **For developers:**
  * Easy-to-extend with a simple extension system.
  * Built on top of [Sinatra](http://sinatrarb.com), a tried and tested microframework.

[Source code on GitHub](http://github.com/buildwithaura/aura "Source code")
