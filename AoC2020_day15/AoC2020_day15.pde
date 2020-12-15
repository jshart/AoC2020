import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day14_part2\\data");

ArrayList<String> lines = new ArrayList<String>();
int numLines=0;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];

HashMap<Integer, History> memoryMap = new HashMap<Integer, History>();

int[] input={1,2,16,19,18,0};

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  
  int inputLen=input.length;
  int turn=0;
  int numberToAdd=0, lastNumberAdded=0;
  History temp=null;
  boolean newNumber=true;
  
  
  // Initialise list
  for (turn=0;turn<inputLen;turn++)
  {
    updateMap(input[turn],turn);

    println("T:"+(turn+1)+" N:"+input[turn]);

    numberToAdd=input[turn];
  }
  while (turn<30000000)
  {
    // has the number been spoken before?
    if (newNumber==true)
    {
      // never been spoken before
      numberToAdd=0;
    }
    else
    {
      // Seen before, so lets work out the number based on when it was last seen
      numberToAdd=numberDelta(lastNumberAdded);
    }
    newNumber=updateMap(numberToAdd,turn);
    lastNumberAdded=numberToAdd;
    
    println("T:"+(turn+1)+" N:"+numberToAdd);
    
    turn++;
  }
}

int numberDelta(int lastNumberAdded)
{
  History h=memoryMap.get(lastNumberAdded);
  int d=h.lastSpoken()-h.lastSpokenButOne();
  return(d);
}

boolean updateMap(int n, int turn)
{
  History h;
  boolean newNumber=false;
  
  h=memoryMap.get(n);
  
  if (h==null)
  {
    h=new History(turn);
    memoryMap.put(n,h);
    newNumber=true;
  }
  else
  {
    h.position.add(turn);
    newNumber=false;
  }

  //int i=0,l=0;
  //l=h.position.size();
  //for (i=0;i<l;i++)
  //{
  //  print("#"+h.position.get(i));
  //}
  
  return(newNumber);
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

public class History
{
  ArrayList<Integer> position=new ArrayList<Integer>();
  
  public History(int h)
  {
    position.add(h);
  }
  public int lastSpoken()
  {
    int l=position.size();
    return(position.get(l-1));
  }
  public int lastSpokenButOne()
  {
    int l=position.size();
    return(position.get(l-2));
  }
}
