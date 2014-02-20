class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    "#{name}"    
  end

  def self.top(n)
    Style.all.sort_by { |s| s.average_rating }.reverse.take(n)
  end

end
