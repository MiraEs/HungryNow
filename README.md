# HungryNow Case Study
Meal Plan App using the Free Meal API

# Feature Specs

## Story: User Requests list of Dessert meals

### Narrative #1
```
As a hungry user
I want the app to automatically load a list of meals
I want the app to load a list dessert meals
```

#### Scenarios (Acceptance Criteria)
```
Given the user can connect to the internet
  When the user requests to see meals
  Then the app should display only dessert meals
    And the app should display these meals alphabetically
```

**

### Narrative #2 (optional cache scenario)
```
As an offline user
I want the app to show the latest saved version of my dessert meal feed
So I can always view meals even with no connectivity
```

#### Scenarios (Acceptance Criteria)

```
Given the user doesn't have internet
    And there's a cached version of dessert meal feed
    // Do we need cache time limit here?
  When the user requests to see the desert meal feed
  Then the app should display the latest dessert meal feed

Given the user doesn't have internet
    And there's a cached version of dessert meal feed
    // Do we need cache time limit here?
  When the user requests to see the dessert meal feed
  Then the app should display an error message

Given the user doesn't have internet
    And the cache is empty
  When the user requests to see the dessert meal feed
  Then the app should display an error message
```

#Use Cases

## Load Meal Feed from Remote Use Case (with connectivity)
### Data:
* URL
  
### Primary course (happy path):
  1. Execute "Load Meal Feed" function with above data.
  2. System downloads data from URL.
  3. System validates downloaded data
  4. System creates meal feed object of desserts from valid data
  6. System delivers meal feed.

### Invalid data - error course:
  1. System delivers invalid data error.
  2. System delivers null values.

 ### No connectivity - error course:
   1. System delivers connectivity error.

------------

## Load Meal Feed from Cache Use Case (no connectivity)

### Primary course (happy path):
  1. Execute "Load Meal Feed" function with above data.
  2. System retrieves feed data from cache.
  3. System creates meal feed of specifically desserts from cached data.
  4. System delivers meal feed

### Retrieval error course:
  1. System delivers error.

### Empty cache course:
  1. System delivers no feed images.
  
