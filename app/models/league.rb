class League
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :url, type: String
  field :last_active, type: DateTime


  # ----------
  # Update League documents to keep them current.
  # There should be a League document for each league.
  # ----------
  def self.update_leagues

    # -----
    # Get the first league in the list and check when it was updated. This will be used
    # to determine when the entire list was last updated.
    # -----
    league = League.first

    if league
      last_update = league.updated_at.to_time.to_i
      now = DateTime.now.to_i
    end


    # -----
    # If the list was last updated more than 24 hours ago, then update it.
    # (also update if there isn't any League data for some reason)
    # -----
    if league == nil || (now - last_update) > 86400

      leagues = SteamController.get_leagues

      if leagues

        # -----
        # Parse out league information from the JSON
        # -----
        leagues.each do |league_json|

          fixed_name = league_json['name'].split("_").drop(2).join(" ")
          league_hash = { id: league_json['leagueid'], 
                          name: fixed_name, 
                          url: league_json['tournament_url']}

          league_in_db = League.find(league_json['leagueid'].to_i)

          if league_in_db
            league_in_db.update(league_hash)
          else
            League.create(league_hash)
          end

        end
      else
        puts "error, no leagues could be gotten from SteamController"
      end 

    end
      
  end

end
