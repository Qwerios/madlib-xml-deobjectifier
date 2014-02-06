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
                "empty": ""

            "username": [
                "$t": "yes <mai'm>"
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
xmlString = deobjectifier.objectToXmlString( xmlObject )
# console.log( "XML escaped string", xmlString )

describe( "Deobjectifier [escaping]", () ->
    describe( "#objectToXmlString()", () ->

        it( "Should return a string", () ->
            chai.expect( _.isString( xmlString ) ).to.eql( true )
        )

        it( "Tag value should be escaped", () ->
            chai.expect( xmlString.indexOf( "<username>yes &lt;mai&apos;m&gt;</username>" ) ).to.not.eql( -1 )
        )
    )
)