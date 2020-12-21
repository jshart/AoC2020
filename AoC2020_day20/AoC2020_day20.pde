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


InputFile input = new InputFile("input.txt");
ArrayList<PictureTile> tiles = new ArrayList<PictureTile>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  input.printFile();
  parseFile();
  
  int i=0,j=0;
  PictureTile temp1, temp2;

  println("Tile count:"+tiles.size()+" picture size? "+Math.sqrt((double)i));
  for (i=0;i<tiles.size();i++)
  {
    temp1=tiles.get(i);
    temp1.printTile();
  }
  
  int borders=0;
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
  
        borders=temp1.commonBorders(temp2);
        
        if (borders!=0)
        {
          println("["+temp1.title+"] has ["+borders+"] common with ["+temp2.title+"]");
          temp1.commonBorderCount++;
        }
      }
    }
  }
  
  long total=1;
  for (i=0;i<tiles.size();i++)
  {
    temp1=tiles.get(i);
    println(temp1.title+" has "+temp1.commonBorderCount);
    
    if (temp1.commonBorderCount==2)
    {
      total*=temp1.tileNumber;
    }
  }
  println("final count="+total);
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
      temp.tileNumber=Integer.parseInt(s.substring(5,s.length()-1));
      println("Tile number calculated to ="+temp.tileNumber);

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


}


public class PictureTile
{
  String title;
  int tileNumber=0;
  int[][] content=new int[10][10]; // looks like we can hard code the sizes here
  
  int[][] borders=new int[8][10];
  
  int commonBorderCount=0;
  
  public PictureTile()
  {
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
  }
  
  public int commonBorders(PictureTile t)
  {
    int i=0,j=0;;
    int count=0;
    
    // check every border in this tile...
    for (i=0;i<8;i++)
    {
      // ... against every border in the target tile
      for (j=0;j<8;j++)
      {
        // count how many match
        count+=borderMatch(this.borders[i], t.borders[j]);
      }
    }
    return(count);
  }
  
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
