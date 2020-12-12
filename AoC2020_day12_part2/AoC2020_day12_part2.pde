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
  frameRate(20);

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
    insList.get(i).printInstruction();
    println();
  }
  
  stroke(255,0,0);
  line(ferry.oldX,ferry.oldY,ferry.x,ferry.y);
  stroke(0,255,0);
  circle(ferry.wpX,ferry.wpY,2);
}


void draw()
{  
  if (ferry.pc>=numLines)
  {
    noLoop();
    return;
  }

  //background(0);
  //stroke(255);
  
  ferry.update(insList.get(ferry.pc));
  stroke(255,0,0);
  line(ferry.oldX,ferry.oldY,ferry.x,ferry.y);
  stroke(0,255,0);
  circle(ferry.wpX,ferry.wpY,2);
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
  
  public void printInstruction()
  {
    print("C="+command+" V="+value);
  }
}

public class Boat
{
  int startX=sizeX/2;
  int startY=sizeY/2;
     
  int oldX=startX;
  int oldY=startY;
  
  int x=startX;
  int y=startY;

  int orientation=90; // start facing east - always
  int wpX=10; // starts 10 east, 1 north
  int wpY=-1;
  
  int pc=0;
  
  public Boat()
  {
  }
  
  public void update(Instruction ins)
  {
    int dx=0,dy=0;
    oldX=x;
    oldY=y;
    
    int rotations=0;
    int i=0;
    int tx=0,ty=0;
    
    switch (ins.command)
    {
      
      // Move waypoint by absoluate amount
      case 'N':
        wpY-=ins.value;
        break;
      case 'S':
        wpY+=ins.value;
        break;
      case 'E':
        wpX+=ins.value;
        break;
      case 'W':
        wpX-=ins.value;
        break;
        
        
      case 'L':
        switch (ins.value)
        {
          case 90:
            rotations=1;
            break;
          case 180:
            rotations=2;
            break;
          case 270:
            rotations=3;
            break;
        }
        for (i=0;i<rotations;i++)
        {
          tx=+wpY;
          ty=-wpX;
          wpX=tx;
          wpY=ty;
        }
        break;
      case 'R':
        switch (ins.value)
        {
          case 90:
            rotations=1;
            break;
          case 180:
            rotations=2;
            break;
          case 270:
            rotations=3;
            break;
        }
        for (i=0;i<rotations;i++)
        {
          tx=-wpY;
          ty=+wpX;
          wpX=tx;
          wpY=ty;
        }
        break;    
      case 'F':
        // Move to waypoint "value times"
       
        // move the boat to the new location, times the value of the instruction
        x+=wpX*ins.value;
        y+=wpY*ins.value;

      break;
    }
    printBoat(ins);
    pc++;
  }
  
  void printBoat(Instruction ins)
  {
    int m=0;
    ins.printInstruction();
    print(" PC="+pc+" of "+numLines);
    print(" O="+orientation+" X="+x+" Y="+y);
    print(" WPx="+wpX+" WPy="+wpY);
    // manhatten distance
    m=abs(x-startX)+abs(y-startY);
    println(" M="+m);
  }
}
