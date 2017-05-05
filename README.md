## TrackMe

A rails app to track different personal status attributes over time.
- Mindfulness
- Physical Activity
- Happiness
- Diet
- Mental Activity
- Social Activity

The initial model is a HealthStatus where each of the above attributes is recorded on a scale of 0 to 10.  


The app:
- displays attribute history over time on a 5 day, 1 month, 3 months and 1 yr range
- allows ajax editing and deleting of previous HealthStatus records


Built with model, controller and integration tests (TDD).  

### ToDo's
***
- update this README with accurate description

#### Goals
- focus name box on Add New Goal click
- add complete_by type goals for "ToDo items"

#### HealthStatus
- fix x axis labels
- better style health_statuses report
- move user into fixtures/factories and clean up tests ??
- add previous statuses
