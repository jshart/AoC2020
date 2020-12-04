//int[] inputInts = new int[

String[] lines;
int totalLines = 0;
int totalCols =0;
int[][] treeMap;

int playerX=0, playerY=0, playerHits=0;
int playerRight=1;
int playerDown=2;

int gridSize=1;

void setup() {
  size(1028, 1028);
  background(255,255,255);
  stroke(255);
  frameRate(30);
  
  lines = loadStrings("input.txt");
  totalLines=lines.length-1;

    
  int i=0;
  print(totalLines+"\n");
  
  for (i=0;i<totalLines;i++)
  {
    print(lines[i].length()+" "+lines[i]+"\n");
    //tempPair = new TreeMap(trim(lines[i]));
    
    //print(tempPair.pair+" ");
  }
  
  totalCols = totalLines * 8;
  
  // ignore the header  
  treeMap = new int[totalCols][totalLines];
  int x,y;
  int stripeWidth=lines[i].length();
  
  // ignore the header (skip first line)
  for (y=1;y<totalLines+1;y++)
  {
    for (x=0,i=0;x<totalCols;x++,i++)
    {
       if (i==stripeWidth)
       {
         i=0;
       }
       
       if (lines[y].charAt(i)=='#')
       {
         treeMap[x][y-1]=1;
       }
    }
  }
  
  //int j=0;
  
  //for (j=0;j<totalLines;j++)
  //{
  //  if (treeMap[j][0]==1)
  //  {
  //    print("#");
  //  }
  //  else
  //  {
  //    print(".");
  //  }
  //}
}

void draw() {
  int x=0, y=0;
  
  background(255);


  for (y=0;y<totalLines;y++)
  {
    for (x=0;x<totalCols;x++)
    {
      if (treeMap[x][y]==1)
      {
        stroke(0,255,0);
        rect(x*gridSize,y*gridSize,gridSize,gridSize);
      }
      if (treeMap[x][y]==2)
      {
        stroke(255,0,0);
        rect(x*gridSize,y*gridSize,gridSize,gridSize);
      }
    }
  }
  playerX+=playerRight;
  playerY+=playerDown;
  
  stroke(90,0,255);
  circle(playerX*gridSize,playerY*gridSize,gridSize/2);
  
  if (playerY>=totalLines || playerX>=totalCols)
  {
    noLoop();
    print("Player exited the map");
    print("Player hit: "+playerHits+" trees");
    return;
  }
  
  if (treeMap[playerX][playerY]==1)
  {
    playerHits++;
    treeMap[playerX][playerY]++;
  }
}
