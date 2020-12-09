import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day9\\data");

ArrayList<String> lines = new ArrayList<String>();
int inputLen=0;

long[] inputNumbers;

ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];

ArrayList<Long> additionList = new ArrayList<Long>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));



  try {
    String line;
    
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

  inputLen=lines.size();
  
  inputNumbers=new long[inputLen];
  
  // convert the strings to numbers
  int i=0,j=0,k=0;
  for (i=0;i<inputLen;i++)
  {
    inputNumbers[i] = Long.parseLong(lines.get(i));
  }
  
  int windowStart=0;
  int windowEnd=25;
  long candidateNumber=inputNumbers[windowEnd];
  long invertedNumber;
  boolean matchFound=false;
  
  // build initial inverted preamble;
  for (i=windowStart;i<windowEnd;i++)
  {
    invertedNumbers.add(candidateNumber-inputNumbers[i]);
  }
  
  println("Inverted Preamble built size=["+invertedNumbers.size()+"]");
  
  // Each iteration move the window on by one
  for (i=windowEnd;i<inputLen;i++,windowStart++,windowEnd++)
  {
    // Assume we have no match to start with
    matchFound=false;
    
    // Check if any of the invertedNumbers are in the window - if so, it indicates a match, if not, we've found
    // a number of interest
    for (j=0;j<25 && matchFound==false;j++)
    {
      // Fetch current inverted number
      invertedNumber=invertedNumbers.get(j);
      
      // search through previous 25 elements in the window
      for (k=windowStart;k<windowEnd && matchFound==false;k++)
      {
        // Match found!
        if (inputNumbers[k]==invertedNumber)
        {
          println("match found for C=["+candidateNumber+"]");
          matchFound=true;
          break;
        }
      }
    }
    if (matchFound==false)
    {
      println("NO match found for C=["+candidateNumber+"]");
      for (k=windowStart;k<windowEnd;k++)
      {
        println(" input="+inputNumbers[k]+" inverted=["+invertedNumbers.get(k-windowStart)+"]");
      }
      break;
    }
    
    // update preamble;
    //candidateNumber=inputNumbers[windowEnd+1];
    //invertedNumbers.remove(0);
    //invertedNumbers.add(candidateNumber-inputNumbers[windowEnd]);
    //println("Updating inverted preamble, adding ["+(candidateNumber-inputNumbers[windowEnd])+"]");
    
    candidateNumber=inputNumbers[windowEnd+1];
    invertedNumbers.clear();
    int m;
    for (m=windowStart+1;m<windowEnd+1;m++)
    {
      invertedNumbers.add(candidateNumber-inputNumbers[m]);
    }
  }
  
  println("NOW SEARCHING FOR "+candidateNumber);
  
  long currentTotal=0;
  // Loop through all the numbers
  for (i=0;i<inputLen;i++)
  {
    // Start adding numbers to the additionList until it exceeds our target
    additionList.add(inputNumbers[i]);
    println("... Adding "+inputNumbers[i]);
    
    currentTotal=sum(additionList);

    if (currentTotal>candidateNumber)
    {
      // prune from the start until we meet the criteria;
      while (currentTotal>candidateNumber && additionList.size()>0)
      {

        println("CurrentTotal=["+currentTotal+"] candidateNumber=["+candidateNumber+"]... Removing "+additionList.get(0));
        additionList.remove(0);
        currentTotal=sum(additionList);
      }
    }
    
    if (currentTotal==candidateNumber)
    {
      println("Current List match");
      printList(additionList);
      break;
    }
  }
}

long sum(ArrayList<Long> inputNumbers)
{
  long runningTotal=0;
  int len=inputNumbers.size();
  int i=0;
  
  for (i=0;i<len;i++)
  {
    runningTotal+=inputNumbers.get(i);
  }
  return(runningTotal);
}

void printList(ArrayList<Long> inputNumbers)
{
  int len=inputNumbers.size();
  int i=0;
  long l=inputNumbers.get(0),h=0;
  long num;
  
  for (i=0;i<len;i++)
  {
    num=inputNumbers.get(i);
    if (num>h)
    {
      h=num;
    }
    if (num<l)
    {
      l=num;
    }
    println("F="+num+ " l="+l+" h="+h);
  }
  
  println("Answer="+(l+h));
}

void draw() {
  noLoop();
}

//public class OpCode
//{
//  String instruction;
//  int param;
//  int hitCount;
//  boolean invertInstruction=false;
  
//  public OpCode(String s, int p)
//  {
//    instruction=s;
//    param=p;
//    hitCount=0;
//  }
  
//  void print(String s)
//  {
//    println(s+" OPCODE=["+instruction+"] param=["+param+"] hitCount=["+hitCount+"]");
//  }
  
//  String getInstruction()
//  {
//    if (invertInstruction==false)
//    {
//      return(instruction);
//    }
//    else
//    {
//      print(" INVERTED ");
//      if (instruction.equals("jmp"))
//      {
//        print(" JMP TO NOP");
//        return("nop");
//      }
//      if (instruction.equals("nop"))
//      {
//        print(" NOP TO JMP");
//        return("jmp");
//      }      
//    }
    
//    return(instruction);
//  }
  
//  void flip()
//  {
//    invertInstruction=!invertInstruction;
//  }
//}

//public class ProgramCode
//{
//  OpCode[] instructions;
//  int pc=0;
//  int acc=0;

  
//  public ProgramCode(ArrayList<String> inputCode)
//  {
    
//    inputLen=inputCode.size();
     
//    int j=0;
    
//    instructions = new OpCode[inputLen];
    
//    println("program length=["+inputLen+"]");
    
//    for (j=0;j<inputLen;j++)
//    {
//      String[] temp=lines.get(j).split(" ");
//      instructions[j]=new OpCode(temp[0],Integer.parseInt(temp[1]));
//      instructions[j].print("PARSING");
//    }
//  }
  
//  public void resetCode()
//  {
//    int j=0;
//    for (j=0;j<inputLen;j++)
//    {
//      instructions[j].hitCount=0;
//    }
//    pc=0;
//    acc=0;
//  }
  
//  public boolean execute()
//  {
//    while (pc<inputLen)
//    {
//      instructions[pc].hitCount++;
//      instructions[pc].print("EXECUTING PC=["+pc+"]");

      
//      if (instructions[pc].getInstruction().equals("nop"))
//      {
//        // no op - do nothing other than move to next instruction
//        pc++;
//      }
//      else if (instructions[pc].getInstruction().equals("jmp"))
//      {
//         if (instructions[pc].hitCount>1)
//        {
//          println("SUSPECT INFINTE LOOP - final acc =["+acc+"]");
//          return(false);
//        }
//        pc += instructions[pc].param;
//      }
//      else if (instructions[pc].getInstruction().equals("acc"))
//      {

//        acc += instructions[pc].param;
        
//        pc++;
//      }
//      println();
//      //println("PC=["+pc+"] ACC=["+acc+"]");
//    }
//    println("NORMAL EXECUTION EXIT, acc=["+acc+"]");
//    return(true);
//  }
  
  
  //public void printRecord()
  //{

  //}
  
  //public boolean validate()
  //{ 
 
  //}
//}
