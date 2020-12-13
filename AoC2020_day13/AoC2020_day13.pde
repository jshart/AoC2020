import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day13\\data");

ArrayList<String> lines = new ArrayList<String>();
ArrayList<BusRun> busList = new ArrayList<BusRun>();
int numLines=0;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
String[] busSlots;
int targetTime=0;
int count=0;
int busCount=0;


void setup() {
  size(200, 200);
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
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }
  
  targetTime=Integer.parseInt(lines.get(0));
  busSlots=lines.get(1).split(",");
  count=busSlots.length;
 
  int i=0;
  for (i=0;i<count;i++)
  {
    println("B:"+busSlots[i]);
    if (busSlots[i].charAt(0)!='x')
    {
      busList.add(new BusRun(Integer.parseInt(busSlots[i])));
    }
  }
  println("TT:"+targetTime);
  
  boolean firstBus=true;
  int nextBusIndex=0;
  int nextBusTD=0;
  int temp=0;
  
  busCount=busList.size();
  for (i=0;i<busCount;i++)
  {
    temp=busList.get(i).printBus(targetTime);
    if (firstBus)
    {
      nextBusIndex=i;
      nextBusTD=temp;
      firstBus=false;
    }
    else
    {
      if (temp<nextBusTD)
      {
        nextBusIndex=i;
        nextBusTD=temp;
      }
    }
  }
  
  println("Next bus index="+nextBusIndex+" time interval="+busList.get(nextBusIndex).busInterval+" timedelta="+nextBusTD);
  println("ANSWER="+(busList.get(nextBusIndex).busInterval * nextBusTD));
}


void draw() {  
  //if (ferry.pc>=numLines)
  //{
  //  noLoop();
  //  return;
  //}
  //else
  //{
  //  //background(0);
  //  //stroke(255);
  
  //  stroke(255,0,0);
  //  ferry.update(insList.get(ferry.pc));
  //  line(ferry.oldX,ferry.oldY,ferry.x,ferry.y);
  //  ferry.printBoat();
  //}
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


public class BusRun
{
  int busInterval=0;
  int busTime=0;
  
  public BusRun(int i)
  {
    busInterval=i;
  }
  
  public int printBus(int tt)
  {
    int timeDelta=tt % busInterval;
    int lastBus=tt-timeDelta;
    int nextBus=lastBus+busInterval;
    
    print("BI="+busInterval+" BT="+busTime);
    print(" TD="+timeDelta+" LB="+lastBus+" NB="+nextBus+" rv="+(nextBus-tt));
    println();
    return(nextBus-tt);
  }
}
