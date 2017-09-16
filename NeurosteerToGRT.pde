import oscP5.*;
import netP5.*;
import websockets.*;


final String ServerURL = "api.neurosteer.com";
final String ServerPort = "8081";
final String DeviceID = "00a3b4810520";
//final String connectionPath = "ws://" + ServerURL + ":" + ServerPort + "/v1/features/" + DeviceID + "/pull";

final String connectionPath = "ws://api.neurosteer.com:8081/v1/features/00a3b4810520/pull";

final int pipelineMode = GRT.CLASSIFICATION_MODE;
final int numInputs = 6;
final int numOutputs = 1;

//Set the OSC ports used for the GRT GUI and for Processing
final int guiPort = 5000;
final int processingPort = 5001;


//Create a new GRT instance, this will initialize everything for us and send the setup message to the GRT GUI
GRT grt = new GRT( pipelineMode, numInputs, numOutputs, "127.0.0.1", guiPort, processingPort, true );


WebsocketClient wsc;
int now;

//OscP5 oscP5;

PFont font;

//Set up the Neurosteer parameters


void setup() {
  
  println(connectionPath);

  wsc = new WebsocketClient(this, connectionPath);
  //now=millis();
  size(600,600);
  frameRate(30);
  font = loadFont("SansSerif-48.vlw");
}


//channels 35 to 39 are interesting. cluster. 
//5 outputs
//KNN
//executive channels


//event called when message is received:
void webSocketEvent(String data){
String[] features = new String[numInputs];
features[0] = "c1";
features[1] = "c2";
features[2] = "c3";
features[3] = "e1";
features[4] = "e2";
features[5] = "e3";


/*features[0] = "p0";
features[1] = "p1";
features[2] = "p2";
features[3] = "p3";
features[4] = "p4";
features[5] = "h1";
features[6] = "h2";
features[7] = "activity";
features[8] = "delta";
features[9] = "theta";
features[10] = "c1";
features[11] = "c2";
features[12] = "c3";
features[13] = "ss45";
features[14] = "strs";
features[15] = "alpha";
features[16] = "s0";
features[17] = "beta";
features[18] = "s1";
features[19] = "q0";
features[20] = "s2";*/

float[] values = new float[numInputs];
  
  println(data);
  JSONObject json0 = parseJSONObject(data);
  if (json0 == null) {
    print ("JSON object could not be parsed");
  } else {
    JSONObject json = json0.getJSONObject("features");
    for(int i=0; i< features.length; i++){
      values[i] = json.getFloat(features[i]);
      println(values[i]);
    }
    grt.sendData(values);
  }
  
}