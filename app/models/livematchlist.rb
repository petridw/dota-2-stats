class Livematchlist
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :livematches

  #remove any lists older than 60 minutes
  def self.clean
    livematchlists = Livematchlist.all

    livematchlists.each do |lml|
      age = Time.now.to_i - lml.created_at.to_time.to_i 

      if age > 3600
        lml.delete
      end
    end
  end
end
