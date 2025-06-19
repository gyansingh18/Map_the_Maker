# db/seeds.rb

# Clear existing data to prevent duplicates on re-seeding
puts "Cleaning up database..."
ReviewProduct.destroy_all
Review.destroy_all
Maker.destroy_all
Product.destroy_all # Even if not seeding products, it's good practice to clear if they exist
User.destroy_all
puts "Database cleaned!"

# --- Constants for data generation ---
CATEGORIES = ["meat", "seafood", "vegetables", "fruits", "dairy", "drinks", "grains", "bakery & pastries", "eggs"]

SHOP_TYPES = [
  "shop", "hut", "shack", "store", "warung", "kios",
  "gerai", "lapak", "boutique", "market stall", "pop-up",
  "co-op", "depot", "corner"
]

MAKER_NAMES_BASE = [
  "Adi", "Budi", "Citra", "Dewi", "Eka", "Fajar", "Gita", "Hendra", "Intan", "Joko",
  "Kartika", "Lukman", "Maya", "Nadia", "Putra", "Rini", "Santi", "Tomi", "Umar",
  "Vina", "Wahyu", "Yanto", "Zahra", "Andi", "Ani"
]

MAKER_LOCATIONS = [
  "Canggu, Bali, Indonesia", "Ubud, Bali, Indonesia", "Uluwatu, Bali, Indonesia",
  "Kuta, Bali, Indonesia", "Seminyak, Bali, Indonesia", "Denpasar, Bali, Indonesia",
  "Sanur, Bali, Indonesia", "Nusa Dua, Bali, Indonesia", "Jimbaran, Bali, Indonesia",
  "Tabanan, Bali, Indonesia", "Singaraja, Bali, Indonesia", "Lovina, Bali, Indonesia",
  "Amed, Bali, Indonesia", "Sidemen, Bali, Indonesia", "Kintamani, Bali, Indonesia",
  "Bedugul, Bali, Indonesia", "Padangbai, Bali, Indonesia", "Candidasa, Bali, Indonesia",
  "Pupuan, Bali, Indonesia", "Bangli, Bali, Indonesia"
]

MAKER_DESCRIPTIONS_BASE = [
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

IMAGE_FILENAMES = [
  "bakery_mehmet-uzut-obMFCck7DqQ-unsplash.jpeg",
  "bakery_wu-yi-uTGFjtFeenY-unsplash.jpeg",
  "bakery_yusong-he-zt_KPBJBVPY-unsplash.jpeg",
  "dairy_paul-harris-H00UTOYLULY-unsplash.jpeg",
  "drinks_bram-wouters-Dc2fwveqbDQ-unsplash.jpeg",
  "drinks_sonaal-bangera-Wa9dHWRDNwo-unsplash.jpeg",
  "eggs_gurth-bramall-FJaZ_bh_pGU-unsplash.jpeg",
  "eggs_kelvin-zyteng-5yWmvGipjRw-unsplash.jpeg",
  "fruit_carl-campbell-XuKZZQiZRVk-unsplash.jpeg",
  "fruit_meritt-thomas-qVNSANBjYdI-unsplash.jpeg",
  "fruit_quang-nguyen-vinh-aWROBaEVLyQ-unsplash.jpeg",
  "grains_daniel-bernard-QQrIwDtOj4c-unsplash.jpeg",
  "grains_nathan-cima-n2sy8zlngYo-unsplash.jpeg",
  "grains_quang-nguyen-vinh-8yLDASB9jHs-unsplash.jpeg",
  "other_chelaxy-designs-jRi4Ww7jj10-unsplash.jpeg",
  "other_duy-ngo-U2_SHtC7cP4-unsplash.jpeg",
  "seafood_harrison-chang-yv_WM9tRZgs-unsplash.jpeg",
  "seafood_mche-lee-y3ieHcnC99k-unsplash.jpeg",
  "seafood_ruslan-bardash-mcXGXFBUwis-unsplash.jpeg",
  "vegetables_harshal-more-44ESruq0puM-unsplash.jpeg",
  "vegetables_quang-nguyen-vinh-T24GHpD_814-unsplash.jpeg"
]

# --- Create Users ---
puts "Creating users..."
users = []
5.times do |i|
  users << User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    first_name: "User",
    last_name: "#{i + 1}"
  )
end
puts "#{users.count} users created!"

# --- Helper for possessive form ---
def possessive(name)
  name.end_with?('s') ? "#{name}'" : "#{name}'s"
end

# --- Prepare Maker Data ---
puts "Preparing maker data..."
makers_data = []

# Shuffle base names and locations to ensure variety
shuffled_base_names = MAKER_NAMES_BASE.shuffle
shuffled_locations = MAKER_LOCATIONS.shuffle # Will cycle through if fewer locations than makers

MAKER_NAMES_BASE.each_with_index do |base_name, index|
  # Cycle through locations if there are fewer locations than makers
  location = MAKER_LOCATIONS[index % MAKER_LOCATIONS.length]

  # Randomly select 1 to 3 unique categories for the maker
  num_categories = rand(1..[CATEGORIES.length, 3].min)
  selected_categories = CATEGORIES.sample(num_categories).uniq

  # Pick one of the selected categories to use in the maker's display name and description
  display_category = selected_categories.sample

  shop_type = SHOP_TYPES.sample
  dynamic_name = "#{possessive(base_name)} #{display_category.capitalize} #{shop_type.capitalize}"

  # Get a base description and enhance it
  base_description = MAKER_DESCRIPTIONS_BASE.sample
  enhanced_description = "#{base_description} You can find a wide range of fresh, local #{display_category} at our #{shop_type}."

  # Weighted user assignment
  weighted_user_ids = []
  users.each_with_index do |user, u_index|
    weight = (5 - u_index) # User 0 gets 5 parts, user 1 gets 4 parts, etc.
    weight.times { weighted_user_ids << user.id }
  end
  user_to_assign = weighted_user_ids.sample

  makers_data << {
    name: dynamic_name,
    location: location,
    description: enhanced_description,
    categories: selected_categories,
    user_id: user_to_assign,
    display_category_for_image: display_category # Used for image selection, not saved to DB
  }
end
puts "#{makers_data.length} maker data sets prepared."

# --- Create Maker Objects and Attach Images ---
puts "Creating makers with associated images..."
makers = []
makers_data.each do |maker_attributes|
  # Create a new Maker instance, excluding the temporary image helper attribute
  temp_maker = Maker.new(maker_attributes.except(:display_category_for_image))

  # --- Image attachment logic ---
  selected_image_filename = nil
  # Prioritize the display_category for image matching, then other categories
  categories_to_check = [maker_attributes[:display_category_for_image]] + maker_attributes[:categories].reject { |c| c == maker_attributes[:display_category_for_image] }

  categories_to_check.each do |cat|
    # Convert category name to match image file prefix (e.g., "bakery & pastries" to "bakery")
    image_prefix = cat.split(' & ')[0].downcase.gsub(' ', '_')
    matching_images = IMAGE_FILENAMES.select { |fn| fn.start_with?("#{image_prefix}_") }
    if matching_images.any?
      selected_image_filename = matching_images.sample
      break # Found a suitable image, no need to check further categories
    end
  end

  # Fallback if no specific category image found
  unless selected_image_filename
    general_images = IMAGE_FILENAMES.select { |fn| fn.start_with?("other_") }
    selected_image_filename = general_images.empty? ? IMAGE_FILENAMES.sample : general_images.sample
  end

  if selected_image_filename
    file_path = Rails.root.join("app/assets/images/seeds", selected_image_filename)
    if File.exist?(file_path)
      # Determine content type based on file extension (simplified for .jpeg/.png)
      content_type = selected_image_filename.end_with?(".png") ? "image/png" : "image/jpeg"
      file = File.open(file_path)
      temp_maker.photos.attach(io: file, filename: selected_image_filename, content_type: content_type)
    else
      puts "WARNING: Image file not found at #{file_path}. Maker #{temp_maker.name} will not have an image."
    end
  end

  # Save the maker
  if temp_maker.save
    makers << temp_maker
  else
    puts "Error creating maker: #{temp_maker.errors.full_messages.to_sentence}"
  end
end
puts "#{makers.count} makers created!"

# ---------------- Create Reviews section ----------------

# puts "Creating reviews"
# reviews = []

# comments = [
#   "Fantastic experience! The food was incredibly fresh.",
#   "Highly recommend for their delicious offerings.",
#   "The item I got was superb. Will definitely return!",
#   "Great quality and friendly service. So glad to find this place.",
#   "Loved the product. Exactly what I was looking for.",
#   "A true gem! This place offers amazing goods and a wonderful atmosphere.",
#   "Couldn't be happier with the freshness. Quality is guaranteed.",
#   "The staff were so helpful, and the products were excellent.",
#   "My go-to place now. This spot never disappoints!",
#   "Found this place and tried their items. Absolutely delighted!",
#   "A local legend for quality. They truly deliver.",
#   "The product was so yummy, exactly what I hoped for.",
#   "Overall a great experience shopping here. The products were top-notch.",
#   "Nothing to complain about, this place is fantastic!",
#   "The maker even gave me some free samples!",
#   "Amazing products and lovely people. A must-visit!",
#   "So impressed with the quality available here.",
#   "This place has the best items in town. Thank you!",
#   "Fresh, local, and delicious. Can't ask for more.",
#   "Beyond expectations! They offer exquisite products.",
#   "Every visit is a pleasure, always finding fresh items.",
#   "Authentic local goods found here. A real taste of Bali.",
#   "The item was so good, I bought extra!",
#   "Fantastic range of products. Something for everyone.",
#   "The service made the experience even better, and the products were perfect."
# ]

# makers.each do |maker|
#   rand(1..3).times do
#     temp_review = Review.create!(
#       comment: comments.sample,
#       overall_rating: rand(3..5),
#       freshness_rating: rand(3..5),
#       service_rating: rand(3..5),
#       product_range_rating: rand(3..5),
#       accuracy_rating: rand(3..5),
#       maker: maker,
#       user: users.sample
#     )

#     reviews << temp_review
#   end
# end

# puts "Created #{reviews.count} reviews"

# puts "Creating products"
# products = []
# category_products = []
# products_hash = {}

# all_products = {
#   "meat" => ["chicken", "beef", "pork"],
#   "seafood" => ["tuna", "salmon", "shrimp"],
#   "vegetables" => ["broccoli", "tomato", "potato"],
#   "fruits" => ["apple", "orange", "pineapple"],
#   "dairy" => ["milk", "cheese", "yoghurt"],
#   "other" => ["cigis", "oat milk", "candy"],
#   "drinks" => ["bintang", "juice", "lemonade"],
#   "grains" => ["rice", "wheat", "quinoa"],
#   "bakery & pastries" => ["baguette", "sourdough", "pretzel"],
#   "eggs" => ["white egg", "brown egg", "ostrich egg"]
#   }

# Maker::CATEGORIES.each do |category|
#   category_products = []
#   [0, 1, 2].each do |number|
#     temp_product = Product.create!(
#       name: all_products[category][number],
#       category: category
#     )
#     products << temp_product
#     category_products << temp_product
#   end
#   products_hash[category] = category_products
# end

# puts "Created #{products.count} products"

# puts "Creating reviews_products"
# reviews_products = []

# reviews.each do |review|
#   (0..rand(0..2)).to_a.each do |index|
#     temp_product = products_hash[review.maker.categories[0]][index]
#     temp_reviews_product = ReviewProduct.create!(
#       product: temp_product,
#       review: review
#     )
#     reviews_products << temp_reviews_product
#   end
# end

# puts "Created #{reviews_products.count} reviews_products"
