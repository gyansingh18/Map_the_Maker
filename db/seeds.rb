puts "Creating seeds"

puts "Destroying everything"
ReviewProduct.destroy_all
Product.destroy_all
Review.destroy_all
Maker.destroy_all
User.destroy_all

puts "Creating users"
users = []

first_names = ["Alizee", "Clint", "Ashely", "Gyan", "Jannis"]
last_names = ["Apple", "Cucumber", "Avocado", "Garlic", "Jackfruit"]


first_names.each_with_index do |first_name, index|
  temp_user = User.create!(
    first_name: first_name,
    last_name: last_names[index],
    email: "#{first_name}.#{last_names[index]}@gmail.com",
    password: "superstrong"
  )
  users << temp_user
end

puts "Created #{users.count} users"

puts "Creating makers"
makers = []

first_names = ["Adi", "Budi", "Citra", "Dewi", "Eka", "Fajar", "Gita", "Hendra", "Intan", "Joko"]
types = ["shop", "hut", "shack", "store"]
locations = ["Canggu", "Ubud", "Uluwatu", "Kuta", "Seminyak"]
descriptions = ["A nice little shop", "Maker selling their own produce", "Super local maker", "A local legend", "A local maker which has been around for decades"]

maker_image_links = ["https://images.unsplash.com/photo-1591003659159-54a5579d395e?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"]

10.times do
  temp_primary_category = Maker::CATEGORIES.sample
  temp_name = "#{first_names.sample}'s #{temp_primary_category} #{types.sample}"

  temp_categories = []
  temp_categories << temp_primary_category

  rand(0..2).times do
    temp_categories << Maker::CATEGORIES.sample
  end
  temp_categories = temp_categories.uniq()

  temp_maker = Maker.new(
    name: temp_name,
    location: locations.sample,
    description: descriptions.sample,
    categories: temp_categories,
    user: users.sample
  )

  link = maker_image_links.sample
  file = URI.parse(link).open
  temp_maker.photos.attach(io: file, filename: "photo.png", content_type: "image/png")
  temp_maker.save!

  makers << temp_maker
end

puts "Created #{makers.count} makers"

puts "Creating reviews"
reviews = []

comments = ["Best maker everrr!", "Food was soooo yummy", "Overall a great experience", "Nothing to complain about", "The maker even gave me some free samples!!"]

makers.each do |maker|
  rand(1..3).times do
    temp_review = Review.create!(
      comment: comments.sample,
      overall_rating: rand(1..5),
      freshness_rating: rand(1..5),
      service_rating: rand(1..5),
      product_range_rating: rand(1..5),
      accuracy_rating: rand(1..5),
      maker: maker,
      user: users.sample
    )

    reviews << temp_review
  end

end

puts "Created #{reviews.count} reviews"

puts "Creating products"
products = []
category_products = []
products_hash = {}

all_products = {
  "meat" => ["chicken", "beef", "pork"],
  "seafood" => ["tuna", "salmon", "shrimp"],
  "vegetables" => ["broccoli", "tomato", "potato"],
  "fruits" => ["apple", "orange", "pineapple"],
  "dairy" => ["milk", "cheese", "yoghurt"],
  "other" => ["cigis", "oat milk", "candy"],
  "drinks" => ["bintang", "juice", "lemonade"],
  "grains" => ["rice", "wheat", "quinoa"],
  "bakery & pastries" => ["baguette", "sourdough", "pretzel"],
  "eggs" => ["white egg", "brown egg", "ostrich egg"]
  }

Maker::CATEGORIES.each do |category|
  category_products = []
  [0,1,2].each do |number|
    temp_product = Product.create!(
      name: all_products[category][number],
      category: category
    )
    products << temp_product
    category_products << temp_product
  end
  products_hash[category] = category_products
end

puts "Created #{products.count} products"

puts "Creating reviews_products"
reviews_products = []

reviews.each do |review|
  (0..rand(0..2)).to_a.each do |index|
    temp_product = products_hash[review.maker.categories[0]][index]
    temp_reviews_product = ReviewProduct.create!(
      product: temp_product,
      review: review
    )
    reviews_products << temp_reviews_product
  end
end

puts "Created #{reviews_products.count} reviews_products"
