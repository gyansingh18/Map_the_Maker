puts "Creating seeds"

puts "Destroying everything"
KarmaTransaction.destroy_all
ReviewProduct.destroy_all
Product.destroy_all
Review.destroy_all
Maker.destroy_all
User.destroy_all

puts "Creating users"
users = []

first_names = [
  "Alizee",
  "Clint",
  "Ashley",
  "Gyan",
  "Jannis",
  "Dani",
  "Christina",
  "Vince"
]

last_names = [
  "Apple",
  "Cucumber",
  "Avocado",
  "Garlic",
  "Jackfruit",
  "Daisy",
  "Cherry",
  "Viande"
]

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

first_names = [
  "Adi",
  "Budi",
  "Citra",
  "Dewi",
  "Eka",
  "Fajar",
  "Gita",
  "Hendra",
  "Intan",
  "Joko",
  "Kartika",    # Common female name
  "Lukman",     # Common male name
  "Maya",       # Common female name
  "Nadia",      # Common female name
  "Putra",      # Common male name (means 'son')
  "Rini",       # Common female name
  "Santi",      # Common female name
  "Tomi",       # Common male name
  "Umar",       # Common male name
  "Vina",       # Common female name
  "Wahyu",      # Common male name (means 'revelation/guidance')
  "Yanto",      # Common male name
  "Zahra",      # Common female name (Arabic origin, very common in Indonesia)
  "Andi",       # Common male name
  "Ani"         # Common female name
]

types = [
  "shop",
  "hut",
  "shack",
  "store",
  "warung",       # A small, often family-owned, business or eatery common in Indonesia
  "kios",         # Kiosk; a small, often enclosed stand
  "gerai",        # Stall or booth, often found in markets or malls
  "lapak",        # A more informal or temporary stall/stand, often on a street
  "boutique",     # Suggests a specialized, often higher-end, curated selection
  "market stall", # A specific type of stall found within a larger market
  "pop-up",       # A temporary retail space
  "co-op",        # Cooperative, implies community ownership or collaboration
  "depot",        # Suggests a direct supply point or warehouse outlet
  "corner"        # Implies a small, dedicated section within a larger space (e.g., "farm corner")
]

locations = [
  "Canggu, Bali, Indonesia",
  "Ubud, Bali, Indonesia",
  "Uluwatu, Bali, Indonesia",
  "Kuta, Bali, Indonesia",
  "Seminyak, Bali, Indonesia",
  "Denpasar, Bali, Indonesia",        # Capital city
  "Sanur, Bali, Indonesia",           # East coast, calmer
  "Nusa Dua, Bali, Indonesia",        # Southern tip, resorts
  "Jimbaran, Bali, Indonesia",        # South, seafood, bay
  "Tabanan, Bali, Indonesia",         # West-central, agricultural heartland
  "Singaraja, Bali, Indonesia",       # North coast, historical
  "Lovina, Bali, Indonesia",          # North coast, dolphin watching
  "Amed, Bali, Indonesia",            # East coast, diving
  "Sidemen, Bali, Indonesia",         # East, rural, rice paddies
  "Kintamani, Bali, Indonesia",       # Central highlands, volcano views
  "Bedugul, Bali, Indonesia",         # Central highlands, lakes & temples
  "Padangbai, Bali, Indonesia",       # East, ferry port, diving
  "Candidasa, Bali, Indonesia",       # East coast resort town
  "Gianyar, Bali, Indonesia",         # Central-east, cultural crafts
  "Bangli, Bali, Indonesia"           # Central, mountainous, traditional villages
]

descriptions = [
  "Cultivating organic produce with care, from our family farm directly to you.",
  "Harvested fresh daily from our sustainable permaculture gardens in Bali.",
  "Crafting high-quality, local meat products from ethically raised livestock.",
  "Bringing the freshest catch from our boats in the pristine Balinese waters.",
  "Producing small-batch artisanal dairy goods from happy, free-roaming cows.",
  "Dedicated to traditional Balinese rice cultivation, honoring ancient methods.",
  "Offering premium selections of tropical fruits grown in our island orchards.",
  "Hand-picked spices from our lush gardens, enhancing every culinary creation.",
  "Ethical beekeeping practices yield pure, raw Balinese honey from island blossoms.",
  "Carefully roasted Arabica beans sourced directly from our Kintamani coffee estate.",
  "Our passion for honest food drives our commitment to sustainable farming.",
  "Bringing you the true essence of Bali's rich agricultural harvest, nurtured by hand.",
  "Committed to natural and chemical-free cultivation for wholesome ingredients.",
  "Ensuring freshness and quality, our products go directly from our hands to yours.",
  "Rooted in tradition, we grow for the future of Bali's culinary heritage.",
  "Experience the authentic taste of island produce, grown with generations of knowledge.",
  "Nurturing the land and enriching the plate with every item we offer.",
  "Family-owned and operated, dedicated to excellence in every aspect of our production.",
  "Specializing in unique Balinese heirloom varieties, preserving our island's biodiversity.",
  "Our dedication ensures the freshest ingredients, from our fields to your kitchen."
]

maker_image_links = {
  "meat" =>[
    "https://live-production.wcms.abc-cdn.net.au/1b4abc68c6c4fdca870a79508c8ff991?impolicy=wcms_crop_resize&cropH=719&cropW=1280&xPos=0&yPos=0&width=862&height=485",
    "https://dam.mediacorp.sg/image/upload/s--QMWnmhWZ--/c_crop,h_843,w_1500,x_0,y_123/c_fill,g_auto,h_468,w_830/fl_relative,g_south_east,l_mediacorp:cna:watermark:2021-08:cna,w_0.1/f_auto,q_auto/v1/mediacorp/cna/image/2022/06/01/tiong_bahru_02.jpg?itok=YQxTym9D"],
  "seafood" => [
    "https://indonesiaexpat.id/wp-content/uploads/2013/01/Various_tuna_and_mackerel_for_sale_in_Jimbaran.jpg.webp",
    "https://balibuddies.com/wp-content/uploads/2024/08/Seller-cutting-fishes-at-Jimbaran-Fish-Market-min-1024x768.jpeg"],
  "vegetables" => [
    "https://cdn.iklimku.org/wp-content/uploads/2023/11/23160908/IL-MALINO-02.jpg",
    "https://files.globalgiving.org/pfil/53284/pict_featured_jumbo.jpg?t=1659462732000"],
  "fruits" => [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2sXgxzcxyB82xbgb-2MrzCZOKntRJnd1Ncw&s",
    "https://media.istockphoto.com/id/470519520/photo/roadside-fruit-market-in-bali-indonesia.jpg?s=612x612&w=0&k=20&c=w8plqJ6r3okHP9tBFyT8DFRjNanroa4PrOr16M73PhE="],
  "dairy" => [
    "https://cdn.antaranews.com/cache/1200x800/2011/03/20110311111242hargasusu080311-3.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBpJVrqJckftsx5JkFntl0dm15kfQGPUsulA&s"],
  "other" => [
    "https://anekamarket.com/cdn/shop/files/Inside_1_2048x.jpg?v=1614893803",
    "https://149346090.v2.pressablecdn.com/wp-content/uploads/2021/09/20210915_ROW_WARUNG_PINTAR_00171-1-scaled.jpg"],
  "drinks" => [
    "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/27/67/68/51/empty.jpg?w=1400&h=800&s=1",
    "https://www.ministryofvillas.com/wp-content/uploads/2018/02/bali-canggu-popular-deli-wine.jpg"],
  "grains" => [
    "https://img.jakpost.net/c/2020/03/19/2020_03_19_89936_1584591042._large.jpg",
    "https://assets.rikolto.org/styles/universal_metatag_opengraph_image/s3/project/images/_mg_8096-2_0.jpg?itok=fqtd9eDa"],
  "bakery & pastries" => [
    "https://lh5.googleusercontent.com/p/AF1QipPq4LrxQGpRESWdHlZdM_7oR25gvEaNeqnJlhYR=w408-h306-k-no",
    "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEioUWeX1Sl8pVO5HLtp8wsDrrYyMjDXQ_u4d5RGx-I0Ps3WhIUVpQV824j_mqiUYXudbZJ1SQI2oWrqeuYeK-9QuPNT8G5yxg6SSKUIBNfGItdjV8UOnIDxTuez1tjYpylyWbJGbqtGa6wbtFHlclut8yYEokvoO-NrS9oxUnq8eacyLt-WbKV3/w640-h428/01%20TWN_9661%20Innland%20Bakery%20@%20George%20Town%20in%20Penang%20%5BMalaysia%5D%20.JPG"],
  "eggs" => [
    "https://media.licdn.com/dms/image/v2/C4E12AQH1-BSSiaCSnA/article-inline_image-shrink_1500_2232/article-inline_image-shrink_1500_2232/0/1521635189099?e=1754524800&v=beta&t=Dy4Abfw4OTNFNzx2pvvEE-4ZVzsxzvz9W57e8K1n8AE",
    "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEix85NoybpnxjjHnKcttQvJDoftmapdubKkLELmudVew-8Q69ZSqlO9cUMQ0HHlzqhxfO4J1bj0U3tPGMQaiHf9lz6TDWhL29KIKwR7eNQCzt77Lew3s_AwFTHZlQY5ZFQu7CUrmZxkdjM/s1600/chia-song-kun.jpg"]
  }

25.times do
  temp_primary_category = Maker::CATEGORIES.sample
  temp_name = "#{first_names.sample}'s #{temp_primary_category} #{types.sample}"

  temp_categories = []
  temp_categories << temp_primary_category

  rand(1..3).times do
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

  link = maker_image_links[temp_categories.sample].sample
  file = URI.parse(link).open
  temp_maker.photos.attach(io: file, filename: "photo.png", content_type: "image/png")
  temp_maker.save!

  makers << temp_maker
end

puts "Created #{makers.count} makers"

puts "Creating reviews"
reviews = []

comments = [
  "Fantastic experience! The food was incredibly fresh.",
  "Highly recommend for their delicious offerings.",
  "The item I got was superb. Will definitely return!",
  "Great quality and friendly service. So glad to find this place.",
  "Loved the product. Exactly what I was looking for.",
  "A true gem! This place offers amazing goods and a wonderful atmosphere.",
  "Couldn't be happier with the freshness. Quality is guaranteed.",
  "The staff were so helpful, and the products were excellent.",
  "My go-to place now. This spot never disappoints!",
  "Found this place and tried their items. Absolutely delighted!",
  "A local legend for quality. They truly deliver.",
  "The product was so yummy, exactly what I hoped for.",
  "Overall a great experience shopping here. The products were top-notch.",
  "Nothing to complain about, this place is fantastic!",
  "The maker even gave me some free samples!",
  "Amazing products and lovely people. A must-visit!",
  "So impressed with the quality available here.",
  "This place has the best items in town. Thank you!",
  "Fresh, local, and delicious. Can't ask for more.",
  "Beyond expectations! They offer exquisite products.",
  "Every visit is a pleasure, always finding fresh items.",
  "Authentic local goods found here. A real taste of Bali.",
  "The item was so good, I bought extra!",
  "Fantastic range of products. Something for everyone.",
  "The service made the experience even better, and the products were perfect."
]

makers.each do |maker|
  rand(1..3).times do
    temp_review = Review.create!(
      comment: comments.sample,
      overall_rating: rand(3..5),
      freshness_rating: rand(3..5),
      service_rating: rand(3..5),
      product_range_rating: rand(3..5),
      accuracy_rating: rand(3..5),
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
  [0, 1, 2].each do |number|
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
