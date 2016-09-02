class User < ActiveRecord::Base

  before_save :downcase_email
  validates :first_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  # validates_presence_of :team_id

  # belongs_to :team
  has_many :sessions
  has_many :wips
  has_many :completeds
  # has_many :blockers, dependent: :destroy


  enum role: [:master, :admin, :manager, :employee]
  after_initialize :set_default_role, :if => :new_record?
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  after_create :create_all_tasks_list

  #Migrations for USER INTERFACE
  has_attached_file :avatar,
                    styles: { :medium => "200x200>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => /^image\/(png|gif|jpeg|jpg)/

  has_many :created_lists, class_name: "List"

  has_many :collaborations
  has_many :collaboration_lists, through: :collaborations, :source => :list

  has_many :tasks
  has_many :collaboration_tasks, through: :collaboration_lists, :source => :tasks
  has_many :my_tasks, through: :created_lists, :source => :tasks

  def set_default_role
    self.role ||= :employee
  end

  def create_all_tasks_list
    self.created_lists << self.created_lists.create(name: "All Tasks", all_tasks: true)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))

  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token),
    reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end


  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
