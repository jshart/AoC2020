import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day13_part2\\data");

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
    
    //File fl = new File(filebase+File.separator+"input3.txt");
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
  int max=0;
  int maxIndex=0;
  BusRun temp;
  BusRun longestDuration=null;
  for (i=0;i<count;i++)
  {
    println("B:"+busSlots[i]);
    if (busSlots[i].charAt(0)!='x')
    {
      temp=new BusRun(Integer.parseInt(busSlots[i]),i);
      busList.add(temp);
      
      if (temp.busInterval>max)
      {
        max=temp.busInterval;
        maxIndex=busList.size();
        longestDuration=busList.get(maxIndex-1);
      }
    }
  }
  
  busCount=busList.size();
  for (i=0;i<busCount;i++)
  {
     busList.get(i).printBus();
  }
  
  println("MAX Int="+max+" at index="+maxIndex);
  
  //long checkValue=1000000;
  //long checkValue=0;
  long checkValue=780601154790000L;
  boolean found=false;
  boolean allMatch=true;
  long incValue=1;
  int sample=0;
  

  while(found==false)
  {

    // jump to possible entries only, based on looking for a match against the longest interval
    if ((checkValue + longestDuration.delta) % (longestDuration.busInterval)==0)
    {
      //print(".");
      if (sample>100000)
      {
        println("CV="+checkValue);
        sample=0;
      }
      sample++;
      // lets be positive and assume everything matches. as soon as we find a single
      // value that doesnt match we can bail this loop.
      allMatch=true;
      
      // Candidate Found - check if all the others match at this location
      for (i=0;i<busCount && allMatch==true;i++)
      {
          temp=busList.get(i);

          if (((checkValue + temp.delta) % temp.busInterval)!=0)
          {
            // any remainder and this is a failed match
            allMatch=false;
          }
      }
      // complete match found
      if (allMatch==true)
      {
        println("CV="+checkValue);
        found=true;
      }
      incValue=longestDuration.busInterval;
    }
    checkValue+=incValue;
  }
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
  public int busInterval=0;
  public int busTime=0;
  public int delta=0;
  
  public BusRun(int i,int d)
  {
    busInterval=i;
    delta=d;
  }
  
  public void printBus()
  {
    print("BI="+busInterval+" BD="+delta);
    println();
  }
}
