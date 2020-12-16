import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day16\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();

InputFile fieldContents = new InputFile("fields.txt");
ArrayList<FieldConstraints> fConstraints = new ArrayList<FieldConstraints>();

InputFile myticketContents = new InputFile("myticket.txt");
InputFile nearbyticketsContents = new InputFile("nearbytickets.txt");

ArrayList<Integer> invalidNumbers = new ArrayList<Integer>();
ArrayList<ValidTicket> vTickets = new ArrayList<ValidTicket>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  fieldContents.printFile();
  myticketContents.printFile();
  nearbyticketsContents.printFile();
  
  int i=0,j=0,k=0;
  
  for (i=0;i<fieldContents.numLines;i++)
  {
    fConstraints.add(new FieldConstraints(fieldContents.lines.get(i)));
  }
  
  println();
  String currentTicket;
  for (i=0;i<nearbyticketsContents.numLines;i++)
  {
    currentTicket=nearbyticketsContents.lines.get(i);
    println("checking line..."+currentTicket);
    if (checkInvalidNumbers(currentTicket)==false)
    {
      println("Ticket "+i+" consisting of ["+currentTicket+"] is invalid and should be dropped");
    }
    else
    {
      vTickets.add(new ValidTicket(currentTicket));
    }
  }
  
  println();
  int total=0;
  for (i=0;i<invalidNumbers.size();i++)
  {
    total+=invalidNumbers.get(i);
    println("Adding Invalid Nunber:"+invalidNumbers.get(i)+" new total="+total);
  }
  
  boolean match;
  for (k=0;k<fConstraints.size();k++)
  {
    // check all fields...
    for (i=0;i<fConstraints.size();i++)
    {
      
      // lets assume this is valid until proven otherwise.
      match=true;
      
      
      // for each ticket...
      for (j=0;j<vTickets.size()&&match==true;j++)
      {
        // FIRST value - lets see if we can find a constriant that matches
        match=fConstraints.get(i).validNumber(vTickets.get(j).contents[k]);
      }
      
      if (match==true)
      {
        println("Field:"+k+" matched constraint="+i);
        fConstraints.get(i).candidateList.add(k);
      }
    }
  }
  
  FieldConstraints tempf;
  
  println("CANDIDATE LIST:");
  for (k=0;k<fConstraints.size();k++)
  {
    tempf=fConstraints.get(k);
    print(tempf.name+": ");
    for (j=0;j<tempf.candidateList.size();j++)
    {
      print(tempf.candidateList.get(j)+",");
    }
  }
  
  println();
  
  // Prune candidates
  boolean done=false;
  
  int removeItem=-1;
  while (done==false)
  {
    done=true;
    
    // check for any candidate lists that are only 1 long - as that should be locked in
    for (k=0;k<fConstraints.size();k++)
    {
      tempf=fConstraints.get(k);
      
      // only one item - this must be locked in.
      if (tempf.candidateList.size()==1)
      {
        if (tempf.confirmed==false)
        {
          tempf.confirmed=true;
          println("LOCKING IN:"+tempf.name+" V:"+tempf.candidateList.get(0));
          
          // first time this one was locked in, so lets now go and remove this everywhere
          removeItem=tempf.candidateList.get(0);
          break;
        }
      }
    }
    
    // check for any lists we can prune
    for (k=0;k<fConstraints.size();k++)
    {
      tempf=fConstraints.get(k);

      if (removeItem>=0)
      {
        for (j=0;j<tempf.candidateList.size();j++)
        {
          if (tempf.candidateList.get(j)==removeItem && (tempf.candidateList.size()!=1 && tempf.confirmed==false))
          {
            tempf.candidateList.remove(j);
            println("pruning:"+removeItem);
            
            // still pruning so not yet done.
            done=false;
          }
        }
      }
    }
  }
  
  println("DONE");
  ValidTicket myticket = new ValidTicket(myticketContents.lines.get(0));
  for (k=0;k<fConstraints.size();k++)
  {
    tempf=fConstraints.get(k);
    println(tempf.name+" maps to field="+tempf.candidateList.get(0)+" with a value of:"+myticket.contents[tempf.candidateList.get(0)]);
  }
  
}

boolean checkInvalidNumbers(String line)
{
  int i=0,j=0;
  String[] temp;
  temp=line.split(",");
  int l = temp.length;

  
  int numConstraints=fConstraints.size();
  boolean valid=false;
  int checkNum=0;
  
  // check each number in the ticket...
  for (i=0;i<l;i++)
  {
    valid=false;
    checkNum=Integer.parseInt(temp[i]);
    
    //println("-- Checking Number:"+checkNum);
    
    // ... against each constraint
    for (j=0;j<numConstraints && valid==false;j++)
    {
      valid=fConstraints.get(j).validNumber(checkNum);
    }
    
    // if its *still* invalid after each constraint check, then track it as part of our answer
    if (valid==true)
    {
      println("\\-- VALID NUMBER FOUND:"+checkNum);
    }
    else
    {
      invalidNumbers.add(checkNum);
      println("\\-- INVALID NUMBER FOUND:"+checkNum);
      return(false);
    }
  }
  return(true);
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

public class ValidTicket
{
  int[] contents;
  
  public ValidTicket(String s)
  {
    String[] temp;
    int l;
    temp = s.split(",");
    l=temp.length;
    
    contents = new int[l];
    int i=0;
    for (i=0;i<l;i++)
    {
      contents[i]=Integer.parseInt(temp[i]);
    }
  }
  
}

public class FieldConstraints
{
  public String name;
  public int[] sRange;
  public int[] eRange;
  public int ranges;
  
  public ArrayList<Integer> candidateList = new ArrayList<Integer>();
  public boolean confirmed=false;
  
  public FieldConstraints(String line)
  {
    String[] temp;
    String[] temp2;
    String remainder;
    temp=line.split(": ");
    name=temp[0];
    remainder=temp[1];
    
    
    temp=remainder.split(" or ");
    ranges=temp.length;
    int i;
    
    sRange = new int[ranges];
    eRange = new int[ranges];
    for (i=0;i<ranges;i++)
    {
      temp2=temp[i].split("-");
      //print("RV:"+temp2[0]+","+temp2[1]);
      sRange[i]=Integer.parseInt(temp2[0]);
      eRange[i]=Integer.parseInt(temp2[1]);
    }
  }
  
  boolean validNumber(int v)
  {
    int i=0;
    boolean valid=false;
    for (i=0;i<ranges;i++)
    {
      //print("C="+sRange[i]+":"+eRange[i]);
      if (v>=sRange[i] && v<=eRange[i])
      {
        valid=true;
        break;
      }
      else
      {
        valid=false;
      }

    }
    //print("R:"+valid);
    return(valid);
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
