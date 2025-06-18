# app/models/concerns/karma_config.rb

module KarmaConfig

  POINTS_FOR_ADDING_MAKER = 50
  POINTS_FOR_SUBMITTING_REVIEW = 10

  TIERS = {
    community_contributor: { min_points: 0, display_name: "Community Contributor" },
    local_food_finder: { min_points: 100, display_name: "Local Foodie" },
    map_maestro: { min_points: 250, display_name: "Map Maestro" },
    local_hero: { min_points: 500, display_name: "Local Hero" },
    food_legend: { min_points: 1000, display_name: "Local Legend" }
  }.freeze
end
