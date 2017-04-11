### Questions  
Stuff I'll need to figure out sooner or later, as it occurs to me.

1. How to test that the Report gets the right data for the user?  
- Currently passing JSON object directly in view, so can assert_select and verify contents of script element before any users. Now the test expects getting the report as a specific user. HealthStatuses are in fixtures, users are not.
-- put users in fixtures? (was messy trying to work with the tests - will need to specify hashes and tokens using embedded ruby)
-- switch to factories
-- ditch this test since it's an unknown after updating report to get data asynchronously through ajax?

### Todo
- fix x axis labels
- better style health_statuses report
- move user into fixtures/factories and clean up tests ??
- add previous statuses
