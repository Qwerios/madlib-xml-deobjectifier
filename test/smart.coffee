# chai          = require "chai"
# deobjectifier = require "../lib/index.js"
# _             = require "underscore"
# moment        = require "moment"

# testDate = moment( "2014-01-29" )

# xmlObject =
#     "AuthenticateUser":
#         "request":
#             "$a":
#                 "example": "yes"
#                 "created": testDate.toDate()
#         "username": "foo"
#         "password": "bar"
#         "created": testDate.toDate()
#         "ControlParameters":
#             "GetContracts": true

# # Convert the object to an XML string
# #
# xmlString = deobjectifier.objectToXmlString( xmlObject )
# # console.log( "XML smart string", xmlString )

# describe( "Deobjectifier [smart]", () ->
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
#     )
# )