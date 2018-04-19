# Beetle
Here is the code for the project Beetle. In this repository, you will find the code for 3 different products. These products are the API, web interface, app and the skill for Alexa

# API
The app and the skill for Alexa get the data from this point. To start the API first install all the node modules npm install after that you can run the code with: npm run dev.

For info about the API, you can look here: https://project.hosted.hro.nl/2017_2018/mlab_insect_t2/2018/03/22/api/

Stuff that needs to be done:

* Secure the API
* Fill database with recipes

# Web interface
This is the skeleton for the interface where you can watch the status of the different crates. At the moment this the data isn't dynamic and has standard data.

# App
The app loads the data from the API and will save it locally. The app is simple at the moment but is easily extendable. The app is coded in swift and uses the Realm platform to save data locally.