class MatchHistoryJob
  include SuckerPunch::Job

  def perform(steam_id, reload)

    start_at = nil
    more_matches = true
    matches = []
    count = 0

    while more_matches do

      match_array = SteamController.get_match_history(steam_id, start_at)

      matches += match_array

      if match_array.count <= 1
        more_matches = false
      else
        start_at = match_array[-1]['match_id']
      end

    end

    matches.each do |match_json|

      match = Match.find(match_json['match_id'])

      if match == nil || reload
        puts "didn't find match so about to save it"

        MatchJob.new.perform(match_json['match_id'], reload)

        # error = match_json['match_id']
        # match = Match.new(error: error)
      else
        puts "found match so didn't save it"
      end

    end

  end

end