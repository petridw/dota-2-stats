filename = File.join(Rails.root, 'app', 'assets', 'data', 'heroes.json')
file = File.read(filename)

heroes = JSON.parse(file)['heroes']

heroes.each do |hero|
  Hero.create(name: hero['name'], id: hero['id'])
end