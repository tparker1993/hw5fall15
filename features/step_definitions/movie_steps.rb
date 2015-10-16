# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then (/^(?:|I )should see "([^"]*)"$/) do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


#Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|

  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
    all_ratings=["G","PG","PG-13","R","NC-17"]
    all_ratings.each do |r|
        uncheck("ratings_#{r}")
    end
    
    ratings_with_spaces=arg1.gsub(/[,]/,"")
    ratings=ratings_with_spaces.split
    ratings.each do |r|
        check("ratings_#{r}")
    end
   click_button 'Refresh'
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    
    table_rows=0
    expected_movie_row=0
    movies=Movie.all
    
    #Find number of rows
    all("tr").each do |tr|
        table_rows=table_rows+1
    end
    
    #Take out header row
    table_rows=table_rows-1
    
    #Get ratings    
    ratings_with_spaces=arg1.gsub(/[,]/,"")
    ratings=ratings_with_spaces.split
    
    #Go through each rating
    ratings.each do |r|
        
        #Find number of movies with that rating
        movies.each do |m|
            if m.rating == r 
                expected_movie_row=expected_movie_row+1
            end
        end
    end
    
    expected_movie_row.should == table_rows
end

Then /^I should see all of the movies$/ do
    
    table_rows=0
    expected_movie_row=0
    movies=Movie.all
    
    #Find number of rows
    all("tr").each do |tr|
        table_rows=table_rows+1
    end
    
    #Take out header row
    table_rows=table_rows-1
        
    #Find number of movies with that rating
    movies.each do |m|
        expected_movie_row=expected_movie_row+1
    end
    
    expected_movie_row.should == table_rows
end

When /I click "Movie Title"/ do
  click_link "title_header"
end

When /I click "Release Date"/ do
  click_link "title_header"
end

When /I sort the results by (.*)/ do |sort_type|
  sort_id = sort_type.gsub(/\s/, '_')
  click_link "#{sort_id}_header"
end

Then /I should see "(.*)" before "(.*)"/ do |m1, m2|
  tester= (page.body =~ /#{m1}.*#{m2}/m)
  
  tester.should_not == nil
end