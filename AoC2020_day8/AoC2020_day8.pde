import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day8\\data");

ArrayList<String> lines = new ArrayList<String>();
int inputLen=0;

int validPassports;

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

  ProgramCode bootCode = new ProgramCode(lines);
  
  int attempt=0;
  while (true)
  {
    println("ATTEMPT RUN:"+attempt);
    bootCode.resetCode();
    bootCode.instructions[attempt].flip();
    if (attempt>0)
    {
      bootCode.instructions[attempt-1].flip();
    }
    
    if (bootCode.execute()==true)
    {
      break;
    }
    attempt++;
  }
}

void draw() {
  noLoop();
}

public class OpCode
{
  String instruction;
  int param;
  int hitCount;
  boolean invertInstruction=false;
  
  public OpCode(String s, int p)
  {
    instruction=s;
    param=p;
    hitCount=0;
  }
  
  void print(String s)
  {
    println(s+" OPCODE=["+instruction+"] param=["+param+"] hitCount=["+hitCount+"]");
  }
  
  String getInstruction()
  {
    if (invertInstruction==false)
    {
      return(instruction);
    }
    else
    {
      print(" INVERTED ");
      if (instruction.equals("jmp"))
      {
        print(" JMP TO NOP");
        return("nop");
      }
      if (instruction.equals("nop"))
      {
        print(" NOP TO JMP");
        return("jmp");
      }      
    }
    
    return(instruction);
  }
  
  void flip()
  {
    invertInstruction=!invertInstruction;
  }
}

public class ProgramCode
{
  OpCode[] instructions;
  int pc=0;
  int acc=0;

  
  public ProgramCode(ArrayList<String> inputCode)
  {
    
    inputLen=inputCode.size();
     
    int j=0;
    
    instructions = new OpCode[inputLen];
    
    println("program length=["+inputLen+"]");
    
    for (j=0;j<inputLen;j++)
    {
      String[] temp=lines.get(j).split(" ");
      instructions[j]=new OpCode(temp[0],Integer.parseInt(temp[1]));
      instructions[j].print("PARSING");
    }
  }
  
  public void resetCode()
  {
    int j=0;
    for (j=0;j<inputLen;j++)
    {
      instructions[j].hitCount=0;
    }
    pc=0;
    acc=0;
  }
  
  public boolean execute()
  {
    while (pc<inputLen)
    {
      instructions[pc].hitCount++;
      instructions[pc].print("EXECUTING PC=["+pc+"]");

      
      if (instructions[pc].getInstruction().equals("nop"))
      {
        // no op - do nothing other than move to next instruction
        pc++;
      }
      else if (instructions[pc].getInstruction().equals("jmp"))
      {
         if (instructions[pc].hitCount>1)
        {
          println("SUSPECT INFINTE LOOP - final acc =["+acc+"]");
          return(false);
        }
        pc += instructions[pc].param;
      }
      else if (instructions[pc].getInstruction().equals("acc"))
      {

        acc += instructions[pc].param;
        
        pc++;
      }
      println();
      //println("PC=["+pc+"] ACC=["+acc+"]");
    }
    println("NORMAL EXECUTION EXIT, acc=["+acc+"]");
    return(true);
  }
  
  
  //public void printRecord()
  //{

  //}
  
  //public boolean validate()
  //{ 
 
  //}
}
