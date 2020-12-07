//int[] inputInts = new int[

String[] lines;
int totalLines = 0;



ArrayList<Baggage> baggageList = new ArrayList<Baggage>();
ArrayList<String> outputList = new ArrayList<String>();
ArrayList<String> inputList = new ArrayList<String>();
ArrayList<String> aggregateList = new ArrayList<String>();


void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);
  
  lines = loadStrings("input.txt");
  totalLines=lines.length;
  
  Baggage tempPair;
    
  int i=0;
  print(totalLines);
  
  // Skip the first line, as for soem reason loadStrings messes up the first line, so I manually added in a header line
  // which we can ignore
  for (i=1;i<totalLines;i++)
  {
    print(lines[i]+" xlate ==>  ");
    tempPair = new Baggage(lines[i]);
    
    baggageList.add(tempPair);  
  }
  println("Total Entries parsed:"+totalLines);
  println();
  
  
  // START OF SEARCH
  
  inputList.add("shiny gold bag");
  int loops=0;
  do
  {
    outputList.clear();
    
    findBagsThatContain(outputList,inputList,0);
    
    inputList.clear();
    for (i=0;i<outputList.size();i++)
    {
      inputList.add(outputList.get(i));
      if (itemInList(aggregateList,outputList.get(i))==false)
      {
        aggregateList.add(outputList.get(i));
      }
    }
    
    for (i=0;i<outputList.size();i++)
    {
      println(outputList.get(i));
    }
    
    println("*** ITERATION:"+loops++);
  }
  while (outputList.size()>0);

  printList("AGGREGATE:",aggregateList);
  println("SIZE:"+aggregateList.size());
}

void printList(String prefix,ArrayList<String> inputList)
{
  int l=inputList.size();
  int i=0;
  
  for (i=0;i<l;i++)
  {
    println(prefix+inputList.get(i));
  }
}

boolean itemInList(ArrayList<String> inputList, String key)
{
  int l=inputList.size();
  int i=0;
  
  for (i=0;i<l;i++)
  {
    if (inputList.get(i).equals(key))
    {
      return(true);
    }
  }
  return(false);
}

void findBagRule(String name, int depth)
{
  // Walk the list
  int arraySize = baggageList.size();
  int i;
  Baggage temp;
  
  for (i=0;i<arraySize;i++)
  {
    print("SEARCHING FOR:["+baggageList.get(i).bagName+"]");
    temp = baggageList.get(i);
    if (temp.bagName.equals(name))
    {
      temp.printRule();
      
      int j=0;
      int subrules=temp.contentsName.length;
      
      for (j=0;j<subrules;j++)
      {
        if (temp.contentsName[j].equals("no other bag"))
        {
          return;
        }
        else
        {
          //print("[D]="+depth);
          findBagRule(temp.contentsName[j],depth+1);
        }
      }
    }
  }
}

void findBagsThatContain(ArrayList<String> outputList, ArrayList<String> inputList, int depth)
{
  // Walk the list
  int arraySize = baggageList.size();
  int inputSize = inputList.size();
  int i,k,j;
  Baggage temp;
  String searchName;
  
  println("inputlistsize:"+inputSize);
  // loop search list
  for (k=0;k<inputSize;k++)
  {
    searchName=inputList.get(k);
    
    // loop all items in main list
    for (i=0;i<arraySize;i++)
    {
      temp = baggageList.get(i);
        
      int subrules=temp.contentsName.length;
      
      // check all subrules
      for (j=0;j<subrules;j++)
      {
        if (temp.contentsName[j].equals(searchName))
        {
          // this bag contains the one we are looking for - great
          println("MATCH FOUND:"+temp.bagName);
          outputList.add(temp.bagName);
        }
      }
    }
  }
}



void draw() {
  noLoop();
}

public class Baggage
{
  String bagName;
  String contents[];
  String contentsName[];
  int contentsCount[];
  
  public Baggage(String s)
  {
    String temp[];
    temp=s.split(":");
    bagName=temp[0];
    print("[BAG NAME]={"+bagName+"}");

    int i=0;
    int firstSpace=0;
    
    int itemCount=0;

    if (temp.length>1)
    {
      contents=temp[1].split(",");
      
      itemCount=contents.length;
      print("[CONTENTS]={"+itemCount+"}");
      
      contentsName = new String[itemCount];
      contentsCount = new int[itemCount];
      
      for (i=0;i<itemCount;i++)
      {
        // this is lazy - it would be more effecient to copy characters 1 by 1 until you hit a space
        print("[ITEM]={"+contents[i]+"}");
        firstSpace=contents[i].indexOf(' ');
        contentsCount[i]=Integer.parseInt(contents[i].substring(0,firstSpace));
        contentsName[i]=contents[i].substring(firstSpace+1,contents[i].length());
        print("[ITEM C]={"+contentsCount[i]+"}");
        print("[ITEM N]={"+contentsName[i]+"}");
      }
    }
    println();
    
    
    //temp=s.split(" ");
    //max=Integer.parseInt(temp[0]);
    //letter=temp[1].substring(0,temp[1].length()-1);
    //password=temp[2];
    
    //print(min+"*"+max+"*"+letter+"*"+password+"\n");    
  }
  
  public void printRule()
  {
      int i=0;
      int itemCount=contents.length;

      print("RULE for: ["+bagName+"] contains");
      for (i=0;i<itemCount;i++)
      {
        print("[ITEM C]={"+contentsCount[i]+"}");
        print("[ITEM N]={"+contentsName[i]+"}");
      }
      println();
  }
  
  //public boolean validate()
  //{
  //  int pLen = password.length();
    
  //  int i;
  //  int letterCount=0;
    
  //  for (i=0;i<pLen;i++)
  //  {
  //    if (password.charAt(i)== letter.charAt(0))
  //    {
  //      letterCount++;
  //    }
  //  }
    
  //  if (letterCount>=min && letterCount<=max)
  //  {
  //    return(true);
  //  }
    
  //  return(false);
  //}
  
  //public boolean validate2()
  //{
  //  int pLen = password.length();
  //  int letterCount=0;
    
  //  if (password.charAt(min-1)== letter.charAt(0))
  //  {
  //    letterCount++;
  //  }
  //  if (password.charAt(max-1)== letter.charAt(0))
  //  {
  //    letterCount++;
  //  }
   
    
  //  if (letterCount==1)
  //  {
  //    return(true);
  //  }
    
  //  return(false);
  //}
}
