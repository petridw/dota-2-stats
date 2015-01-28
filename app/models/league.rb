class League
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :url, type: String
  field :last_active, type: DateTime

  def self.update_leagues
    #only update if league data is more than 24 hours old
    league = League.first

    if league
      last_update = league.updated_at.to_time.to_i
      now = DateTime.now.to_i
    end

    if league == nil || (now - last_update) > 86400

      leagues = SteamController.get_leagues

      if leagues
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
        puts "error, no leagues could be gotten"
      end 

    end
      
  end

end
