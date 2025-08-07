Original App Design Project
===

# Itinerary Planner

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

[A simple and intuitive iOS travel planning app that helps users organize their trips and activities with a timeline based interface. The app features a modern, card based design with a clean blue accent theme that makes trip planning effortless and visually appealing.]

### App Evaluation

[Evaluation of your app across the following attributes]
- **Category: Travel**
- **Mobile: I want to include location services allowing suggestions to users for places and
    activities to do. To accomplish this, I can incorporate some sort of Google Maps API that
    directly scrapes the searches and includes it into the app. Another feature is using a MAP
    UI that provides a route of where the activities are as well as the distance between each
    activity or place to visit. Also, it'd be great if the trips can be shared among friends
    so that multiple people can edit the activities and see what's planned for the trip ahead.**
- **Story: This app is very straightforward such that anyone who's planning to travel could use. Since it's summer, a lot of my friends and I are traveling and so an app such as this
    would prove to be very convenient.**
- **Market: I believe that the size of potential user base can be pretty big as most people travel and go out during the weekends or for holidays. Though I can definitely see more
    usage during the vacation months as compared to months where school is going on.**
- **Habit: Since this app only has a single purpose, I don't see this app as being addictive.**
- **Scope: I believe that given all the features I want to implement and my lack of knowledge 
    of the Swift language, it'd take much more time than a week to fully furnish and complete
    this app.**

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Create new trips with dates to organize travel plans
* Add activities to trips with specific times and locations to my schedule
* View all activities in chronological order to follow the itinerary easily
* Edit or delete activities to adjust plans when needed
* Delete entire trips to remove old or cancel travel plans
* Data is persist so itineraries aren't lost when app is closed
* Categorize activities by type to quickly identify different parts of the trip

**Optional Nice-to-have Stories**

* See activities on a map so the route and proximity between locations can be easily visualized
* Have location suggestions as user types to allow user to find and add places
* Receive notifications before activities so important events aren't missed
* Share itinerary with others so they can see travel plans
* Track location and get reminders when users are near planned activities
* Add photos to activities so users can capture memories from the trip
* See weather information for users' activities to allow for careful planning
* Export itinerary to other apps to allow for access across platforms
* Collaborate with other users on trip planning

### 2. Screen Archetypes

- Trips List Screen (Home)
* user can view all their created trips
* user can create a new trip
* user can delete existing trips
* user can navigate to trip details

- Create/Edit Trip Screen
* user can enter trip name
* user can set start and end dates
* user can save or cancel trip creation/editing

- Trip Detail Screen
* user can view trip overview (dates, activity count)
* user can see all activities in chronological order
* user can add new activities
* user can edit or delete existing activities

- Create/Edit Activity Screen
* user can enter activity title and location
* user can set activity time
* user can select activity type
* user can add optional duration
* user can save or cancel activity creation/editing

- Map View Screen (Optional)
* user can see activities plotted on a map
* user can view route between activities
* user can get directions to activities

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* My Trips → Trips List Screen
* Map View → Map View Screen (Optional)
* Settings → Settings Screen (Optional)

**Flow Navigation** (Screen to Screen)
- Trips List Screen
* Create Trip Screen (via & button)
* Trip Detail Screen (via trip selection)

- Create Trip Screen
* Trips List Screen (via save/cancel)

- Trip Detail Screen
* Create Activity Screen (via + button)
* Edit Activity Screen (via activity selection)
* Map View Screen (via map button - optional)

- Create/Edit Activity Screen
* Trip Detail Screen (via save/cancel)

- Map View Screen (Optional)
* Trip Detail Screen (via back navigation)
* Navigation app (via directions button)

## Wireframes

<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

