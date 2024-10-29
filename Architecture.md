# Architecture

DemoRacing is designed as a Model-View-ViewModel ([MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)) application with an emphasis on Clean Architecture and [SOLID principals](https://en.wikipedia.org/wiki/SOLID).
Modularization is highlighted by the project folder structure

- Models
- Services
- ViewModels
- Views

where dependency inversion is complied by the strict use of uni-directional imports of Models -> Services -> ViewModels -> Views

IMPROVEMENT: Updating the folders to projects or Swift Packages will allow strict enforcement of dependencies by importing only uni-directional dependencies. 

## Architecture Decisions

### API
DemoRacing requires to display 5 upcoming races at all times in any selected race category. The [nextraces](https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10) API fetches the specified number of upcoming races in all categories. To ensure there are at least 5 races in each selected category the response will need to be inspected and repeat API calls made if needed. If these calls are made in close proximity to one another the response is unchanged. i.e no new races are included. Therefore the specified number of  races must be increased with each call using the `count` query string parameter to fetch more races. This can result in both a negative user experience waiting for upcoming races, increased network traffic and server workload. In the following example 4 consecative API calls are required to fetch the upcoming races for a selected category. Similarly a further set of API calls may be required if the user were to change the selected race categories.

| Time | `count` | Races fetched |
|------|---------|---------------|
| now  |   10    |  1            |
| now  |   10    |  1            |
| now  |   20    |  2            |
| now  |   50    |  5            |

Profiling the Neds network requests suggests that [next-races-category-group](https://api.neds.com.au/v2/racing/next-races-category-group) is used as a more fit for purpose API to fetch a specified number of upcoming races for each category. DemoRacing will utilize this API.

### Eviction Policy
Many eviction policies passively check the validity of an item at the time of access. Races that are 1 minute past the advertised start must no longer be presented. This requires that the start time of fetched races be actively monitored. A background timer is used to trigger this check. 

DemoRacing will fetch 10 races per category to provide a responsive user experience where evicted races are seemlessly replaced whilst an API call is initiated in the background to fetch more upcoming races. The API response payload of 10 races per category is sufficiently small to not negatively impact performance whilst the user experience is noticably improved.

### Error Handling
API errors are captured and displayed to the user if less than 5 upcoming races for the selected categories are available. If 5 or more races are available, errors are silent as there is no value displaying them to the user given they might be resolved in subsequent API calls before more race data is required. 

IMPROVEMENT: Determine the error type and selectively display errors that provide value to the user regardless of the available race count. For instance an internet connection not available error may assist the user preemptively resolve the issue before race data is required.
