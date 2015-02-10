class MatchJob
  include SuckerPunch::Job

  # ----------
  # Given a match_id, get its data from the Steam API and store it in the DB.
  #
  # match_id: Integer. Match ID of the match to find data for.
  # update: Boolean. If true, update the match information even if it's already stored in the DB.
  # uid: Integer. User's account ID. Used to link proplayer to user if a proplayer is found in the match.
  # ----------
  def perform(match_id, update, uid)
    puts "UPDATE = #{update}"
    current_user = User.find(uid)

    match_json = SteamController.get_match(match_id)

    begin

      match = Match.find(match_id.to_i)

      # -----
      # If we don't have the match data in the DB already, OR the update boolean has
      # been passed in as True which means the user has requested their match data
      # to be updated regardless, then update the match.
      # -----
      if (match == nil) || update

        # Only make a new match if match wasn't found in the DB. (remember, match could
        # already be in the DB and it should just be updated if "update" boolean was True)
        match = Match.new if (match == nil)

        match.players = []

        match.has_pro = false

        players = match_json['players']

        # -----
        # Parse player information from the game data.
        # -----
        players.each do |p|

          # Check if we have this player in our list of "pro/ticketed" players in the DB
          pro_in_db = Proplayer.find(p['account_id'].to_i)

          # -----
          # If the player is a "pro", then the match gets flagged with match.has_pro, the player
          # gets flagged with the "pro" boolean later, and the proplayer gets added to the user's
          # linked list of pros if it's not already there.
          # -----
          if pro_in_db
            pro = true
            match.has_pro = true
            puts "adding pro player to user"
            current_user.proplayers.push(pro_in_db) unless current_user.proplayers.find(pro_in_db.id)
          else
            pro = false
          end

          # -----
          # Parse out player match data and add it to the match
          # -----
          hero_name = Hero.find(p['hero_id']).name.downcase.gsub(" ", "_")
          match.players.push(
            Player.new(
              id: p['account_id'],
              player_slot: p['player_slot'],
              hero: hero_name,
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
              gold_spent: p['gold_spent'],
              pro_player: pro
            ))
        end

        # -----
        # Parse out match information
        # -----
        match.radiant_win = match_json['radiant_win']
        match.duration = match_json['duration']
        match.start_time = match_json['start_time']
        match.id = match_json['match_id']

        # match.update will save the match if it doesn't exist and update it if it does
        match.update

        # Add this match to user's list of matches for quick retrieval later
        current_user.matches.push(match) unless current_user.matches.find(match.id)

      end
      
    rescue
      puts "MATCH #{match_id} FUCKIN ERRORED DOG"
    end
    
  end

end