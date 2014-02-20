class Rating < ActiveRecord::Base
  belongs_to :beer, touch: true
  belongs_to :user

  belongs_to :brewery, touch: true

  scope :recent, -> { order('created_at DESC').limit(5) }

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "#{beer.name} #{score}"
  end
end
