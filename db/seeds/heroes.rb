filename = File.join(Rails.root, 'app', 'assets', 'data', 'heroes.json')
file = File.read(filename)

heroes = JSON.parse(file)['heroes']


heroes.each do |hero|

  hero_in_db = Hero.find(hero['id'].to_i)

  if hero_in_db
    hero_in_db.update(name: hero['name'])
  else
    Hero.create(name: hero['name'], id: hero['id'])
  end
end