import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day24\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<Tile> masterList = new ArrayList<Tile>();
int[][] map;
int mapSize=0;

void setup() {
  size(1000, 1000);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0;

  String temp=null,d=null;
  boolean lookFor1Char=true;
  int globalID=0;
  Tile padTile=new Tile(globalID++);
  Tile baseTile=new Tile(globalID);
  boolean newTile=false;
  
  mapSize=(input.longestLine*2)*4;

  println("Longest line="+input.longestLine+" requires width/height of at least ["+mapSize+"]");
  map=new int[mapSize][mapSize];

  baseTile.mapX=mapSize/2;
  baseTile.mapY=mapSize/2;  
  baseTile.updateMap();
  masterList.add(padTile); // unused - pad 
  masterList.add(baseTile); // we add it twice as we dont want to use '0' index for anything
  
  for (i=0;i<input.lines.size();i++)
  //for (i=0;i<1;i++)
  {
    temp = input.lines.get(i);
    
    println();
    println("PARSING:"+temp);
    Tile currentTile=baseTile;
    
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
      Tile tempTile=currentTile.getTileByDirection(d);

      
      // Test to see if a tile exists in this direction or not?
      // if it doesnt, create one
      if (tempTile==null)
      {
        //print("CREATING NEW TILE ");
        print("C");
        tempTile=new Tile(++globalID);
        masterList.add(tempTile);
        newTile=true;
      }
      else
      {
        print("E");
        //print("USING EXISTING TILE ");
        newTile=false;
      }
      // connect it to the current tile
      currentTile.connectTile(tempTile,d);
      
      // move to the new tile
      currentTile=tempTile;
    } 
    if (newTile==false)
    {
      print("EXISTING:");
    }
    else
    {
      print("NEW:");
    }
    print(currentTile.changeState());
  }
  
  int total=0;
  println();
  println("TOTAL NODES CREATED:"+masterList.size());
  for (i=0;i<masterList.size();i++)
  {
    //masterList.get(i).printTile();
    total+=masterList.get(i).state;
  }
  print("FINAL ANSWER="+total);
}

void printMasterList()
{
  int i=0;
  for (i=0;i<masterList.size();i++)
  {
    println("Allergen ML:"+masterList.get(i));
  }
}


void draw() {  
  int x,y;
  int tileIndex=0;
  background(100);

  for (x=0;x<mapSize;x++)
  {
    for (y=0;y<mapSize;y++)
    {
      if (map[x][y]!=0)
      {
        masterList.get(map[x][y]).drawTile(4);
      }
    }
  }
  noLoop();
}


public class Tile
{
  int tileID=0;
  int mapX=0,mapY=0;

  Tile ne=null;
  Tile e=null;
  Tile se=null;
  Tile sw=null;
  Tile w=null;
  Tile nw=null;

  int state=0;
  
  // this is basically acting as a boolean, but making it as an int for future extension
  public int changeState()
  {
    if (state==1)
    {
      println("--> reverting to 0 on ID:"+tileID);
      state=0;
    }
    else
    {
      println("--> setting to 1 on ID:"+tileID);
      state=1;
    }
    return(state);
  }
  
  public Tile(int id)
  {
    tileID=id;
  }

  public void printTile()
  {
    print("ID:"+tileID+" state:"+state+" ");
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

  public Tile getTileByDirection(String d)
  {
    int x=0,y=0;
    if (d.equals("nw")==true)
    {
      x= this.mapX-1;
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

    if (map[x][y]!=0)
    {
      return(masterList.get(map[x][y]));
    }
      
    //if (d.equals("nw")==true)
    //{
    //  return(nw);
    //}
    //else if (d.equals("ne")==true)
    //{
    //  return(ne);
    //}
    //else if (d.equals("se")==true)
    //{
    //  return(se);
    //}
    //else if (d.equals("sw")==true)
    //{
    //  return(sw);
    //}
    //else if (d.equals("w")==true)
    //{
    //  return(w);
    //}
    //else if (d.equals("e")==true)
    //{
    //  return(e);
    //}
    return(null);
  }

  
  public void connectTile(Tile t,String d)
  {
    print("->["+this.tileID+" to "+t.tileID+" via "+d+"] ");
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
    t.updateMap();
  }

  void updateMap()
  {
    map[mapX][mapY]=tileID;
  }
  
  void drawTile(int scale)
  {
    if (state==0)
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
