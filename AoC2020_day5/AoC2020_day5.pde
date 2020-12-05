//int[] inputInts = new int[

String[] lines;
int totalLines;
int totalRows = 128;
int totalSeats =8;
int[][] seatingPlan;

int playerX=0, playerY=0, playerHits=0;
int playerRight=1;
int playerDown=2;

int gridSize=8;

void setup() {
  size(2048, 1028);
  background(255,255,255);
  stroke(255);
  frameRate(30);
  
  lines = loadStrings("input.txt");
  totalLines=lines.length-1;

  seatingPlan = new int[totalRows][totalSeats];
  
  int i=0,j=0,len=0;
  int rowMin=0, rowMax=0;
  int seatMin=0, seatMax=0;
  int chunkSize=0;
  print(totalLines+"\n");
  
  int maxSeat=0,tempSeat=0;
  
  // Skip the header line
  for (i=1;i<totalLines;i++)
  {
    rowMin=1;
    rowMax=128;
    chunkSize=rowMax;
    
    len=lines[i].length();
    print(len+" "+lines[i]+"\n");
    
    for (j=0;j<7;j++)
    {
      print("."+lines[i].charAt(j));
      chunkSize/=2;
      if (lines[i].charAt(j)=='F')
      {
        rowMax-=chunkSize;
      }
      if (lines[i].charAt(j)=='B')
      {
        rowMin+=chunkSize;
      }
    }
    
    print("ROW:"+rowMin+","+rowMax+" ");
    
    seatMin=1;
    seatMax=8;
    chunkSize=seatMax;
    for (;j<10;j++)
    {
      print("."+lines[i].charAt(j));
      chunkSize/=2;
      if (lines[i].charAt(j)=='L')
      {
        seatMax-=chunkSize;
      }
      if (lines[i].charAt(j)=='R')
      {
        seatMin+=chunkSize;
      }

    }
    print("SEAT:"+seatMin+","+seatMax);

    rowMax-=1;
    seatMax-=1;
    tempSeat=((rowMax)*8)+(seatMax);
    
    print(" SEAT No:"+tempSeat);
    if (tempSeat>maxSeat)
    {
      //println("new Max:"+maxSeat);
      maxSeat=tempSeat;
    }
    
    seatingPlan[rowMax][seatMax]=1;
  }
  print("HIGHEST NUMBER SEAT="+maxSeat);
 
}

void draw() {
  int x=0, y=0;
  
  background(255);

  for (x=0;x<totalRows;x++)
  {
    for (y=0;y<totalSeats;y++)
    {
        noFill();
        stroke(255,255,0);
        rect(x*gridSize,y*gridSize,gridSize,gridSize);

        if (seatingPlan[x][y]==1)
        {
          fill(0,255,0);
          rect(x*gridSize,y*gridSize,gridSize,gridSize);
        }
        else
        {
          // quick hack to filter out well known empty rows and
          // just focus the search on the part of the plane
          // known to be full. (basically determined by looking
          // at the seat plan visualisation.
          if (x>20&&x<100)
            println("Empty Seat at:"+x+","+y+" No:"+((x*8)+y) );
        }
    }
  }

  noLoop();
}
