# This will be the default user that will be created when the
# app first initializes.
#
# Copy this to config/user.rb to edit.
#
Main.configure do |m|
  m.set :default_user, 'test@sinefunc.com'
  m.set :default_password, 'password'
end

