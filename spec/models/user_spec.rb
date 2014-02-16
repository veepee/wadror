require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "with an invalid password" do
    it "that is too short is neither saved nor valid" do
      user = User.create username:"Pekka", password:"ab1", password_confirmation:"ab1"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
    it "consisting only of letters is neither saved nor valid" do
      user = User.create username:"Pekka", password:"onlyletters", password:"onlyletters"

      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(10, user)               

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated one if only one rating" do
      test_style = Style.create name: "Test style"
      style = create_style_with_rating(20, test_style, user)
      expect(user.favorite_style).to eq(style)
    end

    it "is the style with highest average when several rated" do
      lager = Style.create name: "Lager"
      ipa = Style.create name: "IPA"
      lowalc = Style.create name: "Lowalcohol"

      create_style_with_ratings(15, 12, 11, lager, user)
      create_style_with_ratings(20, 9, 14, ipa, user)
      create_style_with_ratings(5, 9, 12, 10, 11, 2, lowalc, user)

      expect(user.favorite_style).to eq(ipa)
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated one if only one rating" do
      brewery = create_brewery_with_ratings(20, user)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with highest average when several rated" do
      create_brewery_with_ratings(15, user)
      best = create_brewery_with_ratings(12, 22, user)
      create_brewery_with_ratings(14, 10, 5, 3, 7, user)

      expect(user.favorite_brewery).to eq(best)
    end
  end

end

def create_brewery_with_ratings(*scores, user)
  brewery = Brewery.create name:"Test", year:1993
  style = Style.create name: "Lager"
  beer = Beer.create name:"Test", brewery:brewery, style:style
  scores.each do |score|
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  end
  brewery
end

def create_style_with_ratings(*scores, style, user)
  scores.each do |score|
    create_style_with_rating score, style, user
  end
end

def create_style_with_rating(score, style, user)
  brewery = FactoryGirl.create(:brewery)
  beer = Beer.create name:"Test", brewery:brewery, style:style
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  style
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
