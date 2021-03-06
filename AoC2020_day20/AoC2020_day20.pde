import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day20\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();



// TODO - suspected logic?
// 1) record *which* borders caused a match with each tile
// 2) starting with a corner, assume it is top lef and "walk" in the positive x axis
//    along each adjacent tile recorded as sharing a border in turn (i.e. along
//    an "edge".
// 3) Align each tile on edge, such that unused common borders are projecting on x+ and y+
// 4) repeat for each row - each subsequent row will already have some consumed links, which
//    force the remaining links into a certain configuration

// TODO - build rotation/flip logic for tiles - ultimately we have to re-orientate each
// tile to its correct placement, so we may as well get that done and remove the complexity
// of trying to envisage how the current border short cuts map to the actual tile positions.


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
  
  
  //TODO - iterate on this code flipping tiles until we dont get any matches for inverted...
  // - flip for any tile where inverse matches are greater than regular matches?
  // - flip only for tiles where the regular match is zero? and repeat?

  
  int borders=0;
  int flipped=1;
   
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
        
        //println("Checking ["+temp1.title+"] with ["+temp2.title+"]");
  
        //borders=temp1.commonBorders(temp2,j);
        if (temp2.locked==false)
        {
          borders=temp1.transformToAlign(temp2,j);
        }
        
        if (borders!=0)
        {
          //println("["+temp1.title+"] has ["+borders+"] common with ["+temp2.title+"]");
          temp1.neighbours.add(temp2);
          temp1.neighboursIndex.add(j);
          temp1.commonBorderCount++;
        }
      }
    }
  }
  
  for (i=0;i<tiles.size();i++)
  {
    temp1=tiles.get(i);
    
    println(temp1.title+" common: "+temp1.commonBorderCount+" regular:"+temp1.regularBorderCount+" inverse:"+temp1.invertedBorderCount);

    //if (temp1.invertedBorderCount>temp1.regularBorderCount)
    //{
    //  temp1.flipTileVert();
    //  flipped++;
    //}
    //temp1.commonBorderCount=0;
    //temp1.regularBorderCount=0;
    //temp1.invertedBorderCount=0;
  }
  //println("Flipped:"+flipped);
  
  
  //long total=1;
  //for (i=0;i<tiles.size();i++)
  //{
  //  temp1=tiles.get(i);
  //  println(temp1.title+" common: "+temp1.commonBorderCount+" regular:"+temp1.regularBorderCount+" inverse:"+temp1.invertedBorderCount);
    
  //  if (temp1.commonBorderCount==2)
  //  {
  //    total*=temp1.tileNumber;
  //  }
  //}
  //println("final count="+total);

  //tiles.get(0).printTile();
  //tiles.get(0).flipTileVert();
  //println();
  //tiles.get(0).printTile();
  //tiles.get(0).rotateRight90();
  //println();
  //tiles.get(0).printTile();
  
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
      gx=x*gsf*10;
      gy=y*gsf*10;
      currentTile=tiles.get(tileIndex);
      currentTile.updateGfx(gx,gy);
      if (currentTile.commonBorderCount<3)
      //if (tileIndex==12)
      {
        currentTile.drawTile(gx,gy);
      }
      else
      {
        s=Integer.toString(tileIndex);
        text(s,gx+10,gy-10);
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
      s=new String();
      currentTile=tiles.get(tileIndex);
      for (i=0;i<8;i++)
      {
        if (currentTile.borderMatchIndex[i]!=0)
        {
          destTile=tiles.get(currentTile.borderMatchIndex[i]);
          s+=","+Integer.toString(currentTile.borderMatchIndex[i]);
          
          if (currentTile.commonBorderCount<3)
          {
            line(currentTile.gx,currentTile.gy,destTile.gx,destTile.gy);
          }
        }
      }
      text(s,currentTile.gx+(gsf*10), currentTile.gy+(gsf*11));

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
  
  int[][] borders=new int[8][10];
  int[] borderMatchIndex = new int[8];
  
  int commonBorderCount=0;
  int regularBorderCount=0;
  int invertedBorderCount=0;
  
  int gx=0;
  int gy=0;
  
  boolean locked=false;
  
  // TODO - I think I need to associate this with the *actual* borders, so I have some concept of which
  // border connects to which tile.
  ArrayList<PictureTile> neighbours = new ArrayList<PictureTile>();
  ArrayList<Integer> neighboursIndex = new ArrayList<Integer>();
  
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
    
    // now reverse the borders to deal with the rotations
    for (i=0;i<10;i++)
    {
      borders[4][i]=borders[0][9-i]; // left border (inverted)
      borders[5][i]=borders[1][9-i]; // right border (inverted)
      borders[6][i]=borders[2][9-i]; // top border (inverted)
      borders[7][i]=borders[3][9-i]; // bottom border (inverted)
    }
    //printBorders();
  }
  
  public int transformToAlign(PictureTile t, int tileIndex)
  {
    int commonBordersFound=0;
    //locked=true;

    commonBordersFound=rotateAndCheck(t,tileIndex);
    if (commonBordersFound>0)
    {
      return(commonBordersFound);
    }
    flipTileVert();
    commonBordersFound=rotateAndCheck(t,tileIndex);
    return(commonBordersFound);
  }
  
  public int rotateAndCheck(PictureTile t, int tileIndex)
  {
    int i=0;
    int commonBordersFound=0;


    for (i=0;i<4;i++)
    {
      commonBordersFound=checkBorders(t,tileIndex);  
      if (commonBordersFound>0)
      {
        return(commonBordersFound);
      }
      rotateRight90();      
    }    
    return(0);
  }

  public int checkBorders(PictureTile t, int tileIndex)
  {
    // See if this pair of tiles align on any cardinal edges
    //borders[0][i]=content[0][i]; // left border
    //borders[1][i]=content[9][i]; // right border
    //borders[2][i]=content[i][0]; // top border
    //borders[3][i]=content[i][9]; // bottom border  
          //temp1.neighbours.add(temp2);
          //temp1.neighboursIndex.add(j);
          //temp1.commonBorderCount++;
          
    if (borderMatch(borders[0],t.borders[1])>0)
    {
      borderMatchIndex[0]=tileIndex;
      
      // we are to the left of t
      return(1);
    }
    if (borderMatch(borders[1],t.borders[0])>0)
    {
      borderMatchIndex[1]=tileIndex;
      // we are to the right of t
      return(1);
    }
    if (borderMatch(borders[2],t.borders[3])>0)
    {
      borderMatchIndex[2]=tileIndex;
      // we are below t
      return(1);
    }
    if (borderMatch(borders[3],t.borders[2])>0)
    {
      borderMatchIndex[3]=tileIndex;
      // we are above t
      return(1);
    }
    return(0);
  }
  
  // TODO - change commonBorders so it is aware of the *index*
  // of the target tile (like we original thought) and update
  // the match logic below to associate it with that border.
  public int commonBorders(PictureTile t, int tileIndex)
  {
    int i=0,j=0;;
    int count=0;
    int matched=0;
    
    // check every *regular* border in this tile...
    for (i=0;i<4;i++)
    {
      // ... against every *regular* border in the target tile
      for (j=0;j<4;j++)
      {
        // count how many match
        matched=borderMatch(this.borders[i], t.borders[j]);
        if (matched>0)
        {
          borderMatchIndex[i]=tileIndex;          
        }
        regularBorderCount+=matched;
        count+=matched;
      }
    }
    // check every *inverted* border in this tile...
    for (;i<8;i++)
    {
      // ... against every *regular* border in the target tile
      for (j=0;j<4;j++)
      {
        // count how many match
        matched=borderMatch(this.borders[i], t.borders[j]);
        if (matched>0)
        {
          borderMatchIndex[i]=tileIndex;          
        }
        invertedBorderCount+=matched;
        count+=matched;
      }
    }
    
    return(count);
  }
  
  // This simply does a "string" style char by char match between the 2 border arrays
  public int borderMatch(int[] a, int[] b)
  {
    int i=0;
    for (i=0;i<10;i++)
    {
      // check every element in this border against every element in that border
      if (a[i]!=b[i])
      {
        // if any dont match, bail
        return(0);
      }
    } 
    // if we get here these element borders must match
    return(1);
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
    for (j=0;j<8;j++)
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
