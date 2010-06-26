Feature: User Transloads a URL

  In order to generate a link for an image
  As a user
  I want to specify 1 or more image URLS and have them uploaded to ImageShack

  Background:
  Given I have configured my API key

  Scenario: Transload a single image
   When I run ishack with options:
     | items                        | transload |
     | http://example.com/image.jpg | true      |
   Then I should see 1 URL

  Scenario: Transload a multiple image
   When I run ishack with options:
     | items                                                 | transload |
     | http://example.com/foo.jpg http://example.com/bar.jpg | true      |
   Then I should see 2 URLs

  @wip
  Scenario: Transload images with progress bar
   When I run ishack with options:
     | items                                                 | transload |
     | http://example.com/foo.jpg http://example.com/bar.jpg | true      |
   Then I should see 2 progress bars
