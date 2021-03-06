import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day20_part3\\data\\mydata");

InputFile input = new InputFile("input.txt");
ArrayList<PictureTile> tiles = new ArrayList<PictureTile>();

PictureTile[][] tileGrid = new PictureTile[12][12];

int gsf=11;

FinalPicture fp = new FinalPicture();

// TODO;
// 4) Create a function to grid search for "monster" pattern matches - record number of matches
// 5) calculate final answer = total populated cells - (no monsters * no of '1's in a monster)
// 6) win gold star!

// total populated cells=15Total waves;2254


void setup() {
  size(2500, 1400);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  input.printFile();
  parseFile();
  
  int i=0,j=0;
  PictureTile temp1, temp2;

  // check every tile in the list...
  for (i=0;i<tiles.size();i++)
  {
    
    // ... against every other tile in the list
    temp1=tiles.get(i);
    
    for (j=0;j<tiles.size();j++)
    {
      // no need to check the tile against itself
      if (i!=j)
      { 
        temp2=tiles.get(j);
  
        if (temp2.locked==false)
        {
          temp1.transformToAlignWith(temp2);
        }
      }
    }
  }
  println();
  long total=1;
  for (i=0;i<tiles.size();i++)
  {
    temp1=tiles.get(i);
    
    if (temp1.borderList.commonBordersFound()==2)
    {
      println("tile ID:"+temp1.title);
      
      total*=temp1.tileNumberFromFile;
    }
  }  
  print("Final:"+total);
  
  
  
  tileGrid[0][0]=tiles.get(12);
  
  int direction=0;
  int x=0,y=0;

  // Process each *row*
  for (y=0;y<12;y++)
  {
    x=0;

    // Grab the starting tile for this row - it should already be added by this point
    temp1=tileGrid[x][y];

println("reassembling:"+x+","+y);

    if (y<11)
    {
      // Check the borders, looking for the one that aligns with the bottom (i.e. below)
      // and add this to the *next* row
      for (i=0;i<temp1.borderList.commonBordersFound();i++)
      {
        // grab one of the neighbour tiles
        temp2=tiles.get(temp1.borderList.getBorderByIndex(i));
        
        direction=temp2.transformToAlignWith(temp1);
        if (direction==3) //bottom
        {
          tileGrid[x][y+1]=temp2;
        }
      }
    }

    boolean found=false;
    // Now walk along the row...
    for (x=0;x<11;x++)
    {
      found=false;
      // looking for the *next* element on this row
      for (i=0;i<temp1.borderList.commonBordersFound();i++)
      {
        // grab one of the neighbour tiles
        temp2=tiles.get(temp1.borderList.getBorderByIndex(i));
        
        // Found an element, align to the current node
        direction=temp2.transformToAlignWith(temp1);
        
        // if this matches in the right direction...
        if (direction==1) //Right
        {
          // add it to the next element, which gets us ready to check the next element
          tileGrid[x+1][y]=temp2;
          temp1=temp2;
          found=true;
          break;
        }
      }
      if (found==false)
      {
        println(temp1.alNumber+" failed to find a valid neighbour to the right:"+x+","+y+" ");
        temp1.borderList.printBorders();
        println();
      }
    }
  }
  
  SeaMonster m = new SeaMonster();
  m.printMonster();
  fp.mapContentToFinalPicture();

  int monsters=0;
  
  println();
  for (i=0;i<4;i++)
  {
    for (x=0;x<96;x++)
    {
      for (y=0;y<96;y++)
      {
        if (m.isMonster(fp,x,y)==true)
        {
          monsters++;
        }
      }
    }
    fp.rotateLeft90();
  }
  fp.flipTileHorz();
  for (i=0;i<4;i++)
  {
    for (x=0;x<96;x++)
    {
      for (y=0;y<96;y++)
      {
        if (m.isMonster(fp,x,y)==true)
        {
          monsters++;
        }
      }
    }
    fp.rotateLeft90();
  }
  fp.flipTileHorz();

  println("Total monsters="+monsters);
  
  
}



void parseFile()
{
  int l=input.numLines;
  int i=0,j=0,k=0;
  String s;
  PictureTile temp;
  
  for (i=0;i<l;i++)
  {
    s=input.lines.get(i);
    if (s.length()>0 && s.charAt(0)=='T')
    {   
      // New tile
      temp=new PictureTile();
      
      // grab the tile number
      temp.tileNumberFromFile=Integer.parseInt(s.substring(5,s.length()-1));
      //println("Tile number calculated to ="+temp.tileNumber);

      temp.title=s;
      
      // move onto the pixel matrix
      i++;
      
      // save each line
      for (j=0;j<10;j++,i++)
      {
        for (k=0;k<10;k++)
        {
          s=input.lines.get(i);
          // save each pixel
          if (s.charAt(k)=='#')
          {
            temp.content[j][k]=1;  
          }
          else
          {
            temp.content[j][k]=0;  
          }
        }
      }
      temp.buildBorders();
      temp.alNumber=tiles.size();
      tiles.add(temp);
    }
  }
}

void draw()
{
  gridLayout();
  drawTiles();
  //fixGraphicsLocations();
  //drawTiles();
  
  fp.drawFinalMap();
  noLoop();
}





void gridLayout() {
  int x,y,i;
  background(255);
  int gx=0,gy=0;
  PictureTile currentTile=null;

  for (x=0;x<12;x++)
  {
    for (y=0;y<12;y++)
    {
      gx=(x)*gsf*10;
      gy=(y)*gsf*10;
      currentTile=tileGrid[x][y];
      if (currentTile!=null)
      {
        currentTile.updateGfx(gx,gy);
      }
    }
  }
}

void listLayout() {
  int x,y,i;
  int tileIndex=0;
  background(255);
  int gx=0,gy=0;
  PictureTile currentTile=null;
  PictureTile destTile=null;

  // Compute GFX co-ordinates.    
  for (x=0;x<12;x++)
  {
    for (y=0;y<12;y++)
    {
      gx=(x)*gsf*10;
      gy=(y)*gsf*10;
      
      currentTile=tiles.get(tileIndex);
      //println("Getting tile:"+tileIndex+" "+gx+","+gy+" "+x+","+y+" "+(gx+((gsf*10)/2))+","+(gy+((gsf*10)/2)));
      currentTile.updateGfx(gx,gy);

      tileIndex++;
    }
  }
}

void drawTiles() {  
  int x,y,i;
  int tileIndex=0;
  background(255);
  int gx=0,gy=0;
  PictureTile currentTile=null;
  PictureTile destTile=null;

  String s;
  
  int dl=5;

      
  tileIndex=0;
  for (x=0;x<12;x++)
  {
    for (y=0;y<12;y++)
    {
      currentTile=tiles.get(tileIndex);
      gx=currentTile.gx;
      gy=currentTile.gy;
      //s=new String("["+currentTile.alNumber+"]");
      s=new String();


      // Draw tiles
      s=Integer.toString(tileIndex);
      
      fill(200,200,200);

      circle(gx+((gsf*10)/2),gy+((gsf*10)/2),40); 
      rect(gx,gy,gsf*10,gsf*10);
      fill(255,0,0);

      text(s,gx+((gsf*10)/2),gy+((gsf*10)/2));

      if (currentTile.borderList.commonBordersFound()<dl)
      //if (tileIndex==12)
      {
        currentTile.drawTile(gx,gy);
      }


      stroke(255,0,255);
      strokeWeight(3);
  

      // Draw connector lines
      for (i=0;i<currentTile.borderList.commonBordersFound();i++)
      {
        destTile=tiles.get(currentTile.borderList.getBorderByIndex(i));
        s+=","+Integer.toString(currentTile.borderList.getBorderByIndex(i));
        
        if (currentTile.borderList.commonBordersFound()<4)
        {
          line(currentTile.gx,currentTile.gy,destTile.gx,destTile.gy);
        }
      }

      
      // Draw connection text
      //text(s,currentTile.gx+(gsf*10), currentTile.gy+(gsf*11));
      if (currentTile.borderList.commonBordersFound()<dl)
      {
        fill(255,0,0);
        text(s,currentTile.gx, currentTile.gy+(gsf*11));
      }

      tileIndex++;
    }
  }
}

public boolean tileInList(ArrayList<PictureTile> tl, PictureTile t)
{
  int j=0;
  for (j=0;j<tl.size();j++)
  {
    if (tl.get(j)==t)
    {
      return(true);
    }
  }
  return(false);
}

public class BorderListContainer
{
  private ArrayList<Integer> bl = new ArrayList<Integer>();

  public BorderListContainer()
  {
  }
  
  public void addBorderIfNew(int newBorder)
  {
    int j=0;
    for (j=0;j<bl.size();j++)
    {
      if (bl.get(j)==newBorder)
      {
        return;
      }
    }
    bl.add(newBorder);
  }

  public void printBorders()
  {
    int j=0;
    print("Borders:");
    for (j=0;j<bl.size();j++)
    {
      print(bl.get(j)+",");
    }
  }
  
  public int commonBordersFound()
  {
    return(bl.size());
  }
  
  public int getBorderByIndex(int i)
  {
    return(bl.get(i));
  }
}

public class PictureTile
{
  String title;
  int tileNumberFromFile=0;
  int alNumber=-1;
  int[][] content=new int[10][10]; // looks like we can hard code the sizes here
  
  int[][] borders=new int[4][10];
  //int[] borderMatchIndex = new int[4];
  BorderListContainer borderList = new BorderListContainer();
  
  int gx=0;
  int gy=0;
  
  boolean locked=false;

  
  public void updateGfx(int x, int y)
  {
    gx=x;
    gy=y;
  }
  
  public void flipTileVert()
  {
    int[][] temp=new int[10][];
    int i=0;
    
    for (i=0;i<10;i++)
    {
      temp[9-i]=content[i];
    }
    for (i=0;i<10;i++)
    {
      content[i]=temp[i];
    }
    buildBorders();
    //print("F");
  }

  public void rotateLeft90()
  {
    int[][] temp=new int[10][10];
    int i=0,j=0;
    
    for (i=0;i<10;i++)
    {
      for (j=0;j<10;j++)
      {
        temp[i][j]=content[j][9-i];
      }
    }
    for (i=0;i<10;i++)
    {
      content[i]=temp[i];
    }
    buildBorders();
  }
  
  public void rotateRight90()
  {
    int[][] temp=new int[10][10];
    int i=0,j=0;
    
    for (i=0;i<10;i++)
    {
      for (j=0;j<10;j++)
      {
        temp[j][9-i]=content[i][j];
      }
    }
    for (i=0;i<10;i++)
    {
      content[i]=temp[i];
    }
    buildBorders();
    //print("R");
  }

  public void drawTile(int xoffset, int yoffset)
  {
    int x=0, y=0;

    for (y=0;y<10;y++)
    {
      for (x=0;x<10;x++)
      {
        if (borderList.commonBordersFound()==2)
        {
          fill(0,0,255);
        }
        else if (borderList.commonBordersFound()==3)
        {
          fill(0,0,125);
        }
        else
        {
          noFill();
        }
        stroke(200,200,200);
        rect((x*gsf)+xoffset,(y*gsf)+yoffset,gsf,gsf);

        if (content[x][y]==1)
        {
          fill(0,255,0);
          if (x==0 || x==9 || y==0 || y==9)
          {
            fill(255,0,0);
          }
          rect((x*gsf)+xoffset,(y*gsf)+yoffset,gsf,gsf);
        }
      }
    } 
  }
  
  public PictureTile()
  {

  }
  
  public void printBorders()
  {
    int i=0;
    int j=0;
    int k=0;
    
    println("*** BORDER DUMP START");
    for (j=0;j<8;j++)
    {
      print("BORDER:");
      for (i=0;i<10;i++)
      {
        print(borders[j][i]);
      }
      k++;
      println();
    }
    println("*** BORDER DUMP END; rows printed="+k);
  }
 
  
  public void buildBorders()
  {
    int i=0;
    for (i=0;i<10;i++)
    {
      borders[0][i]=content[0][i]; // left border
      borders[1][i]=content[9][i]; // right border
      borders[2][i]=content[i][0]; // top border
      borders[3][i]=content[i][9]; // bottom border
    }
    //printBorders();
  }

  // transform the tile and test to see if any borders match
  public int transformToAlignWith(PictureTile t)
  {
    int commonBorder=-1;

    // Rotate through 360 degrees, testing each combo at 90
    // if we find a solution we return, if we dont then the
    // tile will return to its original position
    commonBorder=rotateAndCheck(t);
    if (commonBorder>=0)
    {
      return(commonBorder);
    }
    
    // If none of the original rotations work, lets flip
    // the tile and try again
    flipTileVert();
    
    // Run through a series of rotations again, same deal
    // as before.
    commonBorder=rotateAndCheck(t);
    if (commonBorder>=0)
    {
      return(commonBorder);
    }
    
    // If we get to here, then we're out of permutations,
    // flip the tile back to its original orientation - should
    // actuall be irrelevent for the code, but just leaves us in
    // a steady state and easier to debug
    flipTileVert();
    
    return(-1);
  }
  
  public int rotateAndCheck(PictureTile t)
  {
    int i=0;
    int result=-1;

    // Rotate for 4 turns of 90 degrees
    for (i=0;i<4;i++)
    {
      // check to see if any of the current
      // borders match
      result=checkBorders(t);
      if (result>=0)
      {
        return(result);
      }
      
      // no match yet - so rotate and repeat
      rotateRight90();      
    }    
    return(result);
  }

  // Check for adjacent tiles that have a common border pattern,
  // check left, right, below and above.
  public int checkBorders(PictureTile t)
  {
    // See if this pair of tiles align on any cardinal edges
    //borders[0][i]=content[0][i]; // left border
    //borders[1][i]=content[9][i]; // right border
    //borders[2][i]=content[i][0]; // top border
    //borders[3][i]=content[i][9]; // bottom border  

    // Left v Right      
    if (borderMatch(borders[0],t.borders[1])==true)
    {
      borderList.addBorderIfNew(t.alNumber);
      t.borderList.addBorderIfNew(this.alNumber);
      // we are to the left of t
      return(1);

    }
    // Right v Left
    if (borderMatch(borders[1],t.borders[0])==true)
    {
      borderList.addBorderIfNew(t.alNumber);
      t.borderList.addBorderIfNew(this.alNumber);
      // we are to the right of t
      return(0);

    }
    // top v Bottom
    if (borderMatch(borders[2],t.borders[3])==true)
    {
      borderList.addBorderIfNew(t.alNumber);
      t.borderList.addBorderIfNew(this.alNumber);
      // we are below t
      return(3);

    }
    // Bottom v Top
    if (borderMatch(borders[3],t.borders[2])==true)
    {
      borderList.addBorderIfNew(t.alNumber);
      t.borderList.addBorderIfNew(this.alNumber);
      // we are above t
      return(2);

    }
    
    return(-1);
  }
  
  // This simply does a "string" style char by char match between the 2 border arrays
  public boolean borderMatch(int[] a, int[] b)
  {
    int i=0;
    for (i=0;i<10;i++)
    {
      // check every element in this border against every element in that border
      if (a[i]!=b[i])
      {
        // if any dont match, bail
        return(false);
      }
    } 
    // if we get here these element borders must match
    return(true);
  }
  
  public void printTile()
  {
    int j=0,k=0;

    println("Title;"+title);

    for (j=0;j<10;j++)
    {
      for (k=0;k<10;k++)
      {
        if (content[j][k]==1)
        {
          print("1");
        }
        else
        {
          print("0");
        }
      }
      println();
    }
    for (j=0;j<4;j++)
    {
      print(title+":");
      for (k=0;k<10;k++)
      {
        print(borders[j][k]);
      }
      println();
    }
  }
}


public class InputFile
{
  ArrayList<String> lines = new ArrayList<String>();
  int numLines=0;
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
        print("loading:"+line);
        lines.add(line);
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

// TODO: Need to flip Horz, Vert, and rotate 90 (and then flip horz & vert again)
public class SeaMonster
{
  // Sea monsters have 15 populated pixels
  int populated=15;
  
  String[] monsterAscii ={"                  # ",
                          "#    ##    ##    ###",
                          " #  #  #  #  #  #   "};
  
    //String[] monsterAscii ={" #  #  #  #  #  #   ",
    //                        "#    ##    ##    ###",
    //                        "                  # "};
  int[][] hContent = new int[20][3];
  int total=0;
  
  public SeaMonster()
  {
    int i=0,j=0;

    for (i=0;i<20;i++)
    {
      for (j=0;j<3;j++)
      {
        if (monsterAscii[j].charAt(i)=='#')
        {
          hContent[i][j]=1;
          total+=1;
        }
        else
        {
          hContent[i][j]=0;
        }
      }
    }
  }
  
  public void printMonster()
  {
    int i=0,j=0;
 
    for (i=0;i<3;i++)
    {
      println(monsterAscii[i]);
    }
  
    for (j=0;j<3;j++)
    {
      for (i=0;i<20;i++)
      {
        print(hContent[i][j]);
      }
      println();
    }
    print("total populated cells="+total);
  }
  
  public boolean isMonster(FinalPicture fp, int offsetx, int offsety)
  {
    int i=0,j=0;
    
    //println("Checking for monster at:"+offsetx+","+offsety);
    for (i=0;i<20;i++)
    {
      for (j=0;j<3;j++)
      {
        if (offsetx+i>=96 || offsety+j>=96)
        {
          return(false);
        }
        if (hContent[i][j]>0 && fp.finalPicture[offsetx+i][offsety+j]==0)
        {
          return(false);
        }
      }
    }
    println("Monster found");
    return(true);
  }
}

public class FinalPicture
{
  int[][] finalPicture = new int[96][96];
  
  void mapContentToFinalPicture()
  {
    int x,y,xc,yc;
    int dx,dy;
    PictureTile currentTile=null;
  
    for (x=0;x<12;x++)
    {
      for (y=0;y<12;y++)
      {
        currentTile=tileGrid[x][y];
        for (xc=1;xc<9;xc++)
        {
          for (yc=1;yc<9;yc++)
          {
            dx=(x*8)+(xc-1);
            dy=(y*8)+(yc-1);
            finalPicture[dx][dy]=tileGrid[x][y].content[xc][yc];
          }
        }
      }
    }
  }
  
  void drawFinalMap()
  {
    int x,y;
    int xoffset=1400;
    int waves=0;
    for (x=0;x<96;x++)
    {
      for (y=0;y<96;y++)
      {
        if (finalPicture[x][y]>0)
        {
          fill(0,0,200);
          stroke(0,0,255);
          rect(xoffset+(x*gsf),y*gsf,gsf,gsf);
          waves+=1;
        }
      }
    }
    println("Total waves;"+waves);
  }

  public void flipTileHorz()
  {
    int[][] temp=new int[96][];
    int i=0;
    
    println("Flipping Picture vert");
    
    for (i=0;i<96;i++)
    {
      temp[95-i]=finalPicture[i];
    }
    for (i=0;i<96;i++)
    {
      finalPicture[i]=temp[i];
    }
  }

  public void rotateLeft90()
  {
    int[][] temp=new int[96][96];
    int i=0,j=0;
    
    println("Rotating Picture 90");
    
    for (i=0;i<96;i++)
    {
      for (j=0;j<96;j++)
      {
        temp[j][95-i]=finalPicture[i][j];
      }
    }
    for (i=0;i<96;i++)
    {
      finalPicture[i]=temp[i];
    }
  }
}
