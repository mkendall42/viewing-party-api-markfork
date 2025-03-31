class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end

  def self.format_single_user(user)
    {
      data: {
        id: user.id,
        type: "user",
        attributes: {
          name: user.name,
          username: user.username,
          # viewing_parties_hosted: [],
          # viewing_parties_invited: []
          viewing_parties_hosted: ViewingPartySerializer.format_parties_short(user.viewing_parties_hosted),
          viewing_parties_invited: ViewingPartySerializer.format_parties_short(user.viewing_parties_invited)
        }
      }
    }
    # binding.pry

    # the_hash
  end
end