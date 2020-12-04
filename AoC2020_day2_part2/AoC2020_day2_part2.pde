//int[] inputInts = new int[

String[] lines;
int totalLines = 0;



ArrayList<Day2Password> day2PasswordList = new ArrayList<Day2Password>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(12);
  
  lines = loadStrings("input.txt");
  totalLines=lines.length;
  
  Day2Password tempPair;
    
  int i=0;
  print(totalLines);
  int totalValidPasswords=0;
  
  // Skip the first line, as for soem reason loadStrings messes up the first line, so I manually added in a header line
  // which we can ignore
  for (i=1;i<totalLines;i++)
  {
    print(lines[i]+" xlate ==>  ");
    tempPair = new Day2Password(lines[i]);
    
    day2PasswordList.add(tempPair);
    
    if (tempPair.validate2()==true)
    {
      totalValidPasswords++;
    }
  }
  print("TOTAL: "+totalValidPasswords);
}

void draw() {
  noLoop();
}

public class Day2Password
{
  int min;
  int max;
  String letter;
  String password;
  String[] temp;
  
  public Day2Password(String s)
  {
    temp=s.split("-");
    min=Integer.parseInt(temp[0]);
    s=temp[1];
    
    temp=s.split(" ");
    max=Integer.parseInt(temp[0]);
    letter=temp[1].substring(0,temp[1].length()-1);
    password=temp[2];
    
    print(min+"*"+max+"*"+letter+"*"+password+"\n");    
  }
  
  public boolean validate()
  {
    int pLen = password.length();
    
    int i;
    int letterCount=0;
    
    for (i=0;i<pLen;i++)
    {
      if (password.charAt(i)== letter.charAt(0))
      {
        letterCount++;
      }
    }
    
    if (letterCount>=min && letterCount<=max)
    {
      return(true);
    }
    
    return(false);
  }
  
  public boolean validate2()
  {
    int pLen = password.length();
    int letterCount=0;
    
    if (password.charAt(min-1)== letter.charAt(0))
    {
      letterCount++;
    }
    if (password.charAt(max-1)== letter.charAt(0))
    {
      letterCount++;
    }
   
    
    if (letterCount==1)
    {
      return(true);
    }
    
    return(false);
  }
}
