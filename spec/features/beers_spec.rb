require 'spec_helper'

include OwnTestHelper

describe "Beer" do

  before :each do
    FactoryGirl.create :user
    FactoryGirl.create(:brewery, name:"Test", year: 1991)
  end

  it "gets succesfully submitted if it has a valid name" do
    sign_in username:"Pekka", password:"Foobar1"
    visit new_beer_path
    fill_in('beer_name', with:'Test beer')
    
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)

  end

  it "cannot be submitted if it has an invalid name" do
    sign_in username:"Pekka", password:"Foobar1"
    visit new_beer_path
  
    number_of_beers = Beer.count

    click_button('Create Beer')
    expect(Beer.count).to eq(number_of_beers)
    expect(page).to have_content "Name can't be blank"
  end

end
