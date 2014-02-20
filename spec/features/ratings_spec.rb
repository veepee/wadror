require 'spec_helper'

include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given is registered to the beer and user who is signed in" do
    visit new_rating_path
    select("iso 3", from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "entries" do

    before :each do
      create_test_ratings
    end

    it "are shown on the user's profile page" do
      visit user_path(user)

      expect(page).to have_content "Has made #{user.ratings.count} ratings"
      expect(page).to have_content "#{beer1.name} 12"
      expect(page).to have_content "#{beer2.name} 16"
      expect(page).to have_content "#{beer1.name} 21"
    end

    it "are deleted when user click's the respective delete link on his/her profile" do
      visit user_path(user)

      expect{
        page.all(:link, "delete")[0].click
      }.to change{user.ratings.count}.by(-1)
    end

    it "define the user's favorite style" do
      visit user_path(user)
    
      expect(page).to have_content "Favorite style: #{user.favorite_style}"
    end

    it "define the user's favorite brewery" do
      visit user_path(user)

      expect(page).to have_content "Favorite brewery: #{user.favorite_brewery.name}"
    end
  end

end

def create_test_ratings
    FactoryGirl.create(:rating, score:12, beer:beer1, user:user)
    FactoryGirl.create(:rating, score:16, beer:beer2, user:user)
    FactoryGirl.create(:rating, score:21, beer:beer1, user:user)
end
