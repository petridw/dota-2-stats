class LivematchlistJob
  include SuckerPunch::Job

  # Get list of live games from Steam and save relevant player and livematch data
  def perform

    matchlist_json = SteamController.get_live_games

    # keep list of leagues up to date
    League.update_leagues

    # keep only up-to-date livematchlists
    Livematchlist.clean

    livematchlist = Livematchlist.new

    matchlist_json.each do |match_json|


      # Update league last_active date
      league = League.find(match_json['league_id'].to_i)

      if league
        league.last_active = DateTime.now 
        league.save
      else
        puts "league wasn't found :("
      end

      # -----
      # Get player info from this match's JSON and store it
      # -----
      if match_json['players']
        match_json['players'].each do |p|

          #make sure player is on a team and not a caster
          if (p['team'] == 0) || (p['team'] == 1)

            pro_player = Proplayer.find(p['account_id'])

            if pro_player
              puts "Found proplayer #{p['name']} in database."
              pro_player.aliases.push(p['name']) unless pro_player.aliases.include? p['name']
              pro_player.tier = match_json['league_tier'] if match_json['league_tier'] != nil
              pro_player.last_active = DateTime.now
              pro_player.last_league = league.name if league
            else
              pro_player = Proplayer.new(
                id: p['account_id'],
                aliases: [p['name']],
                teams: [],
                tier: match_json['league_tier']
                )
            end

            #if team data exists then add that to the proplayer data
            if (p['team'] == 0) && (match_json['radiant_team'])
              unless pro_player.teams.include? match_json['radiant_team']['team_name']
                pro_player.teams.push(match_json['radiant_team']['team_name'])
              end
            elsif (p['team'] == 1) && (match_json['dire_team'])
              unless pro_player.teams.include? match_json['dire_team']['team_name']
                pro_player.teams.push(match_json['dire_team']['team_name'])
              end
            end

            if pro_player.save
              puts "Saved pro player data successfully."
            else
              puts "Was unable to save pro player data for #{p['name']}"
            end

          end
        end
      end


    # -----
    # Get match info from this match's JSON and store it in the livematchlist
    # -----
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

      radiant.name = "Radiant"
      dire.name = "Dire"

      # If the match hasn't started yet then the scoreboard won't exist
      if match_json['scoreboard']


        # -----
        # Get relevant information from the scoreboard JSON for this match:
        # -----
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


        # -----
        # Get the Radiant player data from this match
        # -----
        match_json['scoreboard']['radiant']['players'].each do |p|

          liveplayer = Liveplayer.new

          puts "finding hero name for ID: #{p['hero_id']}"
          hero = Hero.find(p['hero_id'])

          if hero
            hero_name = hero.name.downcase.gsub(" ", "_")
          else
            hero_name = "No hero yet"
          end

          liveplayer.id = p['account_id']
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

        # -----
        # Get the Dire player data from this match
        # -----
        match_json['scoreboard']['dire']['players'].each do |p|

          liveplayer = Liveplayer.new
    
          puts "finding hero name for ID: #{p['hero_id']}"
          hero = Hero.find(p['hero_id'])

          if hero
            hero_name = hero.name.downcase.gsub(" ", "_")
          else
            hero_name = "No hero yet"
          end

          liveplayer.id = p['account_id']
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

          dire.liveplayers.push(liveplayer)

        end

      end

      # -----
      # Get team names and logos. Sometimes these sections don't get returned in the JSON.
      # -----
      if match_json['radiant_team']
        radiant.name = match_json['radiant_team']['team_name']
        radiant.team_logo = match_json['radiant_team']['team_logo']
      end
      if match_json['dire_team']
        dire.name = match_json['dire_team']['team_name']
        dire.team_logo = match_json['dire_team']['team_logo']
      end


      # -----
      # Once all data about this match has been acquired, push the two teams into the
      # livematch's team list and then push the livematch onto the livematchlist
      # -----
      livematch.liveteams.push(radiant)
      livematch.liveteams.push(dire)

      livematchlist.livematches.push(livematch)

    end


    if livematchlist.save
      puts "Live match list saved and updated at #{livematchlist.created_at}"
    else
      puts "Error saving live match list."
    end

  end

end