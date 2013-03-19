#Lighter - lightweight nodejs blogging engine.
     
The blog is built using node and mongo. There is no admin view and exposes AtomPub to create, view and delete posts.


## installation

The quickest way to get started  with lighter to run the following command once you downloaded the source:

	npm install

This will install the necessary dependencies for running the project. Next start the server:

	./bin/devserver
                      
Blog modules are written with coffee script therefore keep coffee watch command in a separate terminal or execute the following script:

	./bin/compile 
	
Typing _mocha_ in your terminal to run the tests. You would also need mongodb. Please refer to the following online document for installing mongo locally:                                      

[Installing MongoDB] (http://docs.mongodb.org/manual/installation/)


## Configuration

The project structure is similar to the default express web template. Stylesheets are written with less and project settings are defined in _settings.coffee_ under modules folder.


## Running tests

Tests are written with mocha. It is required that mocha is installed globally:

npm install -g mocha
  
Type the following command to run tests.

	mocha

#Further reading:

My personal blog is hosted with lighter. Please check this post out for further reading:            
[Introducing Lighter Blog Engine](http://www.meonbinary.com/2013/02/introducing-lighter-blog-engine)
                      
Regards
Mehfuz