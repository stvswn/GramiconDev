class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me
	has_many :sent_messages, :class_name => 'Message', :foreign_key => 'sender_id'
	has_many :received_messages, :class_name => 'Message', :foreign_key => 'recipient_id'
  has_many :folders
  has_many :ratings, :foreign_key => 'user_id'

  has_attached_file :picture,
       :styles => {
       :tiny=> "50x50#",
       :thumb=> "100x100#",
       :small  => "400x400>" },
     :storage => :s3,
     :s3_credentials => YAML.load(File.open("#{Dir.getwd}/config/s3.yml"))[Rails.env],
     :path => "/:style/:id/:filename"

	attr_accessible :name, :email, :dob, :gender, :zip_code, :picture, :delete_picture
  attr_accessor :delete_picture

  validates :zip_code, :name, :presence => true
  validates_date :dob,  :on_or_before => lambda { Date.current }, :allow_nil => true
  validates_attachment_size :picture, :less_than => 5.megabytes
  validates_attachment_content_type :picture, :content_type => ['image/jpeg', 'image/png']

  before_validation { picture.clear if delete_picture == '1' }

  def to_s
    self.name or self.email
  end

  def age
    return if !dob
    now = Time.now.utc.to_date
    now.year - dob.year - (dob.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def rating_percentage
    ratings_count = ratings.count
    rating_pc = nil
    if ratings_count > 0
      rating_pc = (ratings.positive.count*100)/ratings_count
    end
    if rating_pc != self.ratingcache
      self.ratingcache = rating_pc
      self.save!
    end
    return rating_pc 
  end

  def credits_per_gram_average
    creditsum = 0
    opened_messages = self.received_messages.where(:state => 'opened', :type=>'Message')
    return nil if opened_messages.count==0
    opened_messages.each { |message| creditsum = creditsum+message.credits }
    creditsum/opened_messages.count
  end

  def self.search(name=nil,zip_code=nil,gender=nil,maxage=nil,minage=nil)
    rel = scoped
    rel = rel.where('LOWER(name) LIKE ?', "%#{name.downcase}%") if !name.blank?
    rel = rel.where('LOWER(zip_code) LIKE ?', "%#{zip_code.downcase}%") if !zip_code.blank?

    maxdob = Date.today - maxage.to_i.years if !maxage.blank?
    mindob = Date.today - minage.to_i.years if !minage.blank?

    rel = rel.where('date(dob) >= ?', maxdob) if maxdob
    rel = rel.where('date(dob) <= ?', mindob) if mindob

    if gender
      if !gender[:m] or !gender[:f]
        if gender[:m]
          rel = rel.where(:gender => 'm')
        elsif gender[:f]
          rel = rel.where(:gender => 'f')
        end
        
      end
    end
    rel
  end

  def self.except_for_user(user)
    return scoped unless user
    where("id != ?", user.id)
  end

end


