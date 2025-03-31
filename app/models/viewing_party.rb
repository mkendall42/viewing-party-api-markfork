class ViewingParty < ApplicationRecord
  has_many :viewing_party_registrations
  has_many :users, through: :viewing_party_registrations

  validates :name, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
  validates :movie_id, presence: true

  def set_host(user_id)
    #First, reset all hosts to false, then update [new] specified host to true
    viewing_party_registrations.each do |registration|
      registration.set_host_status(false)
    end

    viewing_party_registrations.find_by(user_id: user_id).set_host_status(true)
  end

  def find_host
    #Assumes only one host (no co-hosting) for now
    viewing_party_registrations.find_by(is_host: true).user
  end
end
