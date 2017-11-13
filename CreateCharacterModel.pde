String inputCharacter = "";
//PGraphics text;
color textColor;
color colorOnMouse;

color[][] pixels2;

ArrayList<Pixel> borderPixels;

int oldDirection = -1;

String pressedKey = "m";

HashMap<Integer, Pixel> directionMap = new HashMap<Integer, Pixel>() {
  {
    put(0, new Pixel(-1, 1));
    put(1, new Pixel(0, 1));
    put(2, new Pixel(1, 1));
    put(3, new Pixel(1, 0));
    put(4, new Pixel(1, -1));
    put(5, new Pixel(0, -1));
    put(6, new Pixel(-1, -1));
    put(7, new Pixel(-1, 0));
    put(8, new Pixel(-1, 1));
    put(9, new Pixel(0, 1));
    put(10, new Pixel(1, 1));
    put(11, new Pixel(1, 0));
  }
};

void setup() {
  size(300, 300);
  borderPixels = new ArrayList<Pixel>();

  fill(0, 100, 0);
  background(255);
  textAlign(CENTER);
  textSize(250);
  text(pressedKey, width/2, height/2 + 90);

  loadPixels();

  pixels2 = pixels1To2(pixels, width, height);


beginingPixel: 
  for (int i=0; i<pixels2.length; i++) {
    for (int j=0; j<pixels2[i].length; j++) {
      if (pixels2[i][j]!=-1) {
        borderPixels.add(new Pixel(i, j));
        break beginingPixel;
      }
    }
  }

  int count = 0;
searchOutlines:
  while (true) {
    Pixel lastPixel = borderPixels.get( borderPixels.size()-1 );
    int startDirection = (oldDirection==-1) ? 0 : (oldDirection+6)%8;
    for (int i=startDirection; i<startDirection+5; i++) {
      int searchX = lastPixel.x + directionMap.get(i).x;
      int searchY = lastPixel.y + directionMap.get(i).y;
      if (pixels2[searchX][searchY] != -1) {
        if (searchX==borderPixels.get(0).x && searchY==borderPixels.get(0).y) {
          break searchOutlines;
        }
        borderPixels.add(new Pixel(searchX, searchY));
        print(true, borderPixels.size());
        count++;
        oldDirection = i%8;
        break;
      }
    }
  }

  background(255);

  noFill();
  beginShape();
  {
    for (int i=0; i<borderPixels.size()-1; i++) {
      //fill(0);
      //point(borderPixels.get(i).x, borderPixels.get(i).y);
      vertex(borderPixels.get(i).x, borderPixels.get(i).y);
    }
  }
  endShape(CLOSE);


  PrintWriter output = createWriter("borderPixels.txt");
  for (int i=0; i<borderPixels.size()-1; i++) {
    output.println(borderPixels.get(i).x +","+borderPixels.get(i).y);
  }
  output.close();
}

//void draw() {
//}

int[][] pixels1To2(int[] _pixels, int _width, int _height) {
  int[][] outputPixels2 = new int[_width][_height];
  for (int i=0; i<_pixels.length; i++) {
    outputPixels2[i%_width][int(i/_width)] = _pixels[i];
  }
  return outputPixels2;
}

//void keyPressed() {
//  pressedKey = str(key);
//  setup();
//}