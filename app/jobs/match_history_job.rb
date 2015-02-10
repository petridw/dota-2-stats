class MatchHistoryJob
  include SuckerPunch::Job

  # ----------
  # This job uses the SteamController to obtain match history for a steam_id.
  # 
  # steam_id: Integer. User's steam_id
  # reload: Boolean. Whether or not to reload this player's data if it's already there
  # uid: Integer. Users's account id. Used to link proplayers to this account if any
  #               are found in the player's matches.
  # ----------
  def perform(steam_id, reload, uid)

    start_at = nil      # if specified, gives a start location for the SteamController's match search
    more_matches = true # false when there are no more matches to be obtained from Steam
    matches = []        # will hold list of all of user's matches

    begin

      # -----
      # Obtain all of user's match history from Steam Web API. The match history call
      # is limited to returning 100 results at a time, so we will loop through it and
      # continue calling it with a new "start_at" match until no more matches are returned.
      # -----
      while more_matches do

        match_array = SteamController.get_match_history(steam_id, start_at)

        # if something gets returned then save it, otherwise something went wrong
        if match_array
          matches += match_array
        else
          break
        end

        # if only one or fewer matches are returned then this means that there are definitely
        # no more. Otherwise, set the new start_at point to be the last match_id that was returned.
        if match_array.count <= 1
          more_matches = false
        else
          start_at = match_array[-1]['match_id']
        end

      end


      # -----
      # Now that we have a list of all of the player's matches, we check if we already have them
      # in our DB or not. If we do then we only update them if "reload" is true. If we don't, then
      # we update them regardless.
      # -----
      matches.each do |match_json|

        match = Match.find(match_json['match_id'])

        if match == nil || reload
          puts "didn't find match so about to save it"

          # -----
          # Start a new synchronous MatchJob which will obtain the important information about
          # this match from the Steam API, parse it, and save it.
          # -----
          MatchJob.new.perform(match_json['match_id'], reload, uid)

          # error = match_json['match_id']
          # match = Match.new(error: error)
        else
          puts "found match so didn't save it"
        end

      end

    end

  rescue
    puts "MATCH HISTORY FOR #{steam_id} FUCKIN ERRORED DOG"
  end

end