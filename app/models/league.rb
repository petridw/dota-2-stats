class League
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  field :url, type: String

  def self.update_leagues
    leagues = SteamController.get_leagues

    if leagues
      leagues.each do |league_json|

        fixed_name = league_json['name'].split("_").drop(2).join(" ")
        league_hash = { id: league_json['leagueid'], 
                        name: fixed_name, 
                        description: league_json['description'], 
                        url: league_json['tournament_url']}

        league_in_db = League.find(league_json['leagueid'])

        if league_in_db
          league_in_db.update(league_hash)
        else
          League.create(league_hash)
        end
      end
    else
      puts "error, no leagues array"
    end 
      
  end

end
