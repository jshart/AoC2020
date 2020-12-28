import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day24_part2\\data\\mydata");

// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
Tile[][] map;
int mapSize=0;
//int globalID=0;
int activeState=0;

void setup() {
  size(2000, 2000);
  background(0);
  stroke(255);
  frameRate(5);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0,x=0,y=0;

  String temp=null,d=null;
  boolean lookFor1Char=true;
  Tile baseTile=new Tile();
  Tile tempTile;
  
  mapSize=(input.longestLine*2)*4;

  // Calculate the longest set of instructions in the file and then approximate a good map size
  println("Longest line="+input.longestLine+" requires width/height of at least ["+mapSize+"]");
  
  map=new Tile[mapSize][mapSize];


  // Initialise the map area to start the process.
  for (y=0;y<mapSize;y+=2)
  {
    if (y%4==0)
    {
      x=0;
    }
    else
    {
      x=1;
    }
    for (;x<mapSize;x+=2)
    {
      tempTile=new Tile();
      tempTile.mapX=x;
      tempTile.mapY=y;
      //if (x%4==0)
      //{
      //  tempTile.setState(1);
      //}
      tempTile.updateMap();
    }
  }

  
  // Create an initial tile in the centre of the map to work from
  baseTile.mapX=mapSize/2;
  baseTile.mapY=mapSize/2;  
  baseTile.updateMap();
  println("got pass initial state creation");
  
  
  
  // Loop through each line in the input
  for (i=0;i<input.lines.size();i++)
  //for (i=0;i<1;i++)
  {
    // grab each line from the input file to parse the set of directions.
    temp = input.lines.get(i);
    
    println();
    println("PARSING:"+temp);
    
    // Always start from the basetile.
    Tile currentTile=baseTile;
    
    // Parse the line looking for consecutive instructions to create or flip tiles.
    for (j=0;j<temp.length();)
    {
      //do we have at least 2 chars left??
      if (j<temp.length()-1)
      {
        lookFor1Char=true;
        d=temp.substring(j,j+2);
  
        if (d.equals("nw")==true)
        {
          print("nw,");
          lookFor1Char=false;
        }
        else if (d.equals("ne")==true)
        {
          print("ne,");
          lookFor1Char=false;
        }
        else if (d.equals("se")==true)
        {
          print("se,");
          lookFor1Char=false;
        }
        else if (d.equals("sw")==true)
        {
          print("sw,");
          lookFor1Char=false;
        }
        if (lookFor1Char==false)
        {
          j+=2;
        }
      }
      else
      {
        lookFor1Char=true;
      }
      
      // Ok, we failed to find a valid 2 char direction
      // lets test for a single char one
      if (lookFor1Char==true)
      {
        d=temp.substring(j,j+1);
        //print("extracted> "+d+" ");


        if (d.equals("w")==true)
        {
          print("w,");
        }
        else if (d.equals("e")==true)
        {
          print("e,");
        }
        j++;
      }
      
      // We have a direction, lets see if there is a tile there to fetch
      tempTile=currentTile.getTileByDirection(d);

      // Test to see if a tile exists in this direction or not?
      // if it doesnt, create one
      if (tempTile==null)
      {
        print("C");
        tempTile=new Tile();
      }
      else
      {
        print("E");
      }

      // At this point, we've either found, or created a new
      // tile - connect it to the current tile
      currentTile.connectTile(tempTile,d);
      
      // move to the new tile
      currentTile=tempTile;
    } 

    print(currentTile.flipState());
  }
  
  
  //for (y=0;y<mapSize;y+=2)
  //{
  //  if (y%4==0)
  //  {
  //    x=0;
  //  }
  //  else
  //  {
  //    x=1;
  //  }
  //  for (;x<mapSize;x+=2)
  //  {
  //    if (map[x][y]!=null)
  //    {
  //      if (map[x][y].getState()==0)
  //      {
  //        print("#");
  //      }
  //      else
  //      {
  //        print("O");
  //      }
  //    }
  //    else
  //      print(".");
  //  }
  //  println();
  //}
}

void updateStates()
{
  int x,y;
  Tile temp;
  int neighbours=0;
  for (x=0;x<mapSize;x++)
  {
    for (y=0;y<mapSize;y++)
    {
      if (map[x][y]!=null)
      {
        temp=map[x][y];
        
        // Copy the current state over to the inactive mirror,
        // then we'll run the CA rules to change the inactive
        // state for any that match
        temp.setInactiveState(temp.getState());
        
        if (temp.getState()==0) // white
        {
          neighbours=temp.neighboursInOppositeState();
          if (neighbours==2)
          {
            temp.setInactiveState(1);
          }
        }
        else // black
        {
          neighbours=temp.neighboursInSameState();
          
          if (neighbours==0 || neighbours>2)
          {
            temp.setInactiveState(0);
          }
        }
      }
    }
  }
  flipActiveState();
}

void flipActiveState()
{
  if (activeState==0)
  {
    activeState=1;
  }
  else
  {
    activeState=0;
  }
}

int days=0;

void draw() {  
  int x,y;
  background(100);
  int scale=4; 

  println(days+" count:"+countTilesByState(1));
  if (days>=100)
  {
    noLoop();
  }

  //for (y=0;y<mapSize;y+=2)
  //{
  //  if (y%4==0)
  //  {
  //    x=0;
  //  }
  //  else
  //  {
  //    x=1;
  //  }
  //  for (;x<mapSize;x+=2)
  //  {
  //    noFill();
  //    stroke(200,200,200);
  //    rect(x*scale,y*scale,2*scale,2*scale);
  //  }
  //}

  for (x=0;x<mapSize;x++)
  {
    for (y=0;y<mapSize;y++)
    {
      if (map[x][y]!=null)
      {
        map[x][y].drawTile(4);
      }
    }
  }
  updateStates();
  days++;
  //noLoop();
}

int countTilesByState(int s)
{
  int count=0;
  int x=0,y=0;
  for (x=0;x<mapSize;x++)
  {
    for (y=0;y<mapSize;y++)
    {
      if (map[x][y]!=null)
      {
        if (map[x][y].getState()==s)
        {
          count++;
        }
      }
    }
  }
  return(count);
}


public class Tile
{
  //int tileID=0;
  int mapX=0,mapY=0;

  Tile ne=null;
  Tile e=null;
  Tile se=null;
  Tile sw=null;
  Tile w=null;
  Tile nw=null;

  int[] state = new int[2];

  public int neighboursInSameState()
  {
    int total=0;
    total=countNeighbourStates(getState());
    return(total);
  }

  public int neighboursInOppositeState()
  {
    int total=0;
    total=countNeighbourStates(getFlippedState());
    return(total);
  }

  public int getState()
  {
    return(state[activeState]);
  }
  
  public void setState(int s)
  {
    state[activeState]=s;
  }

  public void setInactiveState(int s)
  {
    if (activeState==0)
    {
      state[1]=s;
    }
    else
    {
      state[0]=s;
    }
  }
  
  public int countNeighbourStates(int match)
  {
    Tile temp;
    int total=0;
    
    temp=getTileByDirection("e");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
    
    temp=getTileByDirection("w");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
        
    temp=getTileByDirection("ne");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
    
    temp=getTileByDirection("nw");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
    
    temp=getTileByDirection("se");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
    
    temp=getTileByDirection("sw");
    if (temp!=null)
    {
      if (temp.getState()==match)
      {
        total++;
      }
    }
    
    return(total);
  }

  public void connectAllNeighbours()
  {
    Tile temp;
    temp=getTileByDirection("e");
    if (temp!=null)
    {
      connectTile(temp,"e");
    }
    
    temp=getTileByDirection("w");
    if (temp!=null)
    {
      connectTile(temp,"w");
    }
        
    temp=getTileByDirection("ne");
    if (temp!=null)
    {
      connectTile(temp,"ne");
    }
    
    temp=getTileByDirection("nw");
    if (temp!=null)
    {
      connectTile(temp,"nw");
    }
    
    temp=getTileByDirection("sw");
    if (temp!=null)
    {
      connectTile(temp,"sw");
    }
    
    temp=getTileByDirection("se");
    if (temp!=null)
    {
      connectTile(temp,"se");
    }
    
    return;
  }
  
  public int getFlippedState()
  {
    int flippedState=0;
    
    if (getState()==1)
    {
      flippedState=0;
    }
    else
    {
      flippedState=1;
    }
    return(flippedState);
  }
  
  // this is basically acting as a boolean, but making it as an int for future extension
  public int flipState()
  {
    setState(getFlippedState());
    return(getState());
  }
  
  public Tile()
  {
  }

  public void printTile()
  {
    if (nw!=null)
    {
      print("nw,");
    }
    if (ne!=null)
    {
      print("ne,");
    }
    if (se!=null)
    {
      print("se,");
    }
    if (sw!=null)
    {
      print("sw,");
    }
    if (w!=null)
    {
      print("w,");
    }
    if (e!=null)
    {
      print("e,");
    }
    println();
  }

  public Tile addTileByDirection(String d)
  {
    int x=0,y=0;
    Tile tempTile;
    
    if (d.equals("nw")==true)
    {
      x = this.mapX-1;
      y = this.mapY-2;
    }
    else if (d.equals("ne")==true)
    {
      x = this.mapX+1;
      y = this.mapY-2;
    }
    else if (d.equals("se")==true)
    {
      x = this.mapX+1;
      y = this.mapY+2;
    }
    else if (d.equals("sw")==true)
    {
      x = this.mapX-1;
      y = this.mapY+2;
    }
    else if (d.equals("w")==true)
    {
      x = this.mapX-2;
      y = this.mapY;
    }
    else if (d.equals("e")==true)
    {
      x = this.mapX+2;
      y = this.mapY;
    }

    if ((x>=0 && x<mapSize) && (y>=0 && y<mapSize))
    {
      if (map[x][y]!=null)
      {
        return(null);
      }
      else
      {
        tempTile=new Tile();
        this.connectTile(tempTile,d);        
      }
    } 
    return(null);
  }


  public Tile getTileByDirection(String d)
  {
    int x=0,y=0;
    if (d.equals("nw")==true)
    {
      x = this.mapX-1;
      y = this.mapY-2;
    }
    else if (d.equals("ne")==true)
    {
      x = this.mapX+1;
      y = this.mapY-2;
    }
    else if (d.equals("se")==true)
    {
      x = this.mapX+1;
      y = this.mapY+2;
    }
    else if (d.equals("sw")==true)
    {
      x = this.mapX-1;
      y = this.mapY+2;
    }
    else if (d.equals("w")==true)
    {
      x = this.mapX-2;
      y = this.mapY;
    }
    else if (d.equals("e")==true)
    {
      x = this.mapX+2;
      y = this.mapY;
    }

    if ((x>=0 && x<mapSize) && (y>=0 && y<mapSize))
    {
      if (map[x][y]!=null)
      {
        return(map[x][y]);
      }
    } 
    return(null);
  }


  // Connect this tile to tile 't' in directon 'd'
  public void connectTile(Tile t,String d)
  {
    // if t is null, it means we dont have a tile to connect
    // to and so we cant do anything, just return.
    if (t==null)
    {
      return;
    }
    
    if (d.equals("nw")==true)
    {
      t.mapX = this.mapX-1;
      t.mapY = this.mapY-2;
      nw=t;
      t.se=this;
    }
    else if (d.equals("ne")==true)
    {
      t.mapX = this.mapX+1;
      t.mapY = this.mapY-2;
      ne=t;
      t.sw=this;
    }
    else if (d.equals("se")==true)
    {
      t.mapX = this.mapX+1;
      t.mapY = this.mapY+2;
      se=t;
      t.nw=this;
    }
    else if (d.equals("sw")==true)
    {
      t.mapX = this.mapX-1;
      t.mapY = this.mapY+2;
      sw=t;
      t.ne=this;
    }
    else if (d.equals("w")==true)
    {
      t.mapX = this.mapX-2;
      t.mapY = this.mapY;
      w=t;
      t.e=this;
    }
    else if (d.equals("e")==true)
    {
      e=t;
      t.w=this;
      t.mapX = this.mapX+2;
      t.mapY = this.mapY;
    }
  }

  void updateMap()
  {
    map[mapX][mapY]=this;
    connectAllNeighbours();
  }
  
  void drawTile(int scale)
  {
    if (getState()==0)
    {
      fill(255,255,255);
    }
    else
    {
      fill(0,0,0);
    }
    stroke(200,200,200);
    rect(mapX*scale,mapY*scale,2*scale,2*scale);
  }
}




public class InputFile
{
  ArrayList<String> lines = new ArrayList<String>();
  int numLines=0;
  int longestLine=0;
  String fileName;
  
  public InputFile(String fname)
  {
    fileName=fname;
    
    try {
      String line;
      
      File fl = new File(filebase+File.separator+fileName);
  
      FileReader frd = new FileReader(fl);
      BufferedReader brd = new BufferedReader(frd);
    
      while ((line=brd.readLine())!=null)
      {
        println("loading:"+line);
        lines.add(line);
        if (line.length()>longestLine)
        {
          longestLine=line.length();
        }
      }
      brd.close();
      frd.close();
  
    } catch (IOException e) {
       e.printStackTrace();
    }
    
    numLines=lines.size();
  }
  
  public void printFile()
  {
    println("CONTENTS FOR:"+fileName);
    int i=0;
    for (i=0;i<numLines;i++)
    {
      println("L"+i+": "+lines.get(i));
    }
  }
}
