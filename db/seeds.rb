# db/seeds.rb

# Clear existing data to prevent duplicates on re-seeding
puts "Cleaning up database..."
KarmaTransaction.destroy_all
ReviewProduct.destroy_all
Review.destroy_all
Maker.destroy_all
Product.destroy_all
User.destroy_all
puts "Database cleaned!"

# --- Constants for data generation ---
CATEGORIES = ["meat", "seafood", "vegetables", "fruit", "dairy", "drinks", "grains", "bakery & pastries", "eggs"]

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
  "Pererenan, Bali, Indonesia", "Ubud, Bali, Indonesia", "Uluwatu, Bali, Indonesia",
  "Kuta, Bali, Indonesia", "Seminyak, Bali, Indonesia", "Denpasar, Bali, Indonesia",
  "Sanur, Bali, Indonesia", "Nusa Dua, Bali, Indonesia", "Jimbaran, Bali, Indonesia",
  "Negara, Bali, Indonesia", "Singaraja, Bali, Indonesia", "Lovina, Bali, Indonesia",
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

# --- Create Users --- #
puts "Creating users..."
first_names = ["Alizee", "Clint", "Ashley", "Gyan", "Jannis", "Dani", "Christina", "Vince"]
last_names = ["Apple", "Cucumber", "Avocado", "Garlic", "Jackfruit", "Durian", "Cherry", "Vanilla"]

users = [] # Initialize users array to store created user objects
first_names.each_with_index do |first_name, index|
  temp_user = User.create!(
    first_name: first_name,
    last_name: last_names[index],
    email: "#{first_name.downcase}.#{last_names[index].downcase}@gmail.com", # Ensure email is lowercase
    password: "superstrong"
  )
  users << temp_user # Add the created user to the users array
  puts "  Created user: #{temp_user.first_name} #{temp_user.last_name}"

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
  dynamic_name = "#{possessive(base_name)} #{shop_type.capitalize}"

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
maker_counter = 0
makers_data.each do |maker_attributes|
  maker_counter += 1
  if (maker_counter % 1 == 0) || (maker_counter == makers_data.length)
    puts "  #{maker_counter} of #{makers_data.length} Makers created..."
  end
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

# ---------------- Create Products section ----------------

# Define all products data
ALL_PRODUCTS_HASH = {
  "meat" => ["chicken", "beef", "pork"],
  "seafood" => ["tuna", "salmon", "shrimp"],
  "vegetables" => ["broccoli", "tomato", "potato"],
  "fruit" => ["apple", "orange", "pineapple"],
  "dairy" => ["milk", "cheese", "yoghurt"],
  "other" => ["cigis", "oat milk", "candy"], # Note: 'other' category is not in MAKER_CATEGORIES
  "drinks" => ["bintang", "juice", "lemonade"],
  "grains" => ["rice", "wheat", "quinoa"],
  "bakery & pastries" => ["baguette", "sourdough", "pretzel"],
  "eggs" => ["white egg", "brown egg", "ostrich egg"]
}

# Create Products
puts "Creating products..."
products = []
product_counter = 0
ALL_PRODUCTS_HASH.each do |category, product_names|
  product_names.each do |product_name|
    product_counter += 1
    if (product_counter % 5 == 0) || (product_counter == ALL_PRODUCTS_HASH.values.flatten.length)
      puts "  #{product_counter} of #{ALL_PRODUCTS_HASH.values.flatten.length} Products created..."
    end
    # Special handling for "bakery & pastries" category to match product's single category column
    # Also, ensure category names like "meat" become "Meat" etc.
    product_category_for_db = (category == "bakery & pastries") ? "bakery" : category

    product = Product.create!(
      name: product_name.capitalize, # Capitalize product name for display
      category: product_category_for_db.capitalize # Capitalize category name for display
    )
    products << product
  rescue ActiveRecord::RecordInvalid => e
    puts "Error creating product '#{product_name}': #{e.message}"
  end
end
puts "#{products.count} products created!"

# ---------------- Create Reviews section ----------------

# db/seeds.rb
# ... (previous code for constants, user creation, maker creation, and product creation) ...

# Base comments for dynamic review generation
REVIEW_COMMENTS_BASE = [
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

# Helper to generate skewed ratings (1-5, biased towards 4s and 5s)
def skewed_rating
  # 70% chance of 4 or 5, 30% chance of 1-3
  if rand(10) < 7 # 0-6 (7 out of 10 times)
    rand(4..5)
  else
    rand(1..3)
  end
end

# Create Reviews
puts "Creating reviews and associating with products..."
reviews_count = 0
review_counter = 0
num_reviews_to_create = 100 # Create around 60 reviews

num_reviews_to_create.times do
  review_counter += 1
  if (review_counter % 25 == 0) || (review_counter == num_reviews_to_create)
    puts "  #{review_counter} of #{num_reviews_to_create} Reviews created..."
  end
  user = users.sample # Select a random user
  maker = makers.sample # Select a random maker

  # Get a relevant category from the maker for comment personalization
  maker_category_for_comment = maker.categories.sample

  # Generate a dynamic and positive comment
  base_comment = REVIEW_COMMENTS_BASE.sample
  dynamic_comment = base_comment.sub("The item I got", "The #{maker_category_for_comment} I got") # Example enhancement
  dynamic_comment = dynamic_comment.sub("This place", "#{maker.name.gsub("'", "")}") # Replace "This place" with maker's name
  dynamic_comment = dynamic_comment.sub("their items", "#{maker_category_for_comment} items") # Another enhancement
  dynamic_comment = dynamic_comment.sub("the products", "the #{maker_category_for_comment} products") # Another enhancement
  dynamic_comment = dynamic_comment.sub("the food", "the #{maker_category_for_comment}") # Another enhancement
  dynamic_comment = dynamic_comment.sub("The product", "The #{maker_category_for_comment} product") # Another enhancement


  review = Review.new(
    user: user,
    maker: maker,
    comment: dynamic_comment,
    overall_rating: skewed_rating,
    freshness_rating: skewed_rating,
    service_rating: skewed_rating,
    product_range_rating: skewed_rating,
    accuracy_rating: skewed_rating
  )

  if review.save
    reviews_count += 1

    # Associate 1-2 products with the review, matching maker's categories
    eligible_products = products.select do |product|
      # Check if any of the product's categories are in the maker's categories
      maker.categories.any? { |maker_cat| product.category.downcase == maker_cat.split(' & ')[0].downcase.gsub(' ', '_') }
    end

    num_products_to_associate = rand(1..[eligible_products.count, 2].min) # 1 or 2 products, max 2
    products_for_review = eligible_products.sample(num_products_to_associate).uniq

    products_for_review.each do |product|
      ReviewProduct.create!(review: review, product: product)
    rescue ActiveRecord::RecordInvalid => e
      puts "Error creating ReviewProduct for review #{review.id} and product #{product.id}: #{e.message}"
    end
  else
    puts "Error creating review: #{review.errors.full_messages.to_sentence}"
  end
end
puts "#{reviews_count} reviews and their product associations created!"
