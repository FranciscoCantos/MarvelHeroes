# Marvel Heroes App
<br />
<p align="center">
  <a href="https://github.com/alexanderritik/Best-README-Template">
    <img src="MarvelHeroes/Support/Assets/Assets.xcassets/MarvelLogo.imageset/Marvel_Logo.png" alt="Logo" width="200" height="100">
  </a>
  <p align="center">
    App to list the data of all the characters of the Marvel saga
  </p>
</p>

## Features

- [x] List of marvel characters
- [x] Character detail
- [x] Detail of all appearances of the character


Built using XCode 12.5.1 (Swift 5)

### How to run the example?

1. Clone this repo
2. Open shell window and navigate to project folder
3. Run `pod install`
4. Open `MarvelHeroes.xcworkspace` and run the project on selected device or simulator
5. Open `NetworkConstants.swift` and edit the struct ApiKeys adding your own Marvel API public and private keys
6. Run the app

### How to use?

Once the app is started we can see a Marvel splash screen while the app is initialized. Then it starts to get information from the Marvel API, while downloading(1) the information we can see a loading screen with a gif(2) of Marvel. Once downloaded the information we will be able to see a list of characters presented in a table where their photo and name(3)(4) appears. 
In this list we will be able to search. Firstly the search is done among the characters already downloaded and in parallel we search in the Marvel API. This API will only return information if the name of the character you are looking for coincides exactly with the one in the API. In case of not obtaining any result we will be able to see an animation(5). 

If we click on any of the characters we will access to the detail screen of this character. In this screen we will see the photo of the character in bigger size, its name and description. Next to the name we will be able to see a small icon of information that will take us to the web of Marvel where we will be able to find more detailed information of the character. In addition we will be able to see some icons that act as buttons according to if this character has appearances in series, comics, events... besides the number of appearances.  If we click on these icons we will be able to access to a gallery with all the performances of the type of the clicked icon. 

In this gallery we will be able to see the image, name and description of each one of the appearances. We will be able to scroll horizontally. And if we click on the image we will be able to accede to the web of Marvel where we will be able to find more information on the appearance.

(1)The communications library I use is Alamofire, because it is very versatile and easy to use. Installed using CocoaPods

(2) To create that loading screen with the Marvel gif I used a library called Gifu. Installed using CocoaPods

(3) For the creation of network entities I use the web https://app.quicktype.io/ that from a JSON file automatically generates entities that comply with the Codable protocol. They are a great time saver in spite of the singularities that I have found with the API.

(4) To insert the images I have used the SDWebImage library that allows to show a temporary image while the image to be inserted is being loaded and to avoid empty images. Installed using CocoaPods

(5)The animations that are shown when no results are found have been made with the Lottie library. Installed using CocoaPods

I have chosen for this project a VIPER type architecture that allows me to separate very well the different layers of the application logic. It also allows me to scale the app in case I want to add more functionalities. Personally for me it is the most simple and tidy to use.

