Dream Destinations - README 
===

# Locations

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description
This is a location detector app, which allow user to upload pictures of various locations and have those locations be marked on a built in map. The app will take into account the uploaded pictures. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Utility
- **Mobile:** This app would be primarily built for mobile but can be just as viable on a computer.
- **Story:** The user will be able to upload a picture of a famous landmark, retreive the name, and display its location on a map.
- **Market:** This app could be used often or unoften depending on user's need to.
- **Habit:** The user would use this anytime they want to plan a trip to one of their saved landmark locations. 
- **Scope:** This app would use the uploaded pictures to detect location of landmarks using visio API.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] A styled launch screen is visible when opening the app
- [x] User can upload picture of a landmark
- [x] Add PodFile and AlmaofireImage
- [ ] Uploaded images are saved through Parse Server
- [ ] User can see a table of uploaded landmarks with landmark image and location
- [ ] Landmarks are marked on the map and is viewable on the maps tab





**Optional Nice-to-have Stories**

- [ ] Filter out landmarks based on country
- [ ] Remove a saved landmark from the list


### 2. Screen Archetypes


* Map Screen
   * Google Vision API

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map View Finder
* Table View Finder

**Flow Navigation** (Screen to Screen)
* Table View Finder
  - Goes to specific landmark location if an user taps on one from the list.



## Wireframes
![](https://i.imgur.com/0bJFl65.jpg)


### [BONUS] Digital Wireframes & Mockups
![](https://i.imgur.com/JAdLm1q.png)


### [BONUS] Interactive Prototype
![](https://media2.giphy.com/media/9l0G8emRmY8jsqDaXc/giphy.gif?cid=790b7611f4bae000044c970ad901768d862a8c076693576f&rid=giphy.gif&ct=g)


**Schema**

---
**Models**

Create/POST


| Properties | Type     | Description |
| -------- | -------- | ----------- |
| Landmark Image |  File  | An image of the landmark the user wants to visit       |


Read/GET


| Properties | Type     | Description |
| -------- | -------- | ----------- |
| Landmark Image | File  | The saved image of the landmark uploaded     |
| Location | String   | The address of the famous landmark      |


    

**Networking**

List of network requests by screen

* Display Screen
  (Read/Get) Query all landmark points into a table view
```
let query = PFQuery(className:"Post")
# query.whereKey("user", equalTo: currentUser)
query.order(byDescending: "location")
query.findObjectsInBackground { 
(posts: [PFObject]?, error: Error?) in
   if let error = error { 
      print(error.localizedDescription)
   } 
   else if let landmark = famous_landmark {
      print("Successfully retrieved \(famous_landmark.count)famous_landmark.")
      // TODO: Do something with famous landmarks...
    }
}
```

* Map Screen
  (Read/Get) Display all saved landmarks with a red point indicating where tha landmark is on the map
 

* Upload 
  (post an image of a landmark)



* Build Progress 11/20/2021


![](https://i.imgur.com/s1Oik2u.gif)



