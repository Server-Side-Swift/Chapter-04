//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}

// dataStore is our "Data Storage" construct as we are not using a database for this example
var dataStore:[String: Any] = [
	"1": [
		"id": 1,
		"firstname": "Joe",
		"lastname": "Brown",
		"address": [
			"address1": "1 Infinite Loop",
			"address2": "",
			"city": "Cupertino",
			"state": "California"
		],
		"phone": "555-123-4567",
		"age": 23
	],
	"2": [
		"id": 2,
		"firstname": "Jane",
		"lastname": "Smith",
		"address": [
			"address1": "1601 14th Street West ",
			"address2": "",
			"city": "New York",
			"state": "New York"
		],
		"phone": "555-333-4455",
		"age": 29
	],
]



let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
				// People Handlers
				["method":"get", "uri":"/api/v1/people", "handler":PeopleHandlers.list], // List
				["method":"get", "uri":"/api/v1/people/{id}", "handler":PeopleHandlers.read], // Read
				["method":"post", "uri":"/api/v1/people", "handler":PeopleHandlers.create], // Create
				["method":"patch", "uri":"/api/v1/people/{id}", "handler":PeopleHandlers.update], // Update
				["method":"delete", "uri":"/api/v1/people/{id}", "handler":PeopleHandlers.delete], // Delete

				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

