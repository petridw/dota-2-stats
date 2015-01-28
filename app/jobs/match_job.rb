class MatchJob
  include SuckerPunch::Job

  def perform(match_id, update)
    puts "UPDATE = #{update}"

    match_json = SteamController.get_match(match_id)

    #match may have been added by another thread, so don't add it if it's already there!
    #but, if update is true, then update this match no matter what
    match = Match.find(match_id.to_i)

    if (match == nil) || update

      match = Match.new if (match == nil)

      match.has_pro = false

      players = match_json['players']

      players.each do |p|

        #check if player is pro
        if Proplayer.find(p['account_id'].to_i)
          pro = true
          match.has_pro = true
        else
          pro = false
        end

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

      match.radiant_win = match_json['radiant_win']
      match.duration = match_json['duration']
      match.start_time = match_json['start_time']
      match.id = match_json['match_id']

      match.update

    end
    
  end

end