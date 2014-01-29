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
      nodeAttributes = "";
      if (_.isObject(attributes)) {
        for (attributeName in attributes) {
          attributeValue = attributes[attributeName];
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
      return nodeAttributes;
    };
    formatValue = function(inputValue, dateFormat) {
      var dateTime, nodeValue;
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
    return deobjectifier = {
      objectToXmlString: objectToXmlString,
      nodeToXmlString: nodeToXmlString,
      formatValue: formatValue,
      buildAttributes: buildAttributes
    };
  });

}).call(this);
