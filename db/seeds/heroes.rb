require 'net/http'

url = URI.parse("https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=#{ENV['STEAM_WEB_API_KEY']}")
res = Net::HTTP::get(url)

heroes = JSON.load(res)['result']['heroes']

heroes.each do |hero|
  split_name = hero['name'].split('_')
  final_name = split_name - ['npc', 'dota', 'hero']
  final_name = final_name.join(' ')
  Hero.create(name: final_name, id: hero['id'])
end