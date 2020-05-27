// Version date: May 26
import processing.serial.*;
Serial mySerial;
import processing.net.*;
Client myClient; 
import java.net.MalformedURLException;
import java.net.URL;
import java.security.cert.Certificate;
import java.io.*;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLPeerUnverifiedException;

String port = "/dev/cu.usbmodem14201";
String USER_AGENT = "Chrome/81.0.4044.141";

Table table;
int found_start_char = 0;
int start_char = 126;

void setup() 
{
  //set mySerial to listen on COM port 10 at 115200 baud
  mySerial = new Serial(this, port, 115200);
  int c;
  
  // temp test submitting the form URL
  // submit_form("MJF,1,2,3,4,5");
  
  mySerial.clear(); // get rid of pending input
  mySerial.stop();  // somehow opening, clearing, stopping, and opening again clears the buffer
  mySerial = new Serial(this, port, 115200);
  table = new Table();
  //add a column header "Data" for the collected data
  table.addColumn("Data");
}
   
void draw()
{
  if(mySerial.available() > 0)
  {
    //set the value recieved as a String
    String value;
    Character c = 'X';

    value = "";
    delay(100);
    do {
      // print("next value");
      do {
        delay(10);
        c = mySerial.readChar();
      }
      while (c == -1);  // wait until there is actual input
      if (c != 10) {  // don't put newline in our data
        value = value + c;
      }
    } while (c != 10);  // scan up to linefeed
    
    //check to make sure there is a value
    if(value != null)
    {
      //add a new row  for each value
      print("got: [" + value + "]\n");
      if (value.charAt(0) == start_char)  // got the start character
      {
        print("***Successful buffering\n");
        if (found_start_char == 1)
        {
          print("Communications error, please restart.");
          exit();
        }
        found_start_char = 1;
      }
      if (found_start_char == 1)
      { 
        if (value.charAt(0) == start_char)
        {
          ;
        }
        else
        {
          //place the new row and value under the "Data" column
          TableRow newRow = table.addRow();
          newRow.setString("Data", value);
          // Send the values to the Google spreadsheet
          submit_form(value);
        }
      }
    }
  }
}
 
void keyPressed()
{
  //save as a table in csv format(data/table - data folder name table)
  saveTable(table, "data/table.csv");
  exit();
}

void submit_form(String values)
{
  // Make a silent Google form submission passing the six values provided in the string (whitespace separated)
  // Original from Google:
  // https://docs.google.com/forms/d/e/1FAIpQLSdhCbhXjZFhiuKVI3hdSGxKYw07o00LulcjyHULDEcukQMhXw/viewform?usp=pp_url&entry.542666132=name&entry.851165377=val1&entry.1776648628=val2&entry.1970406796=val3&entry.45221374=val4&entry.339220323=val5
  // Add sillent submit magic:
  // https://docs.google.com/forms/d/e/1FAIpQLSdhCbhXjZFhiuKVI3hdSGxKYw07o00LulcjyHULDEcukQMhXw/formResponse?usp=pp_url&entry.542666132=name&entry.851165377=val1&entry.1776648628=val2&entry.1970406796=val3&entry.45221374=val4&entry.339220323=val5&submit=Submit
  String[] vals = values.split(",", 7);  // expecting 6 values
  //System.out.println("Seventh token is:" + vals[6] + "\n");
  
  String url_start = "https://docs.google.com/forms/d/e/1FAIpQLSfRGrEMlZrtUuvqUzjzTsSFR7BfIlB1N03iTI_er0qUnTwFNw/formResponse?usp=pp_url";
// https://docs.google.com/forms/d/e/1FAIpQLSfRGrEMlZrtUuvqUzjzTsSFR7BfIlB1N03iTI_er0qUnTwFNw/viewform?usp=pp_url&entry.1876202486=1&entry.870043936=2  String entry_0 = "&entry.1876202486=";
  String entry_1 = "&entry.870043936=";
  String entry_2 = "&entry.760049515=";
  String entry_3 = "&entry.864227038=";
  String entry_4 = "&entry.1241692629=";
  String entry_5 = "&entry.1491548388=";
  String url_end = "&submit=Submit";
  String https_url;
  
  HttpsURLConnection con = null;
  URL url;
  
  https_url = url_start + entry_0 + vals[0] + entry_1 + vals[1] + entry_2 + vals[2] + entry_3 + vals[3] + entry_4 + vals[4] + entry_5 + vals[5] + url_end;
  //System.out.println(https_url);
  //https_url = "https://docs.google.com/forms/d/e/1FAIpQLSdhCbhXjZFhiuKVI3hdSGxKYw07o00LulcjyHULDEcukQMhXw/formResponse?usp=pp_url&entry.542666132=1234.5&submit=Submit";
  //https_url = "https://docs.google.com/forms/d/e/1FAIpQLSdhCbhXjZFhiuKVI3hdSGxKYw07o00LulcjyHULDEcukQMhXw/formResponse?usp=pp_url&entry.542666132=Group1Student2&entry.851165377=15.00&entry.1776648628=0.36&entry.1970406796=29916&entry.45221374=374.00&entry.339220323=15708.00&submit=Submit";
  //https_url = "https://docs.google.com/forms/d/e/1FAIpQLSdhCbhXjZFhiuKVI3hdSGxKYw07o00LulcjyHULDEcukQMhXw/formResponse?usp=pp_url&entry.542666132=Group1Student2&entry.851165377=5.00&entry.1776648628=0.03&entry.1970406796=2333&entry.45221374=33.00&entry.339220323=1386.00&submit=Submit";
  //System.out.println(https_url);

  try 
  {
    url = new URL(https_url);
    con = (HttpsURLConnection)url.openConnection();  
    con.setRequestMethod("GET");
    con.setRequestProperty("User-Agent", USER_AGENT);
    int responseCode = con.getResponseCode();
    print("GET Response Code: " + responseCode + "\n");
  } 
  catch (MalformedURLException e)
  {
    e.printStackTrace();
  } 
  catch (IOException e) 
  {
    e.printStackTrace();
  }
   // Code below prints the Google response - useful only for debugging and very verbose
  //if(con!=null)
  //{
  //  try 
  //  {
  //    System.out.println("****** Content of the URL ********");
  //    BufferedReader br =
  //    new BufferedReader(
  //    new InputStreamReader(con.getInputStream()));

  //    String input;

  //    while ((input = br.readLine()) != null)
  //    {
  //      System.out.println(input);
  //    }
  //    br.close();
  //  } 
  //  catch (IOException e) 
  //  {
  //    e.printStackTrace();
  //  }
  //} 
}
      
