class Brewery < ActiveRecord::Base
  include RatingAverage
  
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers  

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil, false] }

  validates :name, presence: true
  validates :year, numericality: { only_integer: true }
  
  validate :brewery_year_validation

  def brewery_year_validation
    if year < 1042 or year > Time.now.year
      errors.add(:year, "The year must be in range 1042 - #{Time.now.year}")
    end
  end

  def self.top(n)
    Brewery.all.sort_by { |b| b.average_rating }.reverse.take(n)
  end

end
