class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beer_club

  validates :beer_club_id, :uniqueness => {:scope => :user_id}

  #validate :check_if_already_joined

  def check_if_already_joined
    #if Membership.where(["user_id = ? and beer_club_id = ?", user_id, beer_club_id]).any?
      #byebug
      #errors.add(:base, "You can't join the same club twice!")
    #end
  end

end
