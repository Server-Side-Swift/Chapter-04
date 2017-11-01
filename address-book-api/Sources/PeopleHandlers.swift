//
//  PeopleHandlers.swift.swift
//  address-book-api
//
//  Created by Jonathan Guthrie on 2017-10-29.
//

import PerfectLib
import PerfectHTTP

class PeopleHandlers {

	// List handler.
	static func list(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in
			do {
				try response.setBody(json: dataStore)
			} catch {
				_ = try? response.setBody(json: ["error":"\(error)"])
			}
			response.completed()
		}
	}

	// Read handler.
	static func read(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			// set id from URL variable
			let id = request.urlVariables["id"] ?? ""

			// Find a corresponding object in the dataStore
			let obj = dataStore[id]

			// Check to make sure there was a match
			guard obj is [String: Any] else {
				_ = try? response.setBody(json: ["error":"Please specify a valid ID"])
					.completed()
				return
			}

			do {
				try response.setBody(json: obj)
			} catch {
				_ = try? response.setBody(json: ["error":"\(error)"])
			}
			response.completed()
		}
	}

	// Create handler.
	static func create(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			do {
				// Check for errors decoding the JSON, or if it's empty
				guard let body = try request.postBodyString?.jsonDecode() as? [String: Any] else {
					// Set the error message for invalid content
					_ = try? response.setBody(json: ["error":"Invalid content"])
						.completed()
					return
				}
				// set the id
				guard let id = body["id"] as? String else {
					// Set the error message for invalid content
					_ = try? response.setBody(json: ["error":"No ID supplied"])
						.completed()
					return
				}
				// set the object
				let obj = body["obj"] as? [String: Any] ?? [String: Any]()
				// assign to the datastore
				dataStore[id] = obj
				// return a success code
				try response.setBody(json: ["success":"Object Inserted"])
					.completed()
			} catch {
				//
				_ = try? response.setBody(json: ["error":"\(error)"])
					.completed()
			}

		}
	}

	// Update handler.
	static func update(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			do {
				// Check for errors decoding the JSON, or if it's empty
				guard let body = try request.postBodyString?.jsonDecode() as? [String: Any] else {
					// Set the error message for invalid content
					_ = try? response.setBody(json: ["error":"Invalid content"])
						.completed()
					return
				}
				// set the id
				let id = request.urlVariables["id"] ?? ""

				if !(dataStore[id] is [String: Any]) {
					// Set the error message for invalid content
					_ = try? response.setBody(json: ["error":"Invalid ID"])
						.completed()
					return
				}

				// set the object
				let obj = body["obj"] as? [String: Any] ?? [String: Any]()
				// assign to the datastore
				dataStore[id] = obj
				// return a success code
				try response.setBody(json: ["success":"Object Updated"])
					.completed()
			} catch {
				//
				_ = try? response.setBody(json: ["error":"\(error)"])
					.completed()
			}

		}
	}

	// Delete handler.
	static func delete(data: [String:Any]) throws -> RequestHandler {
		return {
			request, response in

			// set id from URL variable
			let id = request.urlVariables["id"] ?? ""

			// Delete a corresponding object in the dataStore
			dataStore.removeValue(forKey: id)

			do {
				try response.setBody(json: ["success":"Object removed"])
			} catch {
				_ = try? response.setBody(json: ["error":"\(error)"])
			}
			response.completed()
		}
	}


}


