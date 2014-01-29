chai          = require "chai"
deobjectifier = require "../lib/deobjectifier.js"
_             = require "underscore"
moment        = require "moment"

testDate = moment( "2014-01-29" )

xmlObject =
    "AuthenticateUser":
        "$t": ""
        "$ns": "exampleNS"
        "request": [
            "$t": ""
            "$a":
                "example":
                    "$t": "yes"
                "created":
                    "$t": testDate.toDate()
                    "$ns": "exampleNS"
            "username": [
                "$t": "foo"
            ]
            "password": [
                "$t": "bar"
            ]
            "created": [
                "$ns": "exampleNS"
                "$t": testDate.toDate()
            ]
            "ControlParameters": [
                "$t": ""
                "GetContracts": [
                    "$t": true
                ]
            ]
        ]

# Convert the object to an XML string
#
xmlString = deobjectifier.objectToXmlString( xmlObject, "YYYY-MM" )
# console.log( "XML date string", xmlString )

describe( "Deobjectifier [date]", () ->
    describe( "#objectToXmlString()", () ->

        it( "Should return a string", () ->
            chai.expect( _.isString( xmlString ) ).to.eql( true )
        )

        it( "Attribute date should be formatted", () ->
            chai.expect( xmlString.indexOf( "created=\"2014-01\"" ) ).to.not.eql( -1 )
        )

        it( "Tag date should be formatted", () ->
            chai.expect( xmlString.indexOf( "<exampleNS:created>2014-01</exampleNS:created>" ) ).to.not.eql( -1 )
        )
    )
)