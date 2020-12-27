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

int[] input=new int[]{0,9,7,4,6,1,8,3,5,2}; // mydata
//int[] input=new int[]{0,3,8,9,1,2,5,4,6,7}; //example
LinkedList[] directAccess;
LinkedList baseNode=null;
int maxNumbers=1000001;
//int maxNumbers=20;


void buildDataModel()
{
  int i=0;
  LinkedList pNode=null;
  
  directAccess=new LinkedList[maxNumbers];
  
  
  // We ignore '0' as its not really part of our data set, but by adding it to the data set
  // it shifts all the labels/indices so they line up properly
  for (i=1;i<maxNumbers;i++)
  {
    if (i<input.length)
    {     
      //println("Adding node for i="+i+" contents:"+input[i]);

      // create a new node, and (usefully) also store it in the direct access array using the content as an index
      directAccess[input[i]]=new LinkedList(input[i]); 
      
      // capture the first node added, so we can create a loop of the list later
      if (baseNode==null)
      {
        baseNode=directAccess[input[i]];
        //println("BASE node created for input index i="+i+" contents:"+input[i]);
      }
      
      // capture the last node added, so we can add the new node to the end of the list
      if (pNode!=null)
      {
        // if this is not the first node, then add it the list
        directAccess[input[i]].addNodeAfter(pNode);
      }
      pNode=directAccess[input[i]];

    }
    else
    {
      // Once we've run out of input numbers, just sequentially add numbers to the list until we hit the max numbers
      
      // create a new node, and (usefully) also store it in the direct access array using the content as an index
      directAccess[i]=new LinkedList(i); 
      
      // capture the last node added, so we can add the new node to the end of the list
      if (pNode!=null)
      {
        // if this is not the first node, then add it the list
        directAccess[i].addNodeAfter(pNode);
      }
      pNode=directAccess[i];
    }
  }
  
  println("CLOSE LOOP");
  print("start point:");
  baseNode.printNode();
  print("end point:");
  pNode.printNode();
  
  // Array filled, close the loop.
  baseNode.back=pNode;
  pNode.forward=baseNode;

  for (i=0;i<20;i++)
  {
    if (directAccess[i]==null)
    {
      println("DA index ["+i+"] undefined");
    }
    else
    {
      directAccess[i].printNode();
    }
  }
  
}

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  
  int turn=0,cupIndex=0,k=0;
  boolean destFound=false;
  
  buildDataModel();
  //baseNode.printList();
  
  int currentCupLabel=baseNode.cupLabel;  
  LinkedList cutList;
  
  
  int targetDestLabel=0;  
  // for each turn
  for (turn=1;turn<=10000000;turn++)
  //for (turn=1;turn<10;turn++)
  {
    if ((turn)%1000000==0)
    {
      println("*** MOVE NUMBER:"+(turn)+" *** currentCupLabel="+currentCupLabel);
    }
    
    //println("Sublist test, cutting after node with label:"+currentCupLabel);
    cutList=directAccess[currentCupLabel].cutSubList(3);
    //println("final cut list");
    //cutList.printList();

    //println("is 15 in list? "+cutList.inList(15));
    //println("is 9 in list? "+cutList.inList(9));
    //println("is 1 in list? "+cutList.inList(1));
    //println("is -4 in list? "+cutList.inList(-4));
    //println("is 8 in list? "+cutList.inList(8));
   
    //println();
    //println("Remainder list after cut:");
    //directAccess[currentCupLabel].printList();
    
    // Calculate the dest cup
    targetDestLabel=currentCupLabel-1;
    destFound=false;
    //println("Searching for:"+targetDestLabel);
    while (destFound==false)
    {
      // First of all check to see if we need to wrap
      if (targetDestLabel<=0)
      {
        targetDestLabel=directAccess[maxNumbers-1].cupLabel;
      }
      
      // Now check if the label is in the cut list
      if (cutList.inList(targetDestLabel)==true)
      {
        //println("target in dest list - adjusting");
        targetDestLabel--;

      }
      else
      {
        destFound=true;
      }
    }

    //println("Dest cup found, label="+targetDestLabel);

    directAccess[targetDestLabel].addListAfter(cutList);
    
    //println("New list after cut/add:");
    //baseNode.printList();
    
    currentCupLabel=directAccess[currentCupLabel].forward.cupLabel;
    //println("New cup label="+currentCupLabel);
  }

  
  // TODO; Need to work out how to calculate destination cup
      //The crab selects a destination cup: the cup with a label equal to the current cup's
      //label minus one. If this would select one of the cups that was just picked up, the crab
      //will keep subtracting one until it finds a cup that wasn't just picked up. If at any point
      //in this process the value goes below the lowest value on any cup's label, it wraps around
      //to the highest value on any cup's label instead.
  
    //The crab places the cups it just picked up so that they are immediately clockwise
    //of the destination cup. They keep the same order as when they were picked up.
    //The crab selects a new current cup: the cup which is immediately clockwise of the current cup.
    
    println("final scores;");
    directAccess[1].back.printNode();
    directAccess[1].printNode();
    directAccess[1].forward.printNode();
    directAccess[1].forward.forward.printNode();
 }



void draw() {  

}



public class LinkedList
{
  LinkedList forward=null;
  LinkedList back=null;
  int cupLabel=-1;
  
  public LinkedList(int c)
  {
    cupLabel=c;
  }
  
  public LinkedList(int c, LinkedList l)
  {
    cupLabel=c;
    back=l;
    l.forward=this;
  }
  
  public boolean inList(int c)
  {
    LinkedList start;
    LinkedList n;
    
    n=this;
    start=this;
    
    do 
    {
      if (n.cupLabel==c)
      {
        return(true);
      }
      n=n.forward;
    }
    while (n!=null && n!=start);
    return(false);
  }
  
  public LinkedList cutSubList(int nodes)
  {
    int i=0;
    LinkedList subListStart=null;
    LinkedList remainderList=null;
    LinkedList cutpoint=null;
    
    // capture the start of the sublist
    subListStart=this.forward;
    this.forward=null;
    cutpoint=this;
    
    // wind forward to the point where the remainder list starts
    remainderList=subListStart;
    for (i=0;i<nodes;i++)
    {
      remainderList=remainderList.forward;
    }
    
    // detach the sublist from the main list
    remainderList.back.forward=null;
    subListStart.back=null;
    
    //reattach the 2 halves of the list
    //println("recombining lists; this node");
    //this.printNode();
    //println("remainder:");
    //remainderList.printList();
    
    cutpoint.forward=remainderList;
    remainderList.back=cutpoint;

    //println("Combined list:");
    //this.printList();
    
    return(subListStart);
  }
  
  public void addListAfter(LinkedList subListToAdd)
  {
    LinkedList addToLocation=null;
    LinkedList nextNodeToAdd=null;
    
    addToLocation=this;
    boolean done=false;

    int max=5;
    
    do 
    {
      // is this the end of the sublist?
      if (subListToAdd.forward==null)
      {
        done=true;
      }
      else
      {
        // Save the next node
        nextNodeToAdd=subListToAdd.forward;
        
        // detach this one from the sub list.
        subListToAdd.forward=null;
      }

      //print("adding to node:");
      //addToLocation.printNode();

      //print("adding node:");
      //subListToAdd.printNode();
      subListToAdd.addNodeAfter(addToLocation);
      
      //print("node added:");
      //subListToAdd.printNode();
      
      // move forward after the node we just added
      addToLocation=addToLocation.forward;
      
      
      // move to the next node in the sublist we're trying to add
      subListToAdd=nextNodeToAdd;
    }
    while (done==false && max-- >=0);    
  }

  // Assumes an *always* valid node b to attach too, will optionally forward
  // link if b already has a forward link. i.e. will *insert* if b is middle
  // of a list, but will add if b is end of list.
  public void addNodeAfter(LinkedList b)
  {
    // save the current forward link, as we'll attach this node to that eventually
    LinkedList f=b.forward;
    
    // connect this node *backwards* to the b node...
    this.back=b;
    b.forward=this;
    
    if (f!=null)
    {
      // ... and *forwards* to the f node, which we saved earlier
      this.forward=f;
      f.back=this;
    }
  }

  public void printList()
  {
    LinkedList start;
    LinkedList n;
    
    n=this;
    start=this;
    
    do 
    {
      n.printNode();
      n=n.forward;
    }
    while (n!=null && n!=start);
  }
  
  
  public void printNode()
  {
    //println("C:"+cupLabel+" fwd cup label:"+(forward==null?"null":forward.cupLabel)+" back cup label:"+(back==null?"null":back.cupLabel));
    println((back==null?"null":back.cupLabel)+"<-["+cupLabel+"]->"+(forward==null?"null":forward.cupLabel));
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
