class User < ApplicationRecord
  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }
  has_secure_password
  has_secure_token :api_key

  has_many :viewing_party_registrations
  has_many :viewing_parties, through: :viewing_party_registrations

  def viewing_parties_hosted
    viewing_parties.find_all do |party|
      party.find_host == self
    end
  end

  def viewing_parties_invited
    viewing_parties
  end
end