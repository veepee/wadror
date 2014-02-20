module RatingAverage
  extend ActiveSupport::Concern
  
  def average_rating
    if ratings.size > 0
      return ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.size
    else
      return 0
    end
  end
end
