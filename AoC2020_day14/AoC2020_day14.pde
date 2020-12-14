import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day14\\data");

ArrayList<String> lines = new ArrayList<String>();
int numLines=0;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];


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
  int max=0;
  int maxIndex=0;
  BusRun temp;

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
      }
    }
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


//public class BusRun
//{
//  public int busInterval=0;
//  public int delta=0;
  
//  public BusRun(int i,int d)
//  {
//    busInterval=i;
//    delta=d;
//  }
  
//  public void printBus()
//  {
//    print("BI="+busInterval+" BD="+delta);
//    println();
//  }
//}
