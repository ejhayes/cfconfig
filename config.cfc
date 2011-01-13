/*
Copyright (c) 2011 Eric Hayes, http://github.com/ejhayes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
component {
  function init(required string configFile) {
    variables.configFile = arguments.configFile;
    variables.loadSections = ["common", CGI.SERVER_NAME];
    
    return getConfig();
  }
  
  private function getConfig() {
    var config = StructNew();
    var sections = getProfileSections(variables.configFile);
    
    // Load settings applicable to this environment
    for(var i=1; i LTE ArrayLen(variables.loadSections); i++) {
      var currentSection = variables.loadSections[i];
      
      // Verify section exists
      if (StructKeyExists(sections, currentSection)) {
        var keyList = sections[currentSection];
        
        for(var j=1; j LTE ListLen(keyList); j++) {
          var currentKey = ListGetAt(keyList, j);
          var currentKeyValue = GetProfileString(variables.configFile, currentSection, currentKey);
          
          // Append setting (overwrite common settings if a server-specific value exists)
          StructInsert(config, currentKey, currentKeyValue, True);
        }
      }
    }
    return config;
  }
}