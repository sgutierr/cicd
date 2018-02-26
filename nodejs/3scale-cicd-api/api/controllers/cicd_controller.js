'use strict';
/*
 'use strict' is not required but helpful for turning syntactical errors into true errors in the program flow
 https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode
*/

/* 
use "child process" module of nodejs to execute any shell commands or scripts with in nodejs.
*/

const exec = require('child_process').exec;
/*
 Modules make it possible to import JavaScript files into your application.  Modules are imported
 using 'require' statements that give you a reference to the module.

  It is a good idea to list the modules that your application depends on in the package.json in the project root
 */
var util = require('util');

/*
 Once you 'require' a module you can reference the things that it exports.  These are defined in module.exports.

 For a controller in a127 (which this is) you should export the functions referenced in your Swagger document by name.

 Either:
  - The HTTP Verb of the corresponding operation (get, put, post, delete, etc)
  - Or the operationId associated with the operation in your Swagger document

  In the starter/skeleton project the 'get' operation on the '/hello' path has an operationId named 'hello'.  Here,
  we specify that in the exports of this module that 'hello' maps to the function named 'hello'
 */
module.exports = {
  configconnection: configconnection,
  createservice: createservice,
  importservicedemo: importservicedemo

};

/*
  Function for running "3scale-cli config" :

  Param 1: a handle to the request object
  Param 2: a handle to the response object
 */
function configconnection(req, res) {
  // variables defined in the Swagger document can be referenced using req.swagger.params.{parameter_name}
  var subdomain = req.swagger.params.subdomain || 'stranger';
  var access_token = req.swagger.params.access_token || 'stranger';
  var wildcard_domain = req.swagger.params.wildcard_domain || 'stranger';
  var yourscript = exec('sh /cicd/scripts/create_credentials.sh', {env: {'SUBDOMAIN': subdomain},env: {'ACCESS_TOKEN': access_token},env: {'WILDCARD_DOMAIN': wildcard_domain}},
  (error, stdout, stderr) => {
      console.log(`${stdout}`);
      console.log(`${stderr}`);
      if (error !== null) {
          // this sends back a JSON response which is a single string
          res.json(`exec error: ${error}`);
          console.log(`exec error: ${error}`);
      }
      else {
        res.json('${stdout}');
      }
  });

}

/*
  Function for creating a new 3scale service, it should take two parameters:

  Param 1: a handle to the request object
  Param 2: a handle to the response object
 */
function createservice(req, res) {
    // variables defined in the Swagger document can be referenced using req.swagger.params.{parameter_name}
    var name = req.swagger.params.name || 'test_service';
    var yourscript = exec('sh /cicd/scripts/create_service.sh', {env: {'SERVICE_NAME': name}},
    (error, stdout, stderr) => {
        console.log(`${stdout}`);
        console.log(`${stderr}`);
        if (error !== null) {
            // this sends back a JSON response which is a single string
            res.json(`exec error: ${error}`);
            console.log(`exec error: ${error}`);
        }
        else {
          res.json('${stdout}');
        }
    });
  
  }


/*
  Function for importing a 3scale demo service, it should take two parameters:

  Param 1: a handle to the request object
  Param 2: a handle to the response object
 */
function importservicedemo(req, res) {
    // variables defined in the Swagger document can be referenced using req.swagger.params.{parameter_name}
    var name = req.swagger.params.name || 'test_service';
    var access_token = req.swagger.params.access_token || 'stranger';
    var apim = req.swagger.params.apim || 'stranger';  
    var yourscript = exec('sh /cicd/scripts/import_service.sh', {env: {'SERVICE_NAME': name},env: {'ACCESS_TOKEN': access_token},env: {'APIM': apim}},
    (error, stdout, stderr) => {
        console.log(`${stdout}`);
        console.log(`${stderr}`);
        if (error !== null) {
            // this sends back a JSON response which is a single string
            res.json(`exec error: ${error}`);
            console.log(`exec error: ${error}`);
        }
        else {
          res.json('${stdout}');
        }
    });
  
  }
/*
  Function for importing a 3scale demo service, it should take two parameters:

  Param 1: a handle to the request object
  Param 2: a handle to the response object
 */
function testingservice(req, res) {
    // variables defined in the Swagger document can be referenced using req.swagger.params.{parameter_name}
    var name = req.swagger.params.name || 'test_service';
    var yourscript = exec('sh /cicd/scripts/test_service.sh', {env: {'SERVICE_NAME': name}},
    (error, stdout, stderr) => {
        console.log(`${stdout}`);
        console.log(`${stderr}`);
        if (error !== null) {
            // this sends back a JSON response which is a single string
            res.json(`exec error: ${error}`);
            console.log(`exec error: ${error}`);
        }
        else {
          res.json('${stdout}');
        }
    });
  
  }



  
