class User < ApplicationRecord
  validates :name, :email, presence: true
  validates_uniqueness_of :email
  after_initialize :set_value

  def self.get_user_by_campaign_name(campaign_names)
    User.select { |user| user.campaigns_list.any? { |campaign| campaign["campaign_name"].in?(campaign_names) } }
  end

  def set_value
    self.campaigns_list = [campaigns_list].flatten
  end

  def self.fetch_campaign_names
    all.map do |user|
      campaigns_list = user.campaigns_list || []
      campaigns_list.map { |campaign| campaign["campaign_name"] }
    end.flatten.compact.uniq
  end
end