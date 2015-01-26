class LivematchlistJob
  include SuckerPunch::Job

  def perform

    matchlist_json = SteamController.get_live_games
    League.update_leagues
    Livematchlist.clean

    livematchlist = Livematchlist.new

    matchlist_json.each do |match_json|

    livematch = Livematch.new(
                    id: match_json['match_id'],
                    spectators: match_json['spectators'],
                    league_id: match_json['league_id'],
                    series_type: match_json['series_type'],
                    radiant_series_wins: match_json['radiant_series_wins'],
                    dire_series_wins: match_json['dire_series_wins']
                  )

      radiant = Liveteam.new
      dire = Liveteam.new

      if match_json['scoreboard']

        livematch.duration = match_json['scoreboard']['duration']

        radiant.id = "Radiant"
        radiant.kills = match_json['scoreboard']['radiant']['score']
        radiant.tower_state = match_json['scoreboard']['radiant']['tower_state']
        radiant.barracks_state = match_json['scoreboard']['radiant']['barracks_state']
        radiant.picks = match_json['scoreboard']['radiant']['picks']
        radiant.bans = match_json['scoreboard']['radiant']['bans']

        dire.id = "Dire"
        dire.kills = match_json['scoreboard']['dire']['score']
        dire.tower_state = match_json['scoreboard']['dire']['tower_state']
        dire.barracks_state = match_json['scoreboard']['dire']['barracks_state']
        dire.picks = match_json['scoreboard']['dire']['picks']
        dire.bans = match_json['scoreboard']['dire']['bans']


        puts "doing shit for players..."

        match_json['scoreboard']['radiant']['players'].each do |p|

          liveplayer = Liveplayer.new

          puts "finding hero name for ID: #{p['hero_id']}"
          hero = Hero.find(p['hero_id'])

          if hero
            hero_name = hero.name.downcase.gsub(" ", "_")
          else
            hero_name = "No hero yet"
          end

          liveplayer.player_slot = p['player_slot']
          liveplayer.hero = hero_name
          liveplayer.item_0 = p['item0']
          liveplayer.item_1 = p['item1']
          liveplayer.item_2 = p['item2']
          liveplayer.item_3 = p['item3']
          liveplayer.item_4 = p['item4']
          liveplayer.item_5 = p['item5']
          liveplayer.kills = p['kills']
          liveplayer.deaths = p['death']
          liveplayer.assists = p['assists']
          liveplayer.gold = p['gold']
          liveplayer.last_hits = p['last_hits']
          liveplayer.denies = p['denies']
          liveplayer.gold_per_min = p['gold_per_min']
          liveplayer.xp_per_min = p['xp_per_min']
          liveplayer.level = p['level']
          liveplayer.respawn_timer = p['respawn_timer']
          liveplayer.net_worth = p['net_worth']

          radiant.liveplayers.push(liveplayer)

        end

        match_json['scoreboard']['dire']['players'].each do |p|

          liveplayer = Liveplayer.new
    
          puts "finding hero name for ID: #{p['hero_id']}"
          hero = Hero.find(p['hero_id'])

          if hero
            hero_name = hero.name.downcase.gsub(" ", "_")
          else
            hero_name = "No hero yet"
          end

          liveplayer.player_slot = p['']
          liveplayer.hero = hero_name
          liveplayer.item_0 = p['item0']
          liveplayer.item_1 = p['item1']
          liveplayer.item_2 = p['item2']
          liveplayer.item_3 = p['item3']
          liveplayer.item_4 = p['item4']
          liveplayer.item_5 = p['item5']
          liveplayer.kills = p['kills']
          liveplayer.deaths = p['death']
          liveplayer.assists = p['assists']
          liveplayer.gold = p['gold']
          liveplayer.last_hits = p['last_hits']
          liveplayer.denies = p['denies']
          liveplayer.gold_per_min = p['gold_per_min']
          liveplayer.xp_per_min = p['xp_per_min']
          liveplayer.level = p['level']
          liveplayer.respawn_timer = p['respawn_timer']
          liveplayer.net_worth = p['net_worth']

          dire.liveplayers.push(liveplayer)

        end

      end

      if match_json['radiant_team']
        radiant.name = match_json['radiant_team']['team_name']
        radiant.team_logo = match_json['radiant_team']['team_logo']
      else
        radiant.name = "Radiant"
      end

      if match_json['dire_team']
        dire.name = match_json['dire_team']['team_name']
        dire.team_logo = match_json['dire_team']['team_logo']
      else
        dire.name = "Dire"
      end

      livematch.liveteams.push(radiant)
      livematch.liveteams.push(dire)

      livematchlist.livematches.push(livematch)
    end

    if livematchlist.save
      puts "yayyyyyyyyyyyyyy"
    else
      puts "nooooooooooooooo"
    end

  end

end

    #   if match_json['scoreboard']
    #     radiant_kills = match_json['scoreboard']['radiant']['score']
    #     dire_kills = match_json['scoreboard']['dire']['score']
    #     duration = sec_to_str(match_json['scoreboard']['duration'].to_i)
    #   else
    #     duration = "Pre-game"
    #     radiant_kills = 0
    #     dire_kills = 0
    #   end


    #   match_hash = {
    #     match_id: match_json['match_id'],
    #     spectators: match_json['spectators'],
    #     duration: duration,
    #     league: league,
    #     series_type: match_json['series_type'],
    #     radiant_kills: radiant_kills,
    #     dire_kills: dire_kills
    #   }

    #   @matches.push(match_hash)