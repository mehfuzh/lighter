#Lighter - lightweight nodejs blog engine.
     
The blog is built using node and mongo. There is no admin view and exposes AtomPub to create, view and delete posts.


## installation

The quickest way to get started  with _lighter_ is to run the following command once you downloaded the source:

	npm install

This will install the necessary dependencies for running the project. Once done just start the server by executing the following script:

	./bin/devserver

Blog modules are written with coffee script therefore keep coffee with watch command running in a separate terminal or execute the following script:

	./bin/compile 
	
You would also need mongodb. Please refer to the following online document for installing mongo locally:                                      

[Installing MongoDB] (http://docs.mongodb.org/manual/installation/)

Optionally, use the following command to install the MongoDB package into your system:

 brew install mongodb

## Configuration

The project structure is similar to the default express web template. Stylesheets are written with less and project settings are defined in _settings.coffee_ under modules folder.

## Running tests

Tests are written with mocha. It is required that mocha is installed globally:

npm install -g mocha


Once installed, type the following command to run tests.

	mocha

##Further reading

My personal blog is hosted with _lighter_. Please check this post out for further reading:            
[Introducing Lighter Blog Engine](http://www.meonbinary.com/2013/02/introducing-lighter-blog-engine)
                      
