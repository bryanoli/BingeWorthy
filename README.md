# BingeWorthy
Movie/Show Rating App

### Login/Register Form
Users can create their account on the register page and log in using the login form in these forms.
Both login and register logic uses the `_submitForm()` method, triggered when the user presses the "Submit" button on the form.
![loginform](https://github.com/bryanoli/BingeWorthy/assets/66151079/b0cc869c-ec97-436a-a310-35b2b71af9fb)
In the login logic, it would check the current form type is set to `FormType.login`. If it is, it uses the `signInWithEmailAndPassword` method from Firebase Authentication to attempt to sign in the user with the provided email and password.

![register](https://github.com/bryanoli/BingeWorthy/assets/66151079/2255ccae-8019-4bd6-9d3f-e23f96bb87c7)
In the registration logic, if the form type is not login, it assumes it's a registration form. It uses the `createUserWithEmailAndPassword` method to create a new user account with the provided email and password. After successfully creating the user, it extracts the UID (User ID) from the `userCredential` and uses the `dataBaseService` to save additional user details (email, first name, last name, username) to the database.

Finally, it navigates to the login page using `navigator.pushReplacementNamed('/login')`. The use of `pushReplacementNamed` replaces the current screen with the new screen, removing the registration form from the navigation stack.


### Dashboard
![homescreen](https://github.com/bryanoli/BingeWorthy/assets/66151079/1607d69b-9257-4bd0-b313-4ae9613d83b5)
The Dashboard screen fetches data for trending movies, binge-worthy movies, and new releases from the TMDB API. It also retrieves user data from the database. The UI is structured using a `CustomScrollView` with a `SliverAppBar` for the app bar and a `SliverList` containing different carousels for movie categories. The `FutureBuilder` is used to load and display movie data asynchronously, and the user can sign out through the `signOut` function.

![menu](https://github.com/bryanoli/BingeWorthy/assets/66151079/3821e273-5534-4bd2-9e8d-e97458e9b3de)



### Search
![searchbar](https://github.com/bryanoli/BingeWorthy/assets/66151079/e311033f-e66b-42f0-bf41-0b05fe3f3bc2)
The `CustomSearchBar` widget integrates a search feature using the `search_page` package. It fetches movie suggestions based on the search text, displays them with images and titles, and provides a way to view detailed information about a selected movie using a pop-up. Additionally, it handles error cases and displays relevant messages.

### Bingelist
![Bingelist](https://github.com/bryanoli/BingeWorthy/assets/66151079/a80af5d0-3bbd-4dac-bb2a-ef4b50002807)
The BingeList screen allows users to manage and reorder their list of favorite movies. It fetches and displays movie data using the Api class, and users can interact with the UI to reorder, clear, and update their favorite movies. The screen is integrated with Firebase Authentication and a custom database service.
