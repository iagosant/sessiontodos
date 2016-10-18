class User < ActiveRecord::Base
  attr_writer :current_step
  validates_presence_of :first_name, :if => lambda { |o| o.current_step == "personal" || o.current_step == steps.first }
  validates_presence_of :avatar, :if => lambda { |o| o.current_step == "avatar" || o.current_step == steps.first }

  validates :first_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }, :if => lambda { |o| o.current_step == "security" || o.current_step == steps.first  }
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  before_save :downcase_email
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
  has_many :lists, through: :tasks

  has_many :assigns_tasks, class_name: "Task", foreign_key: "assigner_id"

  # has_many :collaboration_tasks, through: :collaboration_lists, :source => :tasks
  # has_many :my_tasks, through: :created_lists, :source => :tasks

  has_many :invitations, :class_name => "invitation", :foreign_key => 'recipient_id'
  has_many :sent_invitations, :class_name => "Invitation", :foreign_key => 'sender_id'

  def steps
    %w[all personal avatar security]
  end

  def current_step
    @current_step || steps.first
  end

  def set_default_role
    self.role ||= :employee
  end

  def create_all_tasks_list
    self.created_lists << self.created_lists.create(name: "All Tasks", all_tasks: true)
  end

  def owner?(list)
    return true if (list.owner == self)
  end

  # Returns user's task
  def completed_tasks(list,date)
    self.tasks.where(["list_id=? and completed_at IS NOT ? and DATE(completed_at) BETWEEN ? AND ?",list.id,nil, date - 1.day , date] ).order('completed_at')
      # @complete_tasks = @list.completed_tasks(@user).where('DATE(completed_at) BETWEEN ? AND ?' , d_yesterday , d_today ).order('completed_at')
  end

  def incompleted_tasks_past(list,date)
    @incomplete_tasks_past= (Date.today == date)? incompleted_tasks(list) - incompleted_tasks_today(list,date) : nil
  end

  def incompleted_tasks_today(list,date)
    incompleted_tasks(list).where(["DATE(created_at)=?", date]).order('created_at')
  end

  def num_incompleted_tasks(list)
    self.incompleted_tasks(list).count
  end

  def incompleted_tasks(list)
    # self.tasks.where(completed_at: nil).order("updated_at DESC")
    self.tasks.where(["list_id=? and completed_at IS ?",list.id,nil]).order("created_at DESC")
  end

  # Returns user's task

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

  # Invitations to user.

  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def user_exist(email)
    invitation.token if invitation
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
