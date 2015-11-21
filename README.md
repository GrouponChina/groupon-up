# Groupon UP - Groupon, reinvented and socialized.

![logo](https://avatars3.githubusercontent.com/u/15825374?v=3&s=200)

Feel lonely during the weekend? Seeing an epic Groupon deal but couldn't find anyone to go with you?

Panic no more! Experience Groupon like never before with Groupon UP - now you can buy deals together with friends or even complete strangers by a single tap. Getting to know the people around you, explore local with your old and new friends!

We have been building our platform for the past 7 years and we believe now it is the time for you to experience the real Groupon power.

Life is so good with Groupon, isn't it?

## User stories

### Hamburger menu
- [ ] Dragging anywhere in the view should reveal the menu.
- [ ] The menu should include links to Home page, Profile page, and My orders page.

### Groupon UP instruction page
- [ ] Provide a basic walkthrough of Groupon UP feature
- [ ] Return to the deal page at the end of the walkthrough

### Groupon UP creation page
- [ ] A brief order information should be displayed on this page.
- [ ] User should be able to enter some descriptions for the Groupon UP campaign.
- [ ] User should be able to specify the date time and location of the Groupon UP campaign.
- [ ] There should be a Groupon UP button to create the campaign and send out notification to the other users.

### Push notification
- [ ] User should receive a push notification if there's a matched Groupon UP campaign being created.
- [ ] Original requester should be able to see a push notification whenever someone joined the Groupon UP campaign.
- [ ] Click on the Groupon campaign should bring up the Groupon UP campaign details page.

### Groupon UP campaign details page
- [ ] Display the details of the Groupon UP (e.g. who is also up for this Groupon, when everyone should show up at the Groupon location, etc).
- [ ] User should be able to accept / reject the Groupon UP request.
- [ ] User should be able to edit the response once he accepted / rejected the Groupon UP request.
- [ ] Click on the accept button should bring up the checkout page.
Optional:
- [ ] User should be able to chat with the user in this group by tapping a Chat button.

### User Sessions page
- [ ] User should be able to sign in with (fake) Groupon account. (via Parse)
Optional:
- [ ] User should be able to register (fake) Groupon account. (via Parse)

### My Orders page
- [ ] We will implement user order via Parse.
- [ ] User should be able to see a list of orders in My Orders page.
- [ ] Click an order should bring up the order details page.

### Order Details page
- [ ] User should be able to see order details (e.g. title, image, purchase date, amount paid etc).
- [ ] User should be able to see brief Groupon UP status (e.g. who is also up for this Groupon, when everyone should show up at the Groupon location, etc).
- [ ] Tap on a user thumbnail in Groupon UP will bring up user profile.
Optional:
- [ ] User should be able to send Group messages to the Groupon UP group.

### User Profile page
- [ ] Contains the user header view.
- [ ] Contains a section with the users basic stats: name, gender, profile image, location / division.

### Home page (Optional)
- [ ] User should be able to browse Groupon deals.
- [ ] User should be able to perform search on the page.

### Deal page (Optional)
- [ ] User should be able to view the details of Groupon deals.
- [ ] There should be a buy button on the page
- [ ] There should be a Groupon UP button on the page, click on the button will bring Groupon UP instruction page

### Checkout page (Optional)
- [ ] User should be able to enter billing information and purchase the deal.
- [ ] After checkout, user should be redirected to the confirmation page

### Confirmation page (Optional)
- [ ] User should be able to see confirmation message about the deal purchase
- [ ] User should have the option of creating a Groupon UP campaign (maybe we need to create a separate view for this?)

### Optional:
- [ ] User should be able to see a list of the last 5 or 10 Groupon UP request (use local storage maybe?)
- [ ] Instant chat for users in the same Groupon UP group.
- [ ] Google Map to show user locations in the same Groupon UP group.
- [ ] When creating Groupon UP, user can choose to notify people nearby or people who has viewed the same deal.


### Video Walkthrough
![Video Walkthrough](https://github.com/buy/groupon-up/blob/master/Demo/groupon_up_demo.gif?raw=true)

GIF created with [LiceCap](http://www.cockos.com/licecap/)


### License
    Copyright 2015 Chang Liu, Zhang Ping, Robert Xue

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

