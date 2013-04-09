require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      
      describe "test that with 1 micropost the micropost count is correct and singular" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "lorem ipsum")
          sign_in user
          visit root_path
        end
        
        it {page.should have_content("1 micropost")}
      
      
        describe "add more microposts for other tests" do
      
          let(:testmicroposts) {  [ {text: "Dolor sit amet"} ]  }
        
          before do
            testmicroposts.each do |m|
            FactoryGirl.create(:micropost, user: user, content: m[:text])
            end
          #FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          #FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          #sign_in user
          visit root_path
          end
      
          it "should render the user's feed" do
            user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
            end
          end
        
          it "should have x microposts and be plural" do
            #page.should have_content("#{user.microposts.count} microposts")
            page.should have_content("#{1 + testmicroposts.count} microposts")
          end
          
          describe "follower/following counts" do
            let(:other_user) { FactoryGirl.create(:user) }
            before do
            other_user.follow!(user)
            visit root_path
          end

            it { should have_link("0 following", href: following_user_path(user)) }
            it { should have_link("1 followers", href: followers_user_path(user)) }
          end
        end
      end
    end    
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)   { 'Help' }
    let(:page_title){ 'Help' }

    it_should_behave_like "all static pages"

  end

   describe "About page" do
    before { visit about_path }
    let(:heading)   { 'About' }
    let(:page_title){ 'About' }

    it_should_behave_like "all static pages"

  end

   describe "Contact page" do
    before { visit contact_path }
    let(:heading)   { 'Contact' }
    let(:page_title){ 'Contact' }

    it_should_behave_like "all static pages"

   end
   
   it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end

end