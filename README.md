# JavaScript-iOS
This project is a test project that invokes `JavaScript` from native `Swift` code. `WKWebKit` is used to invoke `JavaScript`. Initially `JavaScript` is loaded from a web url in `String` form and evaluated using `WKWebView` instance. `Operation` enum represents a single operation which will be created using JS function `startOperation`. 4 different operations are created and 4 different progress UI elements are used to represent each operation. Progress UI elements are custom UIView's (`HorizontalProgressBar` and `CircularProgressBar`). A MessageHandler (`jumbo` here) is added to `WKWebViewConfiguration's` `userContentController` which receives the messages posted on the handler through `WKScriptMessageHandler's` delegate method `didReceive`. Upon receiving a new message, it is identified which operation this message belongs to and that operation's UI progress is updated accordingly using `handleMessage` (inside `VaccineTrialViewController`).

## Unit Tests
There are 4 unit tests added `JavaScriptTests`

## Operations in progress
<img width="412" alt="Screenshot 2020-09-03 at 9 29 50 PM" src="https://user-images.githubusercontent.com/12998613/92148263-f3db3f00-ee39-11ea-9bf5-3e17a103e226.png">


## Operations finished successfully or finished with error
<img width="412" alt="Screenshot 2020-09-03 at 11 05 05 PM" src="https://user-images.githubusercontent.com/12998613/92148273-f50c6c00-ee39-11ea-9bb7-e0949cce701e.png">


## Exception Handling
<img width="412" alt="Screenshot 2020-09-03 at 9 21 34 PM" src="https://user-images.githubusercontent.com/12998613/92148242-ee7df480-ee39-11ea-9f7b-3ad59b723fbc.png">
