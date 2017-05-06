## TrackMe

A rails app that lets the user set up weekly "Goals" with a name and a frequency (how many times a week to do it). It then tracks goal completion over the week. So I could have weekly goals of:  
- "Exercise (1 hr)" with a frequency of 5
- "Portfolio Work (1 hr)" with a frequency of 8  

(My goals are to exercise for an hour 5 times a week, and work on my porfolio for about 8 hrs a week.)

Each time I complete one of the activities on my list, I click "DID IT", and the app registers the time. It shows my goals, and how close each is to being complete for the current week.

***
This feature is next up to be overhauled - namely the ability to define the user's own attributes, assign a color for visualtization and a rethink of the whole graphing system.

Currently it also tracks different personal status attributes and over time.
- Mindfulness
- Physical Activity
- Happiness
- Diet
- Mental Activity
- Social Activity

Where each attributes is recorded on a scale of 0 to 10 for that moment in time. The app:
- displays attribute history over time on a 5 day, 1 month, 3 months and 1 yr range
- allows ajax editing and deleting of previous HealthStatus records


Built with model, controller and integration tests (TDD).  

***
### ToDo's

#### Goals
- focus name box on Add New Goal click
- Goal Activities should be returned by performed_at DESC
- add complete_by type goals for "ToDo items"

#### HealthStatus
- allow user to define own attributes
- fix x axis labels
- better style health_statuses report
- move user into fixtures/factories and clean up tests ??
- add previous statuses
