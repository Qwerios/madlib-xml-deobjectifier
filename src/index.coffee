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
                xml = "<#{nodeName}#{nodeAttributes}>" + formatValue( nodeValue.$t, dateFormat ) + "</#{nodeName}>"

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
                xml = "<#{nodeName}>#{formattedValue}</#{nodeName}>"
            else
                # Empty tag or unusable nodeValue
                #
                xml = "<#{nodeName} />"

        return xml

    buildAttributes = ( attributes, dateFormat ) ->
        # Build attributes
        #
        nodeAttributes = ""
        if _.isObject( attributes )
            for attributeName, attributeValue of attributes

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

    formatValue = ( inputValue, dateFormat ) ->
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

    # Return and expose the deobjectifier methods
    #
    deobjectifier =
        objectToXmlString:      objectToXmlString
        nodeToXmlString:        nodeToXmlString
        formatValue:            formatValue
        buildAttributes:        buildAttributes
)