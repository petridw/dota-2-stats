#seed item data
# filename = Rails.root.to_s + "/assets/data/items.json"
filename = File.join(Rails.root, 'app', 'assets', 'data', 'items.json')
file = File.read(filename)
items = JSON.parse(file)['items']

items.each do |item|
  item_in_db = Item.find(item['id'].to_i) 
  if item_in_db
    item_in_db.update(name: item['name'])
  else
    Item.create(name: item['name'], id: item['id'])
  end
end