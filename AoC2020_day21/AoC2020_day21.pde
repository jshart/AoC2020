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
InputFile input = new InputFile("input.txt");
FoodList foodList = new FoodList();

// structured list of allergen->foods_that_contain_it 
HashMap<String, FoodList> allergenMap = new HashMap<String, FoodList>();

// Master list of all suspect allergens
ArrayList<String> masterList = new ArrayList<String>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0;
  Food tempFood;
  FoodList newFoodList;
  FoodList tempFoodList;

  // Loop through each food...
  for (i=0;i<input.lines.size();i++)
  {
    tempFood=new Food(input.lines.get(i));
    //tempFood.printFood();
    foodList.foods.add(tempFood);
    
    if (tempFood.alls.size()==1)
    {
      println("Unique allergen/food combo found for:"+tempFood.alls.get(0));
    }
    
    // ... and for each food, check each allergen
    for (j=0;j<tempFood.alls.size();j++)
    {

      // is this the first time we've seen this?
      tempFoodList=allergenMap.get(tempFood.alls.get(j));
      if (tempFoodList==null)
      {
        // yes it is - so add it to the allergenMap
        newFoodList=new FoodList();
        newFoodList.foods.add(tempFood);
        allergenMap.put(tempFood.alls.get(j),newFoodList);
      }
      else
      {
        // update the allergen map with another food entry for this allergen
        tempFoodList.foods.add(tempFood);
      }
    }
  }
  
  // correlate and cross check the ings/alls
  // looking at each allergen (english key)
  // and considering all the foods its part of
  
  // go through each known allergen (i.e. fish, nuts ec)
  // and check every food its found in
  for (Map.Entry m : allergenMap.entrySet())
  {
    // retrieve this current entry and value
    println("Key:"+m.getKey());
    tempFoodList=(FoodList)m.getValue();
    
    // try to establish candidate allergen list by looking at all the peer foods in this group
    //tempFoodList.printFoodList();
    tempFoodList.buildCommonList((String)m.getKey());
    tempFoodList.printAllergenList();
  }
  printMasterList();
  int total=0;
  
  // Loop through each food...
  for (i=0;i<foodList.foods.size();i++)
  {
    // and sum up the total of all the ingredients in the foods that are not suspected
    // allergens.
    total+=foodList.foods.get(i).ingNoAlls();
  }
  println("Total:"+total);
}

void printMasterList()
{
  int i=0;
  for (i=0;i<masterList.size();i++)
  {
    println("Allergen ML:"+masterList.get(i));
  }
}


void draw() {  

}

public class FoodList
{
  ArrayList<Food> foods=new ArrayList<Food>();
  ArrayList<String> allergenList = new ArrayList<String>();
  
  public FoodList()
  {
  }
  
  void printFoodList()
  {
    int i=0;
    for (i=0;i<foods.size();i++)
    {
      foods.get(i).printFood();
    }
  }
  
  void printAllergenList()
  {
    int i=0;
    for (i=0;i<allergenList.size();i++)
    {
      println("suspected allergen;"+allergenList.get(i));
    }
  }
  
  void buildCommonList(String key)
  {
    Food firstFood;
    firstFood=foods.get(0);
    
    int i=0,j=0;
    boolean found=true;
    String all;
    
    boolean debug=false;
    
    //if (key.equals("eggs")==true)
    //{
    //  debug=true;
    //}
    
    if (debug)
    {
      println("Building common list for:"+key+" using:"+foods.size()+" likely sources");
    }
    
    // for each ing in the first food, check for its existence in all other foods - if its there then its a likely allergen
    for (i=0;i<firstFood.ings.size();i++)
    {
      found=true;
      
      if (debug)
      {
        print("Checking for... ["+firstFood.ings.get(i)+"]");
      }
      
      for (j=1;j<foods.size() && found==true;j++)
      {
        if (debug)
        {
          //println("CHECKING..."+foods.get(j).original);
          print(j+",");
        }
        found = foods.get(j).hasIng(firstFood.ings.get(i));
      }
      if (found==true)
      {
        all=firstFood.ings.get(i);
        if (debug)
        {
          print("["+all+"] found in all foods for: "+key+" adding to allergen list");
        }
        allergenList.add(all);
        addToMaster(all);   // a bit hacky - but for quick work, I just copy every allergen into a master list to make life a bit easier later
      }
      if (debug)
      {
        println();
      }
    }
  }
  
  void addToMaster(String s)
  {
    int i=0;
    for (i=0;i<masterList.size();i++)
    {
      if (masterList.get(i).equals(s)==true)
      {
        return;
      }
    }
    masterList.add(s);
  }
}


public class Food
{
  ArrayList<String> ings=new ArrayList<String>();
  ArrayList<String> alls=new ArrayList<String>();
  String original;
  
  public Food(String s)
  {
    String temp[],temp2[];
    int i=0;
    
    original=s;
    
    temp=s.split(" contains "); 
    
    temp2=temp[0].split(" ");
    for (i=0;i<temp2.length;i++)
    {
      ings.add(temp2[i]);
    }
    
    temp2=temp[1].split(", ");
    for (i=0;i<temp2.length;i++)
    {
      alls.add(temp2[i]);
    }
  }
  
  void printFood()
  {
    int i=0;
    for (i=0;i<ings.size();i++)
    {
      println("I:["+ings.get(i)+"]");
    }
    for (i=0;i<alls.size();i++)
    {
      println("A:["+alls.get(i)+"]");
    }
  }
  
  boolean hasIng(String s)
  {
    int i=0;
    for (i=0;i<ings.size();i++)
    {
      if (ings.get(i).equals(s)==true)
      {
        return(true);
      }
    }
    return(false);
  }
  
  int ingNoAlls()
  {
    int i=0,j=0;
    int count=0;
    boolean found=false;
    
    //for each ing...
    for (i=0;i<ings.size();i++)
    {
      found=false;
      // ... check against each allergen in the master list
      for (j=0;j<masterList.size();j++)
      {
        //print("checking:"+ings.get(i)+" with "+masterList.get(j));
        // if its found, then we dont count this item
        if (ings.get(i).equals(masterList.get(j))==true)
        {
          //println(" MATCH");
          found=true;
          break;
        }
        else
        {
          //println(" NO MATCH");
        }
      }
      if (found==false)
      {
        //println(" NO MATCH, inc");
        count++;
      }
    }
    return(count);
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
