Feature: User Uploads a File

  In order to generate a link for an image
  As a user
  I want to specify 1 or more files and have them uploaded to ImageShack

  Background:
  Given I have configured my API key

  Scenario: Upload a single image
  Given I have an image "lol.jpg"
   When I run ishack with options:
     | items   |
     | lol.jpg |
   Then I should see 1 URL

  Scenario: Upload a multiple image
  Given I have an image "lol.jpg"
    And I have an image "rofl.jpg"
   When I run ishack with options:
     | items            |
     | lol.jpg rofl.jpg |
   Then I should see 2 URLs
