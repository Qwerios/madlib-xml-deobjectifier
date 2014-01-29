# chai          = require "chai"
# deobjectifier = require "../lib/index.js"
# _             = require "underscore"
# moment        = require "moment"

# testDate = moment( "2014-01-29" )

# xmlObject =
#     "AuthenticateUser":
#         "$t": ""
#         "$ns": "exampleNS"
#         "request": [
#             "$t": ""
#             "$a":
#                 "example":
#                     "$t": "yes"
#                 "created":
#                     "$t": testDate.toDate()
#                     "$ns": "exampleNS"
#             "username": [
#                 "$t": "foo"
#             ]
#             "password": [
#                 "$t": "bar"
#             ]
#             "created": [
#                 "$ns": "exampleNS"
#                 "$t": testDate.toDate()
#             ]
#             "ControlParameters": [
#                 "$t": ""
#                 "GetContracts": [
#                     "$t": true
#                 ]
#             ]
#         ]

# # Convert the object to an XML string
# #
# xmlString = deobjectifier.objectToXmlString( xmlObject )
# # console.log( "XML strict string", xmlString )

# describe( "Deobjectifier [strict]", () ->
#     describe( "#objectToXmlString()", () ->

#         it( "Should return a string", () ->
#             chai.expect( _.isString( xmlString ) ).to.eql( true )
#         )

#         it( "Attribute should be found", () ->
#             chai.expect( xmlString.indexOf( "example=\"yes\"" ) ).to.not.eql( -1 )
#         )

#         it( "Tag should be found", () ->
#             chai.expect( xmlString.indexOf( "<GetContracts>true</GetContracts>" ) ).to.not.eql( -1 )
#         )

#         it( "Tag should have namespace", () ->
#             chai.expect( xmlString.indexOf( "<exampleNS:AuthenticateUser>" ) ).to.not.eql( -1 )
#         )

#         it( "Attribute should have namespace", () ->
#             chai.expect( xmlString.indexOf( "exampleNS:created=\"" ) ).to.not.eql( -1 )
#         )
#     )
# )