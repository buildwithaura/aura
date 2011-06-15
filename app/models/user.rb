class Aura
module Models
class User < Model
  set_schema do
    primary_key :id

    String :email
    String :slug
    String :crypted_password
    Time :last_login
  end

  plugin :aura_editable

  extend Shield::Model

  # For Shield
  def self.fetch(email)
    first(:email => email)
  end

  # For Shield
  def password=(password)
    self.crypted_password = Shield::Password.encrypt(password)
    @password = password
    @password_confirmation = password  if new?
  end

  attr_writer :password_confirmation

  # For Shield
  def validate
    super
    validates_presence :email
    errors.add(:password, 'cannot be empty')  if self.crypted_password.nil?

    duplicate = self.class.fetch(email)
    errors.add(:email, 'is already taken')  if !duplicate.nil? and duplicate.id != self.id
    errors.add(:password_confirmation, 'must match password')  if @password != @password_confirmation
  end

  def slugify(str=email)
    super str
  end

  def to_s
    email
  end

  def self.seed!(type=nil, &blk)
    # Don't clear users!
    seed type, &blk
  end

  def self.seed(type=nil, &blk)
    super
    return  if User.any?

    email    = Main.default_user
    password = Main.default_password

    p1 = self.create :email => email,
                     :password => password,
                     :password_confirmation => password

    blk.call :info, "You may login with '#{email}' and password '#{password}'."  if block_given?
  end

  seed  unless table_exists?
end
end
end
