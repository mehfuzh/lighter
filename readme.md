#Lighter - lightweight nodejs blogging engine.

The blog fully implements REST based AtomPub API. There is no traditional admin view to do your post. Getting started with the project is simple.

Once you have forked or downloaded the code. First just need to type the following from shell

	npm install

This will install the necessary dependencies for running the project. Once done, type the following command

	./bin/devserver

This initializes the blog with default settings using the _node-dev_ server. The blog engine is written with coffee script therefore if you want to makes changes to any of the coffee files, please also keep coffee watch script running in a different terminal or tab. The command is:

	./bin/compile 
	
You also need to globally install mocha:

	npm install -g mocha

Typing _mocha_ in your terminal will run the tests. You also need to have mongodb installed and running. You can find more on this topic here:                                      

[Installing MongoDB] (http://docs.mongodb.org/manual/installation/)

The project comes with a heroku Procfile this is for specifying dynos and heroku related settings but not needed for running the project.
                       
TBD