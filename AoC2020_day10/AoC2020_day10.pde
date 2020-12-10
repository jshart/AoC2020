import java.io.File;
import java.io.FileReader;
import java.io.IOException;


String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2020\\AoC2020_day10\\data");

ArrayList<String> lines = new ArrayList<String>();
int inputLen=0;
int validPermutations=0;

int[] inputNumbers;

//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];

ArrayList<RawTreeData> rawTrees = new ArrayList<RawTreeData>();


void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));



  try {
    String line;
    
    //File fl = new File(filebase+File.separator+"example_sorted.txt");
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
  
  inputNumbers=new int[inputLen];
  
  int last=0;
  
  int[] differences = new int[10];
  int delta=0;
  
  // convert the strings to numbers
  int i=0,j=0,k=0;
  for (i=0;i<inputLen;i++)
  {
    
    inputNumbers[i] = Integer.parseInt(lines.get(i));
  }
  
  RawTreeData tempTreeData=new RawTreeData();
  
  for (i=0;i<inputLen;i++)
  {
        
    println("Adpt="+inputNumbers[i]);
    delta =inputNumbers[i]-last;
    last =inputNumbers[i];
    differences[delta]++;
    
    if (delta>=3)
    {
      rawTrees.add(tempTreeData);
      tempTreeData.printTree();
      tempTreeData= new RawTreeData();
    }
    tempTreeData.rawData.add(inputNumbers[i]);
  }
  rawTrees.add(tempTreeData);
  tempTreeData.printTree();
  
  
  for (i=0;i<10;i++)
  {
    println("differences["+i+"]="+differences[i]);
  }
  // add one extra to 3 for the device
  differences[3]++;
  println("Final = "+(differences[1]*differences[3]));
  
  int l=rawTrees.size();
  for (i=0;i<l;i++)
  {
    println();
    rawTrees.get(i).printTree();
    println("VALID COMBOS="+rawTrees.get(i).testCombos());
  }
  
  long runningTotal=1;
  for (i=0;i<l;i++)
  {
    runningTotal*=rawTrees.get(i).validCombos;
    print("i="+i+" combos="+rawTrees.get(i).validCombos);
    println(" RunningTotal="+runningTotal);
  }
  
  //TreeBranch myTree = new TreeBranch(0);
  //myTree.addChildren(0);
  //myTree.printTree();
}

public class RawTreeData
{
  ArrayList<Integer> rawData = new ArrayList<Integer>();
  
  public int validCombos=0;
  
  public RawTreeData()
  {
  }

  void printTree()
  {
    int l=rawData.size();
    int i=0;
    print("{");
    for (i=0;i<l;i++)
    {
      print(rawData.get(i)+",");
    }
    println("}");
  }
  
  int testCombos()
  {
    int i=0;
    int k=0;
    int mask=0;
    int l=rawData.size();
    int result=0;
    int maxCombos=(int)Math.pow(l,2);
    
    for (i=0;i<l;i++)
    {
      mask |= 1<<i;
    }
    maxCombos=(int)mask;
    
    println("testing combos...");
    
    if (l==1)
    {
      println("SINGLE COMBO");
      validCombos=1;
      return(1);
    }
    println("l="+l+" maxCombos="+maxCombos);
    

    for (i=0;i<=maxCombos;i++)
    {
      print("i="+i+" MASK="+Integer.toBinaryString(i)+" ");
      boolean isValid=true;
      
      // print selected members
      print("Seq:");
      
      int lastValue=rawData.get(0);
      for (k=0;k<l;k++)
      {
        mask=i & (1<<k);
        print("["+Integer.toBinaryString(1<<k)+"]");
        
        if ((int)mask > 0)
        {
          print(rawData.get(k)+",");
          if (rawData.get(k)>lastValue+3)
          {
            isValid=false;
          }
          lastValue=rawData.get(k);
        }
        else
        {
          print("_,");
          if (k==0 || k==l-1)
          {
            isValid=false;
          }
        }
      }
      print("   VALID="+isValid);
      println();
      if(isValid==true)
      {
        result++;
      }
    }
    
    validCombos=result;
    return(result);
  }
}


public class TreeBranch
{
  int value;
  String debug = new String();
  ArrayList<TreeBranch> childrenList = new ArrayList<TreeBranch>();
  
  public TreeBranch(int v)
  {
    value=v;
  }
  
  
  public int addChildren(int startingIndex)
  {
    int delta=0;
    TreeBranch temp;
    int i=0;
    //print("Adding children for index=["+startingIndex+"] - ");
    
    while (delta<=3 && startingIndex<inputLen)
    {
      delta=inputNumbers[startingIndex]-this.value;
      if (delta<=3)
      {
        //println("inside loop, value="+this.value+" inputNumber is="+inputNumbers[startingIndex]+" delta is="+delta);
        
        temp=new TreeBranch(inputNumbers[startingIndex]);
        temp.debug=this.debug+","+temp.value;
        childrenList.add(temp);
        startingIndex++;
        
        //println("inc index=["+startingIndex+"]");
        i+=temp.addChildren(startingIndex);
        i++;
      }
    }
    if (i==0)
    {
      //println(this.debug);
      validPermutations++;
      println(validPermutations);
    }
    //println("Child count="+i);
    return(i);
  }
  
  public void printTree()
  {
    println("stub");
  }
}

void draw() {
  noLoop();
}
