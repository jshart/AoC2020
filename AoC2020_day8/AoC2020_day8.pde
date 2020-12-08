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
  bootCode.execute();
  
}

void draw() {
  noLoop();
}

public class OpCode
{
  String instruction;
  int param;
  int hitCount;
  
  public OpCode(String s, int p)
  {
    instruction=s;
    param=p;
    hitCount=0;
  }
  
  void print(String s)
  {
    println(s+" OPCODE=["+instruction+"] param=["+param+"] hitCount=["+hitCount);
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
  
  public void execute()
  {
    while (pc<inputLen)
    {
      instructions[pc].hitCount++;
      instructions[pc].print("EXECUTING");

      
      if (instructions[pc].instruction.equals("nop"))
      {
        // no op - do nothing other than move to next instruction
        pc++;
      }
      else if (instructions[pc].instruction.equals("jmp"))
      {
        pc += instructions[pc].param;
      }
      else if (instructions[pc].instruction.equals("acc"))
      {
        if (instructions[pc].hitCount>1)
        {
          println("final ACC="+acc);
          return;
        }
        acc += instructions[pc].param;
        
        pc++;
      }
      
      println("PC=["+pc+"] ACC=["+acc+"]");
    }
  }
  
  
  //public void printRecord()
  //{

  //}
  
  //public boolean validate()
  //{ 
 
  //}
}
