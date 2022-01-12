# Meals-International



A simple food recipe app displaying food in a table format, with each cell leading to a custom view containing recipe and ingredient information. This app is built using UIKit, Core Data, and Combine.

This app utilizes TheMealDB to pull recipe information from their API using Combine, store it with Core Data, and then store retrieved images in an NSCache. When the app is loaded, information is pulled from Core Data if able, barring that it is fetched from the API. API failures are handling with simple UIAlert messages. Images are loaded onto RAM using an NSCache to conserve space when in background.

State and services are stored in a single class that is composed in the SceneDelegate. This class is shared with view controllers through view models.

The UI is designed using MVVM, with the view model housing services to abstract logic from the view controller code. The view controllers utilize Combine to perform asynchronous UI updates when API calls return with data -- otherwise a loading indicator is shown.

The UI itself is a UITableViewController with each cell leading to a custom DetailView. An API request is made for the information needed on a DetailView when the DetailView is loaded. Currently dark mode is supported on the main view and the appearance of the DetailView is acceptable -- support for the custom view elements is not provided, but the resulting view appearance looks ok. 


## Things to Improve ##

* Currently this project is missing tests.
* Code could be made more DRY by making certain functions more generic.
    * Specifically some of the ImageService code in the "Helper Methods" section.
* Error handling could be refined to deal with specific errors in a way that creates a better user experience, rather than just showing an alert.
* We reload the tableView a number of times equal to the number of categories, which is currently 14.
* The catch blocks for attempting to save the Core Data context ignore errors.
    * Placing fatalError calls into these catch blocks crash the app. Without them the app runs fine. May be this hints at some multithreading issue?
* Fetches could be made asynchronous, however the largest load seems to be during first time startup, so maybe the current implementation is fine?
* The fetchImage method in ImageService may benefit from BatchUpdate or some sort of implementation that performs Core Data reads and write in batches rather than one at a time.
* Attempted implementation of NSFetchedResultsControlled along with decoding straight into Core Data objects. My implementation seemed to be overly complicated and harder to work with.
    * It can be argued that the current implementation is better suited for applications that perform edits to data but don't necessarily save those edits into Core Data. So the current structure doesn't matched the intended function, but is easier to work with -- perhaps due to familiarity/habit.
