( ( factory ) ->
    if typeof exports is "object"
        module.exports = factory(
            require "underscore"
            require "moment"
        )
    else if typeof define is "function" and define.amd
        define( [
            "underscore"
            "moment"
        ], factory )

)( ( _, moment ) ->
    objectToXmlString = ( inputObject, dateFormat = "YYYY-MM-DDTHH:mm:ssZ" ) ->
        xml = ""

        for key, value of inputObject
            xml += nodeToXmlString( key, value, dateFormat )

        return xml

    nodeToXmlString = ( nodeName, nodeValue, dateFormat = "YYYY-MM-DDTHH:mm:ssZ" ) ->
        xml = ""

        # Determine the node type
        #
        if _.isArray( nodeValue )
            # Tag collection
            #
            for node in nodeValue
                xml += nodeToXmlString( nodeName, node, dateFormat )

        else if _.isObject( nodeValue )
            # Build attributes
            #
            nodeAttributes = buildAttributes( nodeValue.$a, dateFormat )

            # Check if a name space is set
            #
            if _.isString( nodeValue.$ns )
                nodeName = "#{nodeValue.$ns}:#{nodeName}"

            if nodeValue.$t? and nodeValue.$t isnt ""
                xml = "<#{nodeName}#{nodeAttributes}>" + escapeXML( formatValue( nodeValue.$t, dateFormat ) ) + "</#{nodeName}>"

            else
                # Tag containing possible child elements
                #
                nodeChildren = ""
                for key, value of nodeValue
                    if key isnt "$a" and key isnt "$t" and key isnt "$ns"
                        nodeChildren += nodeToXmlString( key, value, dateFormat )

                if nodeChildren isnt ""
                    xml = "<#{nodeName}#{nodeAttributes}>#{nodeChildren}</#{nodeName}>"
                else
                    xml = "<#{nodeName}#{nodeAttributes} />"

        else
            formattedValue = formatValue( nodeValue, dateFormat )

            if formattedValue isnt ""
                # Text/Numeric/Boolean/Date node
                #
                xml = "<#{nodeName}>" + escapeXML( formattedValue ) + "</#{nodeName}>"
            else
                # Empty tag or unusable nodeValue
                #
                xml = "<#{nodeName} />"

        return xml

    buildAttributes = ( attributes, dateFormat = "YYYY-MM-DDTHH:mm:ssZ" ) ->
        # Build attributes
        #
        nodeAttributes = ""
        if _.isObject( attributes )
            for attributeName, attributeValue of attributes
                if attributeValue?
                    # Add optional name space to attribute name
                    #
                    if _.isString( attributeValue.$ns )
                        attributeName = "#{attributeValue.$ns}:#{attributeName}"

                    # Set the attribute value
                    #
                    if attributeValue.$t?
                        # Strict mode puts attribute value inside a $t
                        #
                        nodeAttributes += " #{attributeName}=\"" + formatValue( attributeValue.$t, dateFormat ) + "\""
                    else
                        # Smart mode put the value directly into the object key
                        #
                        nodeAttributes += " #{attributeName}=\"" + formatValue( attributeValue, dateFormat ) + "\""

        return nodeAttributes

    formatValue = ( inputValue, dateFormat = "YYYY-MM-DDTHH:mm:ssZ" ) ->
        nodeValue = ""
        if _.isString( inputValue ) or _.isNumber( inputValue )
            # Text/numeric attribute
            #
            nodeValue = inputValue

        else if _.isDate( inputValue )
            # Date attribute
            #
            dateTime = moment( inputValue )
            nodeValue = dateTime.format( dateFormat )

        else if _.isBoolean( inputValue )
            # Boolean attribute
            #
            if true is inputValue
                nodeValue = "true"
            else
                nodeValue = "false"

        return nodeValue

    # The list of character to escape in the XML
    #
    xmlCharactersMap =
        "<": "&lt;"
        ">": "&gt;"
        "&": "&amp;"
        '"': "&quot;"
        "'": "&apos;"

    escapeXML = ( value ) ->
        if _.isString( value )
            value.replace( /[<>&"']/g, ( char ) ->
                xmlCharactersMap[ char ]
            )
        else
            return value

    ###*
    #   The XML deobjectifier is used to turn a JavaScript XML representation
    #   back into an XML string. The object representation is assumed to be
    #   made using madlib-xml-objectifier but it will accept any JavaScript
    #   object and tries to convert it. Emphasis on tries.
    #
    #   @author     mdoeswijk
    #   @module     deobjectifier
    #   @version    0.1
    ###
    deobjectifier =

        ###*
        #   Turns the provided object into an XML string.
        #   Momentjs is used for date parsing and formatting.
        #
        #   @function objectToXmlString
        #   @param {Object}     inputObject     The object that is to be converted
        #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
        #
        #   @return {String}    The object rendered as an XML string
        #
        ###
        objectToXmlString:      objectToXmlString

        ###*
        #   Turns the provided object attribute into an XML string.
        #   Momentjs is used for date parsing and formatting.
        #
        #   @function nodeToXmlString
        #   @param {String}     nodeName        The name of the object attribute
        #   @param {Moxed}      nodeValue       The value of the object attribute
        #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
        #
        #   @return {String}    The attribute rendered as an XML string
        #
        ###
        nodeToXmlString:        nodeToXmlString

        ###*
        #   Format the provided object value depending on its type.
        #   Momentjs is used for date parsing and formatting.
        #
        #   @function formatValue
        #   @param {Object}     inputObject     The object that is to be converted
        #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
        #
        #   @return {String}    The object rendered as an XML string
        #
        ###
        formatValue:            formatValue

        ###*
        #   Build the attributes and their values for inclusion in an XML tag
        #   Momentjs is used for date parsing and formatting.
        #   The attribute structure depends on the madlib-xml-objectifier mode that was used.
        #
        #   @function buildAttributes
        #   @param {Array}      atttributes     An array of objects containing attributes. Depending on the objectifier mode used the format of an attribute value can differ
        #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
        #
        #   @return {String}    The attributes rendered as an XML string
        #
        ###
        buildAttributes:        buildAttributes
)