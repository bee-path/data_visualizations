// OpenStreetMap exporta

float mapGeoLeft = 2.18124;
float mapGeoRight = 2.19426;
float mapGeoTop = 41.39172;
float mapGeoBottom = 41.38417;

ArrayList points;
ArrayList pointsLast;
ArrayList nodes;
ArrayList paths;

float mapScreenWidth = 2070;
float mapScreenHeight = 1521;

ArrayList getPoints() { return points; }

PImage imgMap;

int timestamp_start;
int timestamp_end;
int timestamp_current;
void setup() {
  	size(1920,1080);
  	points = new ArrayList();
    nodes = new ArrayList();
	imgMap = loadImage("map4.jpg");
	timestamp_current = timestamp_start;
}

void draw() {
    timestamp_current +=1;
	if(timestamp_current >timestamp_end) timestamp_current = timestamp_end;

	pushMatrix();
	translate(-50,-150);
	//scale(1.0);
  	background(30,30,30);
  	image(imgMap, 0, 0);
	
	for(int p=0, end=nodes.size(); p<end; p++) {
    	Node n = (Node) nodes.get(p);
		if(n.timestamp_start> timestamp_current) break;
		n.draw();
	}
	
  	for(int p=0, end=points.size(); p<end; p++) {
    	Point pt = (Point) points.get(p);
		if(pt.timestamp> timestamp_current) break;
		pt.draw();
	}
	
	popMatrix();
}

void setToOldPoints(){
	for(int p=0, end=points.size(); p<end; p++) {
    	Point pt = (Point) points.get(p);
		pt.setToOld();
	}
}

void newPoints(){
	points.clear();
}

void setStartTimestamp(int timestamp){
	timestamp_start = timestamp;
}

void setEndTimestamp(int timestamp){
	timestamp_end = timestamp;
}

Point addGeoPoint(String id,float lat, float lon, int timestamp) {
	PVector geo = new PVector();
	geo.x = lat;
	geo.y = lon;
	PVector pixPos = geoToPixel(geo);
	Point pt = new Point(id,(int)pixPos.x,(int)pixPos.y, timestamp);
	
	// Found node
	for (int p = points.size()-1; p >= 0; p--) {
	//for(int p=0, end=points.size(); p<end; p++) {
    	Point pt2 = (Point) points.get(p);
		if(pt2.id==id){
			Node n = new Node(id, pt.x, pt.y, pt.timestamp, pt2.x, pt2.y, pt2.timestamp );
			nodes.add(n);
			break;
		}
	}
	points.add(pt);
    return pt;
}

Point addPoint(String id,float pixPosX, float pixPosY) {
	PVector geo = new PVector();
	Point pt = new Point(id,(int)pixPosX,(int)pixPosY);
	points.add(pt);
	
	// Found node
	for(int p=0, end=points.size(); p<end; p++) {
    	Point pt2 = (Point) points.get(p);
		if(pt2.id==id){
			Node n = new Node(id, pt.x,pt.y,pt2.x,pt2.y);
			nodes.add(n);
			break;
		}
	}
    return pt;
}

void searchPaths(){
	 
}

class Node {
	int xStart,yStart,xEnd,yEnd;
	int timestamp_start, timestamp_end;
	Node( String id,int xStart, int yStart,int xEnd, int yEnd) { this.id = id; this.xStart=xStart; this.yStart=yStart;this.xEnd=xEnd; this.yEnd=yEnd;this.timestamp_start->timestamp_start;this.timestamp_end->timestamp_end  }
	void draw() {
		stroke(41,220,74);
		line(xStart,yStart,xEnd,yEnd);
	}
}  

class Point {
	int x,y;
	String id;
	int timestamp;
	boolean isOldPoint;
	int node;
	Point(string id, int x, int y, int timestamp) { this.id = id; this.x=x; this.y=y; this.isOldPoint=false;  this.timestamp=timestamp;}
  
	void draw() {
		if(!this.isOldPoint){
    		stroke(220,41,87);
    		fill(220,41,87);
			ellipse(x,y,10,10);
		}else{
			stroke(24,122,244);
    		fill(24,122,224);	
			ellipse(x,y,5,5);
		}
  	}
	
  	void setToOld(){
		this.isOldPoint = true;
  	}	 
	 
}

//http://forum.processing.org/topic/using-a-world-map-in-processing
PVector pixelToGeo(PVector screenLocation)
{
    return new PVector(mapGeoLeft + (mapGeoRight-mapGeoLeft)*(screenLocation.x)/mapScreenWidth,mapGeoTop - (mapGeoTop-mapGeoBottom)*(screenLocation.y)/mapScreenHeight);
}

// Converts geographical coordinates into screen coordinates.
// Useful for drawing geographically referenced items on screen.
PVector geoToPixel(PVector geoLocation)
{
    return new PVector(mapScreenWidth*(geoLocation.x-mapGeoLeft)/(mapGeoRight-mapGeoLeft), mapScreenHeight - mapScreenHeight*(geoLocation.y-mapGeoBottom)/(mapGeoTop-mapGeoBottom));
}

double distance(double lat1, double lon1, double lat2, double lon2, char unit) {
  double theta = lon1 - lon2;
  double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
  dist = Math.acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;
  if (unit == 'K') {
    dist = dist * 1.609344;
  } else if (unit == 'N') {
  	dist = dist * 0.8684;
    }
  return (dist);
}