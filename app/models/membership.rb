class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :beer_club_id, :uniqueness => {:scope => :user_id}
end
