#seed item data
# filename = Rails.root.to_s + "/assets/data/items.json"
filename = File.join(Rails.root, 'app', 'assets', 'data', 'items.json')
file = File.read(filename)
items = JSON.parse(file)['items']

items.each do |item|
  Item.create(name: item['name'], id: item['id'])
end