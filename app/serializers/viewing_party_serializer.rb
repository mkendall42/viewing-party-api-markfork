class ViewingPartySerializer
  def self.format_party_data(party)
    #Generate array of invitees (leverage joins table / associations)
    invitees = party.users.reduce([]) do |acc, invitee|
      acc << { id: invitee.id, name: invitee.name, username: invitee.username }
    end

    {
      data: {
        id: party.id,
        type: "viewing_party",
        attributes: {
          name: party.name,
          start_time: party.start_time,
          end_time: party.end_time,
          movie_id: party.movie_id,
          movie_title: party.movie_title,
          invitees: invitees
        }
      }
    }
  end

  def self.format_parties_short(parties)
    return [] if !parties

    return parties.reduce([]) do |all_parties, party|
      all_parties << {
        id: party.id,
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.find_host.id
      }
    end
  end
end