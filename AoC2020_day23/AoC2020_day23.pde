import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day21\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
//InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<Integer> cups = new ArrayList<Integer>();

int[] input=new int[]{9,7,4,6,1,8,3,5,2}; // mydata
//int[] input=new int[]{3,8,9,1,2,5,4,6,7}; //example


void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  
  int turn=0,cupIndex=0,k=0;

  for (turn=0;turn<input.length;turn++)
  {
    println(input[turn]);
    cups.add(input[turn]);
  }
  
  int currentCupContents;
  int currentCupIndex=0;
  int targetDestinationContents=0;
  int[] next3=new int[3];
  
  // for each turn
  for (turn=0;turn<100;turn++)
  {
    println("*** Move:"+(turn+1));
   
    print("CL=");
    for (k=0;k<cups.size();k++)
    {
      if (k==currentCupIndex)
      {
        print("(");
      }
      print(cups.get(k)+",");
      if (k==currentCupIndex)
      {
        print(")");
      }
    }
    println();
    
    // grab the current cup
    currentCupContents=cups.get(currentCupIndex);
    
    // remove the 3 cups after 
    cupIndex=currentCupIndex+1;
    for (k=0;k<3;k++)
    {
      if (cupIndex>=cups.size())
      {
        cupIndex=0;
      }
      next3[k]=cups.get(cupIndex);
      cups.remove(cupIndex);
    }
      

    
    print("PU:");
    for (k=0;k<3;k++)
    {
      print(next3[k]+",");
    }
    println();
    print("RL=");
    for (k=0;k<cups.size();k++)
    {
      if (k==currentCupIndex)
      {
        print("(");
      }
      print(cups.get(k)+",");
      if (k==currentCupIndex)
      {
        print(")");
      }
    }
    println(); 
    
    

    
    // calculate the destination cup 
    targetDestinationContents=currentCupContents-1;
    println("Target Dest:"+targetDestinationContents);
    
    
    // find the actual destination cup
    boolean found=false;
    int destIndex=0;
    print("looking for dest contents:");
    while (found==false)
    {
      destIndex=cups.indexOf(targetDestinationContents);
      print(targetDestinationContents+",");
      if (destIndex>=0)
      {
        found=true;
      }
      else
      {
        targetDestinationContents--;
        if (targetDestinationContents<0)
        {
          targetDestinationContents=9; // HACK! I know this is the largest value in our input data, so Im being lazy and not searching
          // need to actually change this to be highest number in PU + 1.
        }
      }
    }
    println(" actual dest contents "+targetDestinationContents+" at *index*:"+destIndex);

    // want to add *after this index*
    destIndex++;
    
    // add to the end? or insert in the middle?
    if (destIndex>cups.size())
    {
      for (k=0;k<3;k++)
      {
        cups.add(next3[k]);
      }
    }
    else
    {
      if (destIndex<=currentCupIndex)
      {
        currentCupIndex+=3;
      }
      for (k=2;k>=0;k--)
      {
        cups.add(destIndex,next3[k]);
      }
      //if (destIndex<=currentCupIndex)
      //{
      //  currentCupIndex++;
      //}
    }
     
    print("NL=");
    for (k=0;k<cups.size();k++)
    {
      if (k==currentCupIndex)
      {
        print("(");
      }
      print(cups.get(k)+",");
      if (k==currentCupIndex)
      {
        print(")");
      }
    }
    println();

    
    // update current cup
    currentCupIndex++;
    if (currentCupIndex>=cups.size())
    {
      currentCupIndex=0;
    }
    
    println();
  }
  
  print("FINAL ANSWER: ");
  
  // RHS
  k=cups.indexOf(1)+1;  
  for (;k<cups.size();k++)
  {
    print(cups.get(k));
  }
  
  //LHS
  for (k=0;k<cups.indexOf(1);k++)
  {
    print(cups.get(k));
  }
  println();
}



void draw() {  

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
        println("loading:"+line);
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
