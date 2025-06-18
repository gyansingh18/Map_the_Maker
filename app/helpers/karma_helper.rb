module KarmaHelper
  def render_karma_transaction_description(transaction)
    description = ""
    link_path = nil
    link_text = nil

    # Infer the base action type from source_type and points_awarded
    case transaction.source_type
    when 'Maker'
      # Assuming Maker source with Maker points means 'added a new Maker'
      if transaction.points_awarded == KarmaConfig::POINTS_FOR_ADDING_MAKER
        description = "added a new Maker"
        if transaction.source.present?
          link_path = maker_path(transaction.source)
          link_text = transaction.source.name
        end
      else
        # Fallback for Maker-related points not matching 'add maker' points
        description = "earned points related to a Maker"
      end
    when 'Review'
      # Assuming Review source with Review points means 'added a new review'
      if transaction.points_awarded == KarmaConfig::POINTS_FOR_SUBMITTING_REVIEW
        description = "added a new review"
        if transaction.source.present? && transaction.source.maker.present?
          link_path = maker_path(transaction.source.maker)
          link_text = transaction.source.maker.name
        end
      else
        # Fallback for Review-related points not matching 'submit review' points
        description = "earned points related to a Review"
      end
    when 'User'
      # This case handles sign-up where the User object itself is the source
      if transaction.points_awarded == KarmaConfig::POINTS_FOR_SIGNING_UP
        description = "created a new account"
      else
        # Fallback for User source not matching 'sign up' points (e.g., future 'profile updated' karma)
        description = "earned points related to their user account"
      end
    else
      # General fallback for any unexpected source_type
      description = "performed an action"
    end

    # Construct the final string with link if available
    if link_path.present? && link_text.present?
      "#{description}: #{link_to(link_text, link_path)}".html_safe
    else
      description.html_safe
    end
  end
end
