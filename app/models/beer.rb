class Beer < ActiveRecord::Base
  include RatingAverage
  
  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name} (#{brewery.name})"
  end

  def self.top(n)
    Beer.all.sort_by { |b| b.average_rating }.reverse.take(n)
  end
end
