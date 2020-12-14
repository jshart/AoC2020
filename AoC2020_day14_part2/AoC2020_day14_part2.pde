import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day14_part2\\data");

ArrayList<String> lines = new ArrayList<String>();
int numLines=0;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];

Computer dockingComputer = new Computer();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));

  String[] temp;
  OpCode tempCode;
  int address=0;

  try {
    String line;
    
    File fl = new File(filebase+File.separator+"input2.txt");
    //File fl = new File(filebase+File.separator+"input.txt");

    FileReader frd = new FileReader(fl);
    BufferedReader brd = new BufferedReader(frd);
  
    while ((line=brd.readLine())!=null)
    {
      print("loading:"+line);
      
      if (line.length()!=0)
      {
        lines.add(line);
        temp=line.split(" = ");
        println("{"+temp[0]+"}{"+temp[1]+"}");
        if (temp[0].substring(0,3).equals("mem"))
        {
          address=Integer.parseInt(temp[0].substring(4,temp[0].length()-1));
          dockingComputer.updateMaxAddress(address);
          
          tempCode= new OpCode(temp[0].substring(0,3),address,Integer.parseInt(temp[1]));

        }
        else
        {
          tempCode= new OpCode(temp[0].substring(0,3),address,temp[1]);

        }
        tempCode.printOpCode();
        dockingComputer.opCodes.add(tempCode);
      }
    }
    brd.close();
    frd.close();

  } catch (IOException e) {
     e.printStackTrace();
  }
  
  println();
  
  boolean completed=false;
  dockingComputer.initRam();
  while (completed==false)
  {
    completed=dockingComputer.execute();
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

public class OpCode
{
  String command;
  int address=0;
  String mask;
  int value=0;

  char[][] expandedAddresses;
  
  public OpCode(String c, int a, String v)
  {
    command=c;
    address=a;
    mask=v;
  }
  
  public OpCode(String c, int a, int v)
  {
    command=c;
    address=a;
    value=v;
  }
  
  public void printOpCode()
  {
    if (command.equals("mem"))
    {
      println("C="+command+" A="+address+" v="+value);
    }
    else
    {
      println("C="+command+" A="+address+" M="+mask);
    }
  }
  
  public void expandAddress(int a, String m)
  {
      String binaryAddress;

      // update memory location based on bit mask
      binaryAddress=Integer.toBinaryString(a);
      println(binaryAddress);
      
      int maskLen=m.length();
      int i=0,j=0,l=0,k=0;
      char[] bits = new char[maskLen];
      
      // Convert the address to binary & right align to begin with
      for (i=maskLen-1;i>=0;i--)
      {
        j=i-(maskLen-binaryAddress.length());
        if (j>=0)
        {
          bits[i]=binaryAddress.charAt(j);
        }
        else
        {
          bits[i]='0';
        }
      }
      
      
      int xCount=0;
      // Replace any bit that is a '1' in the mask
      for (i=0;i<maskLen;i++)
      {
        if (m.charAt(i)=='1')
        {
          bits[i]='1';
        } 
        else if (m.charAt(i)=='X')
        {
          xCount++;
        }
      }
      
      int combos=(int)Math.pow(2,xCount);
      // expand strings where wildcard "X" is found
      println(xCount+" drives "+combos+" expands:");

      expandedAddresses=new char[combos][maskLen];
      
      // Need to create numeric matrix for replacement bits
      char[][] bitMatrix = new char[combos][xCount];
      
      boolean setLen=false;
      int desiredLen=0;
      String temp;
      for (i=combos-1;i>=0;i--)
      {
        temp=Integer.toBinaryString(i);
        l=temp.length();
        
        // capture the longest length
        if (setLen==false)
        {
          desiredLen=l;
          setLen=true;
        }
        
        // pad with '0' for the gap between this actual length and the desired length
        for (j=0;j<(desiredLen-l);j++)
        {
          bitMatrix[i][j]='0';
        }
        
        // now continue with the actual number
        for (k=0;j<desiredLen;j++,k++)
        {
          bitMatrix[i][j]=temp.charAt(k);
        }
        
        //bitMatrix[i]=temp.toCharArray();

        println("M:"+new String(bitMatrix[i]));
      }
      
      k=0;
      for (i=0;i<maskLen;i++)
      {
        if (m.charAt(i)=='X')
        {
          for (j=0;j<combos;j++)
          {
            expandedAddresses[j][i]=bitMatrix[j][k];
          }
          k++;
        }            
        else
        {
          for (j=0;j<combos;j++)
          {
            expandedAddresses[j][i]=bits[i];
          }
        }
      }
      
      for (j=0;j<combos;j++)
      {
        temp=new String(expandedAddresses[j]);
        println("C"+j+":"+temp+" V:"+Integer.parseInt(temp,2));
      }
      
      //binaryAddress = String.valueOf(bits);
      //println("Binary Address:"+binaryAddress);
      //a=Integer.parseInt(binaryAddress,2);
      //println(" V:"+a);
  }
}

public class Computer
{
  public int[] ram;
  public ArrayList<OpCode> opCodes = new ArrayList<OpCode>();
  public String currentBM;
  public int maxRam=0;
  public String currentMask;
  
  int pc=0;
  
  public Computer()
  {
  }
  
  public boolean execute()
  {
    OpCode temp;
    String binary;
    
    if (pc<opCodes.size())
    {
      temp = opCodes.get(pc);
      
      if (temp.command.equals("mem"))
      {
        /// update memory location based on bit mask
        print("Updating Memory: ");
        temp.expandAddress(temp.address,currentMask);
        //binary=Integer.toBinaryString(temp.value);
        
        //int maskLen=currentMask.length();
        //int i=0,j=0;
        //char[] bits = new char[maskLen];
        
        
        //for (i=maskLen-1;i>=0;i--)
        //{
        //  if (j>=0)
        //  {
        //    j=i-(maskLen-binary.length());
        //    bits[i]=binary.charAt(j);
        //  }
        //  else
        //  {
        //    bits[i]=0;
        //  }
        //}      

        //for (i=maskLen-1;i>=0;i--)
        //{
        //  if (currentMask.charAt(i)=='X')
        //  {
        //  }
        //  else if (currentMask.charAt(i)=='1')
        //  {
        //    bits[i]='1';
        //  }
        //  else if (currentMask.charAt(i)=='0')
        //  {
        //    bits[i]='0';
        //  }
        //  print("="+bits[i]);
        //}

        //binary = String.valueOf(bits);
        //temp.value=Integer.parseInt(binary,2);
        //println(" V:"+temp.value);
      }
      
      if (temp.command.equals("mas"))
      {
        // update the current mask
        print("Updating Mask: ");
        currentMask = temp.mask;
        println(currentMask);
      }
      pc++;
    }
    return(false);
  }
  

  
  public void updateMaxAddress(int a)
  {
    if (a>maxRam)
    {
      maxRam=a;
    }
  }
  
  public void initRam()
  {
    ram=new int[maxRam];
    println("Allocating RAM="+maxRam);
  }
}
