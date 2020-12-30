import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day20_part2\\data\\mydata");

InputFile input = new InputFile("input.txt");
ArrayList<PictureTile> tiles = new ArrayList<PictureTile>();

PictureTile[][] tileGrid = new PictureTile[12][12];

int gsf=8;

void setup() {
  size(1024, 1024);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  input.printFile();
  parseFile();
  
  int i=0,j=0;
  PictureTile temp1, temp2;

  //println("Tile count:"+tiles.size()+" picture size? "+Math.sqrt((double)i));
  //for (i=0;i<tiles.size();i++)
  //{
  //  temp1=tiles.get(i);
  //  temp1.printTile();
  //}
  
  
  boolean bordersFound=false;

  //tiles.get(0).locked=true;

  //temp1=tiles.get(0);
  //temp1.printTile();
  //temp1.flipTileVert();
  //temp1.printTile();
  //temp1.flipTileVert();
  //temp1.printTile();

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
          bordersFound=temp1.transformToAlignWith(temp2);
          if (bordersFound==true)
          {
            //temp1.locked=true;
          }
        }
        else
        {
          temp1.justCheckBorders(temp2);
        }
                
        temp1.updateBorderCount();
        temp2.updateBorderCount();
      }
    }
  }
  
  int[] borderCounts=new int[5];
  for (i=0;i<tiles.size();i++)
  {
    temp1=tiles.get(i);
    
    println(temp1.title+" common: "+temp1.commonBorderCount);
    borderCounts[temp1.commonBorderCount]++;
  }  
  for (i=0;i<5;i++)
  {
    println("Border summary for ["+i+"]="+borderCounts[i]);
  }
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


void draw() {  
  int x,y,i;
  int tileIndex=0;
  background(255);
  int gx=0,gy=0;
  PictureTile currentTile=null;
  PictureTile destTile=null;

  String s;
      
  for (x=0;x<12;x++)
  {
    for (y=0;y<12;y++)
    {
      s=new String();
      gx=(x)*gsf*10;
      gy=(y)*gsf*10;
      
      currentTile=tiles.get(tileIndex);
      //println("Getting tile:"+tileIndex+" "+gx+","+gy+" "+x+","+y+" "+(gx+((gsf*10)/2))+","+(gy+((gsf*10)/2)));
      currentTile.updateGfx(gx,gy);

      s=Integer.toString(tileIndex);
      
      fill(200,200,200);

      circle(gx+((gsf*10)/2),gy+((gsf*10)/2),40); 
      fill(255,0,0);

      text(s,gx+((gsf*10)/2),gy+((gsf*10)/2));

      if (currentTile.commonBorderCount<5)
      //if (tileIndex==12)
      {
        currentTile.drawTile(gx,gy);
      }

      tileIndex++;
    }
  }
  

  tileIndex=0;
  stroke(255,0,255);
  strokeWeight(3);
  for (x=0;x<12;x++)
  {
    for (y=0;y<12;y++)
    {
      currentTile=tiles.get(tileIndex);
      //s=new String("["+currentTile.alNumber+"]");
      s=new String();


      for (i=0;i<4;i++)
      {
        if (currentTile.borderMatchIndex[i]>=0)
        {
          destTile=tiles.get(currentTile.borderMatchIndex[i]);
          s+=","+Integer.toString(currentTile.borderMatchIndex[i]);
          
          if (currentTile.commonBorderCount<5)
          {
            line(currentTile.gx,currentTile.gy,destTile.gx,destTile.gy);
          }
        }
      }
      
      //text(s,currentTile.gx+(gsf*10), currentTile.gy+(gsf*11));
      if (currentTile.commonBorderCount<5)
      {
        fill(255,0,0);
        text(s,currentTile.gx, currentTile.gy+(gsf*11));
      }

      tileIndex++;
    }
  }
  noLoop();
}


public class PictureTile
{
  String title;
  int tileNumberFromFile=0;
  int alNumber=-1;
  int[][] content=new int[10][10]; // looks like we can hard code the sizes here
  
  int[][] borders=new int[4][10];
  int[] borderMatchIndex = new int[4];
  int commonBorderCount=0;

  
  int gx=0;
  int gy=0;
  
  boolean locked=false;
  
  public int updateBorderCount()
  {
    int i=0;
    print("existing BC:"+commonBorderCount);
    commonBorderCount=0;
    for (i=0;i<4;i++)
    {
      if (borderMatchIndex[i]>=0)
      {
        commonBorderCount++;
      }
    }
    println("new BC:"+commonBorderCount);
    return(commonBorderCount);
  }
  
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
    print("F");
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
    print("R");
  }

  public void drawTile(int xoffset, int yoffset)
  {
    int x=0, y=0;

    for (y=0;y<10;y++)
    {
      for (x=0;x<10;x++)
      {
        if (commonBorderCount==2)
        {
          fill(0,0,255);
        }
        else if (commonBorderCount==3)
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
    int i=0;
    for (i=0;i<4;i++)
    {
      borderMatchIndex[i]=-1;
    }
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

  public boolean justCheckBorders(PictureTile t)
  {
    int i=0;

    for (i=0;i<4;i++)
    {
      if (checkBorders(t)==true)
      {
        return(true);
      }
    }    
    return(false);
  }  

  // transform the tile and test to see if any borders match
  public boolean transformToAlignWith(PictureTile t)
  {
    boolean commonBordersFound=false;

print("xform:");

    // Rotate through 360 degrees, testing each combo at 90
    // if we find a solution we return, if we dont then the
    // tile will return to its original position
    commonBordersFound=rotateAndCheck(t);
    if (commonBordersFound==true)
    {
      println(commonBordersFound);
      return(commonBordersFound);
    }
    
    // If none of the original rotations work, lets flip
    // the tile and try again
    flipTileVert();
    
    // Run through a series of rotations again, same deal
    // as before.
    commonBordersFound=rotateAndCheck(t);
    if (commonBordersFound==true)
    {
      println(commonBordersFound);
      return(commonBordersFound);
    }
    
    // If we get to here, then we're out of permutations,
    // flip the tile back to its original orientation - should
    // actuall be irrelevent for the code, but just leaves us in
    // a steady state and easier to debug
    flipTileVert();
    
    return(false);
  }
  
  public boolean rotateAndCheck(PictureTile t)
  {
    int i=0;
    boolean result=false;

    // Rotate for 4 turns of 90 degrees
    for (i=0;i<4;i++)
    {
      // check to see if any of the current
      // borders match
      if (checkBorders(t)==true)
      {
        result=true;
      }
      
      // no match yet - so rotate and repeat
      rotateRight90();      
    }    
    return(result);
  }

  // Check for adjacent tiles that have a common border pattern,
  // check left, right, below and above.
  public boolean checkBorders(PictureTile t)
  {
    boolean result=false;
    // See if this pair of tiles align on any cardinal edges
    //borders[0][i]=content[0][i]; // left border
    //borders[1][i]=content[9][i]; // right border
    //borders[2][i]=content[i][0]; // top border
    //borders[3][i]=content[i][9]; // bottom border  

    // Left v Right      
    if (borderMatch(borders[0],t.borders[1])==true)
    {
      borderMatchIndex[0]=t.alNumber;
      t.borderMatchIndex[1]=this.alNumber;
      // we are to the left of t
      result=true;
    }
    // Right v Left
    if (borderMatch(borders[1],t.borders[0])==true)
    {
      borderMatchIndex[1]=t.alNumber;
      t.borderMatchIndex[0]=this.alNumber;
      // we are to the right of t
      result=true;
    }
    // top v Bottom
    if (borderMatch(borders[2],t.borders[3])==true)
    {
      borderMatchIndex[2]=t.alNumber;
      t.borderMatchIndex[3]=this.alNumber;
      // we are below t
      result=true;
    }
    // Bottom v Top
    if (borderMatch(borders[3],t.borders[2])==true)
    {
      borderMatchIndex[3]=t.alNumber;
      t.borderMatchIndex[2]=this.alNumber;
      // we are above t
      result=true;
    }
    
    return(result);
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
