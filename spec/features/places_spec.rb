require 'spec_helper'

describe "Places" do

  before :each do
    BeermappingApi.stub(:places_in).with("kumpula").and_return(
        [ Place.new(:name => "Oljenkorsi") ]
    )
    BeermappingApi.stub(:places_in).with("kallio").and_return(
        [ Place.new(:name => "Pub Heinähattu"),
          Place.new(:name => "Las Vegas") ]
    )
    BeermappingApi.stub(:places_in).with("asdf").and_return(
        []
    )
  end

  it "if one is returned by the API, it is shown at the page" do
    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, all of them are shown on the page" do
    visit places_path
    fill_in('city', with: 'kallio')
    click_button "Search"

    expect(page).to have_content "Pub Heinähattu"
    expect(page).to have_content "Las Vegas"
  end

  it "if none are returned by the API, appropiate notice is displayed" do
    visit places_path
    fill_in('city', with: 'asdf')
    click_button "Search"

    expect(page).to have_content "No locations in"
  end
end
