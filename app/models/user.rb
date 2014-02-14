class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }

  validates :password, length: { minimum: 4 },
                       format: { with: /.*[0-9].*/ },
                       format: { with: /.*[A-Z].*/ }

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles, styles_counts = {}, {}
    self.ratings.each do |rating|
      if styles[rating.beer.style] == nil
        styles[rating.beer.style], styles_counts[rating.beer.style] = 0, 0
      end
      styles[rating.beer.style] = styles[rating.beer.style] + rating.score
      styles_counts[rating.beer.style] = styles_counts[rating.beer.style] + 1
    end

    get_highest_average(get_average_hash(styles, styles_counts))
  end

  def favorite_brewery
    return nil if ratings.empty?
  
    breweries, breweries_counts = {}, {}
    self.ratings.each do |rating|
      if breweries[rating.beer.brewery] == nil
        breweries[rating.beer.brewery], breweries_counts[rating.beer.brewery] = 0, 0
      end
      breweries[rating.beer.brewery] = breweries[rating.beer.brewery] + rating.score
      breweries_counts[rating.beer.brewery] = breweries_counts[rating.beer.brewery] + 1
    end

    get_highest_average(get_average_hash(breweries, breweries_counts))
  end

  def get_average_hash(sum_hash, count_hash)
    average_hash = {}
    sum_hash.each do |key, val|
      average_hash[key] = (count_hash[key] > 0) ? sum_hash[key] / count_hash[key] : 0
    end
    average_hash
  end

  def get_highest_average(average_hash)
    average_hash.max_by { |k, v| v}[0]
  end

  def belongs_to_club(club)
    beer_clubs.include? club
  end
end
