title: Bundling sample data
--
You may want to bundle some sample data with the application when you deploy.
This may be useful when you're delivering the CMS as one self-contained
package to your client.

#### Freeze your data
Assuming you have Aura working locally, freeze it using `rake db:dump`.
This creates a `config/seed.yml` file.

    $ rake db:dump
    * Working...
    * Writing to config/seed.yml...

    Done.

    ...

#### config/seed.yml
Be sure to add this file to your repository.

    $ ls -la config/seed.yml
    -rw-r--r--   1 rsc  staff  28115 Jul 23 23:14 seed.yml

    $ git add config/seed.yml

The next time your application starts, it will rebuild the database from that snapshot.

