import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day12\\data");

ArrayList<String> lines = new ArrayList<String>();
ArrayList<Instruction> insList = new ArrayList<Instruction>();
int numLines=0;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];

int sizeX=1400;
int sizeY=1400;

Boat ferry = new Boat();

void setup() {
  size(1400, 1400);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));



  try {
    String line;
    
    //File fl = new File(filebase+File.separator+"input2.txt");
    File fl = new File(filebase+File.separator+"input.txt");

    FileReader frd = new FileReader(fl);
    BufferedReader brd = new BufferedReader(frd);
  
    while ((line=brd.readLine())!=null)
    {
      println("loading:"+line);
      
      if (line.length()!=0)
      {
        lines.add(line);
        insList.add(new Instruction(line));
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }
  
  numLines=insList.size();

  int i=0;
  for (i=0;i<numLines;i++)
  {
    insList.get(i).print();
  }
}


void draw() {  
  if (ferry.pc>=numLines)
  {
    noLoop();
    return;
  }
  else
  {
    //background(0);
    //stroke(255);
  
    stroke(255,0,0);
    ferry.update(insList.get(ferry.pc));
    line(ferry.oldX,ferry.oldY,ferry.x,ferry.y);
    ferry.printBoat();
  }
  //for (x=0;x<noCols;x++)
  //{
  //  for (y=0;y<noLines;y++)
  //  {
  //    if (state1Active==true)
  //    {
  //      currentCell=state1[x][y];
  //    }
  //    else
  //    {
  //      currentCell=state2[x][y];
  //    }
      
  //    if (currentCell>=1)
  //    {
  //      stroke(255,0,0);
  //      fill(255,255,255);
  //      rect(xoffset+(x*cellSize),yoffset+(y*cellSize),cellSize,cellSize);
  //      seats++;
  //    }
  //    if (currentCell==2)
  //    {
  //      stroke(0,244,0);
  //      fill(0,244,0);
  //      circle(xoffset+(x*cellSize)+(cellSize/2),yoffset+(y*cellSize)+(cellSize/2),cellSize);
  //      people++;
  //    }
  //  }
  //}

}

public class Instruction
{
  char command;
  int value;
  
  public Instruction(String s)
  {
    command=s.charAt(0);
    value=Integer.parseInt(s.substring(1));
  }
  
  public void print()
  {
    println("C="+command+" V="+value);
  }
}

public class Boat
{
  int startX=sizeX/2;
  int startY=sizeY/2;
     
  int oldX=startX;
  int oldY=startY;
  
  int orientation=90; // start facing east - always
  int x=startX;
  int y=startY;

  
  int pc=0;
  
  public Boat()
  {
  }
  
  public void update(Instruction ins)
  {
    oldX=x;
    oldY=y;
    
    switch (ins.command)
    {
      case 'N':
        y-=ins.value;
        break;
      case 'S':
        y+=ins.value;
        break;
      case 'E':
        x+=ins.value;
        break;
      case 'W':
        x-=ins.value;
        break;
      case 'L':
        orientation-=ins.value;
        if (orientation<0)
        {
          orientation+=360;
        }
        break;
      case 'R':
        orientation+=ins.value;
        if (orientation>360)
        {
          orientation-=360;
        }
        break;
      case 'F':
        switch (orientation)
        {
          case 90:
            x+=ins.value;
            break;
          case 180:
            y+=ins.value;
            break;
          case 270:
            x-=ins.value;
            break;
          case 0:
          case 360:
            y-=ins.value;
            break;
        }
      break;
    }
    
    pc++;
  }
  
  void printBoat()
  {
    int m=0;
    print("PC="+pc+" of "+numLines);
    print(" O="+orientation+" X="+x+" Y="+y);
    // manhatten distance
    m=abs(x-startX)+abs(y-startY);
    println(" M="+m);
  }
}
