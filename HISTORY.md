v0.0.1.pre9 - Jul 30, 2011
--------------------------

### Added:
  * Show a Bundler warning in the default app.
  * __Implement `Aura.admin.css`.__

### Fixed:
  * __Various 1.8.7 compatibility fixes.__

### Changed:
  * Relax the Rack requirement to 1.3.x.
  * __Rename `Aura.admin_menu` to `Aura.admin.menu`.
  * Rename manual files.
  * Rename the recipes.md file to lowercase.
  * Secure `/css` and `/js` against globs and dotdots.

### Misc:
  * Gemfile to use rubygems.

v0.0.1.pre8 - Jul 29, 2011
--------------------------

### Fixed:
  * Fix 'aura' not being executable

### Changed:
  * 'aura new' has a new output style
  * Include dotfiles in 'aura new' output

v0.0.1.pre7 - Jul 29, 2011
--------------------------

### Changed:
  * default template is now 'show'

### Fixed:
  * Fix CSS load paths and default theme CSS

v0.0.1.pre6 - Jul 29, 2011
--------------------------

### Added:
  * CoffeeScript support
  * `Aura.files.glob`
  * `Aura.files[]`

### Changed:
  * Move `app/views/css` to `app/css`
  * Use site.name for the admin layout

### Fixed:
  * Sass support
  * Prevent floatdropping of the 'view site' button
  * Update site name in tests
  * Update the default site README file

### Misc:
  * Faster tests using Para
  * Update default site gitignore
