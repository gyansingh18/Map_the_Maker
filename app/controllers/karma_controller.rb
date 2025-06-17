# app/controllers/karma_controller.rb

class KarmaController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    @user = current_user
    @user_karma_points = @user.karma_points

    @current_karma_tier = KarmaConfig::TIERS.values.reverse.find do |tier|
      @user_karma_points >= tier[:min_points]
    end

    @next_karma_tier = KarmaConfig::TIERS.values.find do |tier|
      @user_karma_points < tier[:min_points]
    end

    if @next_karma_tier
      points_for_current_tier = @current_karma_tier[:min_points]
      points_to_next_tier = @next_karma_tier[:min_points] - points_for_current_tier
      points_earned_in_current_tier = @user_karma_points - points_for_current_tier

      if points_to_next_tier.zero?
        @progress_percentage = 100
      else
        @progress_percentage = (points_earned_in_current_tier.to_f / points_to_next_tier * 100).round(0)
      end
    else
      @progress_percentage = 100
    end

    # --- Leaderboard logic ---
    @top_users = User.order(karma_points: :desc).limit(10)
    @user_rank = User.where('karma_points > ?', @user_karma_points).count + 1
  end
end
