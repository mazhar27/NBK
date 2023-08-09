Feature: Dashboard Screen

@NoResults
Scenario: View Tableview Data
   Given I navigate to the Dashboard screen
   Then I should see the tableview with loaded data

Scenario: Tap on Tableview Row
    Given TableView is loaded
    Then I tap on a tableview row
    Then I should be redirected to the details screen

Scenario: Open Filter Popup
   Given DashBoard screen is visible
   When I tap on the filter button
   Then I should see the filter popup
