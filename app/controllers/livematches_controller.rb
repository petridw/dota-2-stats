class LivematchesController < ApplicationController


  def index
    @pagerefresh = false

    @livematchlist = Livematchlist.last

    if @livematchlist == nil
      flash.now[:danger] = "Can't find live match list! Getting one now. Please try again soon."
      LivematchlistJob.new.async.perform
      @last_updated_string = ""
    else

      last_updated = Time.now.to_i - @livematchlist.created_at.to_time.to_i

      if last_updated > 60
        flash.now[:warning] = "Updating match data now!"
        LivematchlistJob.new.async.perform
        @pagerefresh = true
      end

      minutes = last_updated / 60
      seconds = last_updated % 60
      hours = last_updated / 3600

      @last_updated_string = "#{seconds} seconds ago."
      @last_updated_string.insert(0, "#{minutes} minutes, ") unless minutes < 1
      @last_updated_string.insert(0, "#{hours} hours, ") unless hours < 1
      @last_updated_string.insert(0, "This data was last updated ")

    end
  end

  def show

    @livematch = Livematchlist.last.livematches.find(params[:id].to_i)


  end

end