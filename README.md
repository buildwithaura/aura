# Aura

Aura is a CMS.

## Super easy setup

    gem install aura --pre

Start a new project:

    aura new myproject

Set it up:

    cd myproject
    bundle install

Run:

    rackup

Point your browser then to `http://localhost:9292`! The default user is
`test@sinefunc.com` / `password`.

## Other setup notes

#### Configuring a database

Aura uses sqlite by default. If you'd want it to connect to another SQL 
database, see the `config/database.rb.example`.

## Authors and copyright

Aura is authored and maintained by Rico Sta. Cruz of Sinefunc, Inc.
See more of our work on [www.sinefunc.com](http://www.sinefunc.com)!

(c) 2010-2011 Rico Sta. Cruz. Released under the MIT license.
