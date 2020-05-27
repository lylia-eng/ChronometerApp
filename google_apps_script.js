function doGet(e) {
    // '1F2q1uA-_N2mmf696VhHk11r0oElrOgM8EMpRY7gIb8s';
     var spreadsheetId = '1Ayu2W1Iff8OzJ7siL8Q69FqmnRFMQUJK55pJTN6aqLU'; 
     
     var group1 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group1');
     var group2 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group2');
     var group3 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group3');
     var group4 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group4');
     var group5 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group5');
     var group6 = SpreadsheetApp
     .openById(spreadsheetId)
     .getSheetByName('Group6');
     
    // getSheetValues(startRow, startColumn, numRows, numColumns)
     var results_group1 = group1.getSheetValues(group1.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     var results_group2 = group2.getSheetValues(group2.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     var results_group3 = group3.getSheetValues(group3.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     var results_group4 = group1.getSheetValues(group4.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     var results_group5 = group2.getSheetValues(group5.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     var results_group6 = group3.getSheetValues(group6.getLastRow(), 1, 1, 7).reduce(function(a, b){return a.concat(b);});
     Logger.log(results_group4);
     Logger.log(results_group5);
     Logger.log(results_group6);
     
     var results = [];
     results.push(results_group1);
     results.push(results_group2);
     results.push(results_group3);
     results.push(results_group4);
     results.push(results_group5);
     results.push(results_group6);
   
     Logger.log(results);
   
    return ContentService.createTextOutput(
     e.parameters.callback + '(' + JSON.stringify(results) + ')'
    ).setMimeType(ContentService.MimeType.JAVASCRIPT);
   }
   