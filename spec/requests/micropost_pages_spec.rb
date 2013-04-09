require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
  
  describe "pagination" do

      #if you persist things in the database in a before(:all) block they don't
      #get automatically cleared out of the test database at the end of the example block
      #you can avoid this by using before or before(:each) or clearing out your database
      #using an after(:all) hook
      before(:all) { 50.times { FactoryGirl.create(:micropost, user: user) } }
      after(:all)  { User.delete_all }
      
      before {visit root_path}

      it { should have_selector('div.pagination') }

  end
  
  describe "microposts that aren't from current user shouldn't have a delete link" do
      let(:diffuser) {FactoryGirl.create(:user)}
    
      let!(:diffuserpost) {FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))}

      let!(:currentuserpost) {FactoryGirl.create(:micropost, user: user)}
       
      before {visit root_path}
      
      it {should_not have_link('delete', href: micropost_path(diffuserpost) )}
      
      it {should have_link('delete', href: micropost_path(currentuserpost) )}
      
      
  end

end