(function() {
  (function(factory) {
    if (typeof exports === "object") {
      return module.exports = factory(require("underscore"), require("moment"));
    } else if (typeof define === "function" && define.amd) {
      return define(["underscore", "moment"], factory);
    }
  })(function(_, moment) {
    var buildAttributes, deobjectifier, escapeXML, formatValue, nodeToXmlString, objectToXmlString, xmlCharactersMap;
    objectToXmlString = function(inputObject, dateFormat) {
      var key, value, xml;
      if (dateFormat == null) {
        dateFormat = "YYYY-MM-DDTHH:mm:ssZ";
      }
      xml = "";
      for (key in inputObject) {
        value = inputObject[key];
        xml += nodeToXmlString(key, value, dateFormat);
      }
      return xml;
    };
    nodeToXmlString = function(nodeName, nodeValue, dateFormat) {
      var formattedValue, key, node, nodeAttributes, nodeChildren, value, xml, _i, _len;
      if (dateFormat == null) {
        dateFormat = "YYYY-MM-DDTHH:mm:ssZ";
      }
      xml = "";
      if (_.isArray(nodeValue)) {
        for (_i = 0, _len = nodeValue.length; _i < _len; _i++) {
          node = nodeValue[_i];
          xml += nodeToXmlString(nodeName, node, dateFormat);
        }
      } else if (_.isObject(nodeValue)) {
        nodeAttributes = buildAttributes(nodeValue.$a, dateFormat);
        if (_.isString(nodeValue.$ns)) {
          nodeName = "" + nodeValue.$ns + ":" + nodeName;
        }
        if ((nodeValue.$t != null) && nodeValue.$t !== "") {
          xml = ("<" + nodeName + nodeAttributes + ">") + escapeXML(formatValue(nodeValue.$t, dateFormat)) + ("</" + nodeName + ">");
        } else {
          nodeChildren = "";
          for (key in nodeValue) {
            value = nodeValue[key];
            if (key !== "$a" && key !== "$t" && key !== "$ns") {
              nodeChildren += nodeToXmlString(key, value, dateFormat);
            }
          }
          if (nodeChildren !== "") {
            xml = "<" + nodeName + nodeAttributes + ">" + nodeChildren + "</" + nodeName + ">";
          } else {
            xml = "<" + nodeName + nodeAttributes + " />";
          }
        }
      } else {
        formattedValue = formatValue(nodeValue, dateFormat);
        if (formattedValue !== "") {
          xml = ("<" + nodeName + ">") + escapeXML(formattedValue) + ("</" + nodeName + ">");
        } else {
          xml = "<" + nodeName + " />";
        }
      }
      return xml;
    };
    buildAttributes = function(attributes, dateFormat) {
      var attributeName, attributeValue, nodeAttributes;
      if (dateFormat == null) {
        dateFormat = "YYYY-MM-DDTHH:mm:ssZ";
      }
      nodeAttributes = "";
      if (_.isObject(attributes)) {
        for (attributeName in attributes) {
          attributeValue = attributes[attributeName];
          if (attributeValue != null) {
            if (_.isString(attributeValue.$ns)) {
              attributeName = "" + attributeValue.$ns + ":" + attributeName;
            }
            if (attributeValue.$t != null) {
              nodeAttributes += (" " + attributeName + "=\"") + formatValue(attributeValue.$t, dateFormat) + "\"";
            } else {
              nodeAttributes += (" " + attributeName + "=\"") + formatValue(attributeValue, dateFormat) + "\"";
            }
          }
        }
      }
      return nodeAttributes;
    };
    formatValue = function(inputValue, dateFormat) {
      var dateTime, nodeValue;
      if (dateFormat == null) {
        dateFormat = "YYYY-MM-DDTHH:mm:ssZ";
      }
      nodeValue = "";
      if (_.isString(inputValue) || _.isNumber(inputValue)) {
        nodeValue = inputValue;
      } else if (_.isDate(inputValue)) {
        dateTime = moment(inputValue);
        nodeValue = dateTime.format(dateFormat);
      } else if (_.isBoolean(inputValue)) {
        if (true === inputValue) {
          nodeValue = "true";
        } else {
          nodeValue = "false";
        }
      }
      return nodeValue;
    };
    xmlCharactersMap = {
      "<": "&lt;",
      ">": "&gt;",
      "&": "&amp;",
      '"': "&quot;",
      "'": "&apos;"
    };
    escapeXML = function(value) {
      if (_.isString(value)) {
        return value.replace(/[<>&"']/g, function(char) {
          return xmlCharactersMap[char];
        });
      } else {
        return value;
      }
    };
    /**
    #   The XML deobjectifier is used to turn a JavaScript XML representation
    #   back into an XML string. The object representation is assumed to be
    #   made using madlib-xml-objectifier but it will accept any JavaScript
    #   object and tries to convert it. Emphasis on tries.
    #
    #   @author     mdoeswijk
    #   @module     deobjectifier
    #   @version    0.1
    */

    return deobjectifier = {
      /**
      #   Turns the provided object into an XML string.
      #   Momentjs is used for date parsing and formatting.
      #
      #   @function objectToXmlString
      #   @param {Object}     inputObject     The object that is to be converted
      #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
      #
      #   @return {String}    The object rendered as an XML string
      #
      */

      objectToXmlString: objectToXmlString,
      /**
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
      */

      nodeToXmlString: nodeToXmlString,
      /**
      #   Format the provided object value depending on its type.
      #   Momentjs is used for date parsing and formatting.
      #
      #   @function formatValue
      #   @param {Object}     inputObject     The object that is to be converted
      #   @param {String}     [dateFormat]    Optional date formatting for momentjs. Defaults to "YYYY-MM-DDTHH:mm:ssZ"
      #
      #   @return {String}    The object rendered as an XML string
      #
      */

      formatValue: formatValue,
      /**
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
      */

      buildAttributes: buildAttributes
    };
  });

}).call(this);
