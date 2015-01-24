class MatchesController < ApplicationController

  before_action :authorize, :auth_steam

  LOBBY_TYPES = [ 
                  "Public matchmaking",
                  "Practice",
                  "Tournament",
                  "Tutorial",
                  "Co-op with bots",
                  "Team match",
                  "Solo Queue",
                  "Ranked madness",
                  "Solo Mid 1vs1"
                ]

  def index

    matches_json = SteamController.get_match_history(current_user.steam_id, nil)

    @matches = []

    matches_json.each do |match_json|

      # match = Match.find(match_json['match_id'])
      # add_match(match_json) unless match

      start_time = Time.at(match_json['start_time']).strftime("%m/%d/%Y")

      match_hash = {
        match_id: match_json['match_id'],
        start_time: start_time,
        lobby_type: LOBBY_TYPES[match_json['lobby_type']]
      }

      @matches.push(match_hash)
    end

  end


  def show

    @match = Match.find(params[:id].to_i)

    if @match == nil

      match_json = SteamController.get_match(params[:id])

      if match_json['error']

        flash[:danger] = match_json['error']
        render :show

      else
        add_match(match_json)
      end
    end


  end

  def add_match(match_json)

    @match = Match.new

    players = match_json['players']

    players.each do |p|
      @match.players.push(
        Player.new(
          id: p['account_id'],
          player_slot: p['player_slot'],
          hero_id: p['hero_id'],
          item_0: p['item_0'],
          item_1: p['item_1'],
          item_2: p['item_2'],
          item_3: p['item_3'],
          item_4: p['item_4'],
          item_5: p['item_5'],
          kills: p['kills'],
          deaths: p['deaths'],
          assists: p['assists'],
          gold: p['gold'],
          last_hits: p['last_hits'],
          denies: p['denies'],
          level: p['level'],
          gold_per_min: p['gold_per_min'],
          xp_per_min: p['xp_per_min'],
          hero_damage: p['hero_damage'],
          tower_damage: p['tower_damage'],
          hero_healing: p['hero_healing'],
          level: p['level'],
          gold_spent: p['gold_spent']
        ))
    end

    @match.radiant_win = match_json['radiant_win']
    @match.duration = match_json['duration']
    @match.start_time = match_json['start_time']
    @match.id = match_json['match_id']

    if @match.save
      flash.now[:success] = "This match has been successfully stored in the database."
    else
      flash.now[:danger] = "This match was unable to be stored in the database :("
    end
  end

end