

import PerfectLib

let person:[String: Any] = [
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
]

let json = try? person.jsonEncodedString()
print(json!)

