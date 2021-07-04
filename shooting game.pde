// 1014126 Minamoto Tomoya

void setup() {//setup
  size(600, 600);//screen is (450,600)
  noCursor();
}

int tt,n=100,ww,r;//tt is 0.01 second since mouse pressed
                  //n  is frame rate's time
                  //ww is key in order to do only onece
                  //r  is effect gray ellipse diameter 
                  
int game_time,live_time;//game time is 0.01 second since game started
                        //live time is 0.01 second during hitted ball

int boxhit = 200; //box's life

int life = 100;    //remaining lives
int ss,s,m,h;     //0.01second, second, minute, hour
int wss,ws; //statsic time's 0,2second, second
int i = 0;  //how many ball
int ts = 0; //0.01 second when arising balls

float r_w = 50.0; // racket width
float b_x = 75.0; // block x
float b_y = 15.0; // block y
float b_w = 170.0; // block width
float b_h = 100.0; // block height
float a_w = 15.0; // ball width
float a_h = 15.0; // ball height

float [] x = new float[200]; //ball x
float [] y = new float[200]; //ball y
float [] ax = new float[200]; //ball dx
float [] ay = new float[200]; //ball dy

float [] truex = new float[200]; //can reflect ball x
float [] truey = new float[200]; //            ball y
float [] trueax = new float[200];//            ball dx
float [] trueay = new float[200];//            ball dy
float [] exist = new float[200]; //judge reflected or reflected ball

float cloudx;// location of cloud
float cloudy;// location of cloud
   
boolean ending(int boxhit) { // ending when block life = 0
  if (boxhit <= 0) {
    return true;
  } else {//judge true or false
    return false;
  }
}

boolean checkHit(float x, float y) {//checking hitted racket or not
  if (y + a_h < mouseY) return false;
  if (mouseY+20 < y + a_h) return false; //a range of hit area 
   
  if (x + a_w >= mouseX-25 && x <= mouseX-25 + r_w) {
    return true;
  } else {//judge true or false
    return false;
  }
}

int checkHitBlock(float n, float m, float x, float y) {//checking hitted block or not
  float left   = n;         //block's left 
  float right  = b_w+ n;    //        right
  float top    = m;         //        top
  float bottom = m + b_h;   //        bottom
  float cx = left + b_w / 2;//        midpoint
  float cy = top + b_h / 2; //        midpoint
  float y1, y2;             
  
  if ((x<= left) ||    //outside of the block
      (x >= right) ||  //outside of the block
      (y<= top) ||     //outside of the block
      (y >= bottom)) { //outside of the block
        return 0;
      }
   y1 = y - (-(x - cx)* b_h / b_w + cy);//infomation of diagonal line
   y2 = y - ( (x - cx)* b_h / b_w + cy);//infomation of diagonal line
   if (y1 > 0) {
     if (y2 > 0) {
       return 1; //from above
     } else if (y2 == 0) {
       return 2; //on diagonal line
     } else {
       return 3; //from right
     }
   } else if (y1 < 0) {
     if (y2 > 0) {
       return 7; //from left
     } else if (y2 == 0) {
       return 6; //on diagonal line
     } else {
       return 5; //from below
     }
   } else {
     if (y2 > 0) {
       return 8; //on diagonal line
     } else if (y2 == 0) {
       return -1;//on diagonal line
     } else {
       return 4; //on diagonal line
     }
   }
}

void rain(int m){ // kind of barrage 
if(m*2-ts+1>0){
    ax[m]=cos(m);//speed of spiral
    ay[m]=sin(m);//speed of spiral
    x[m]=x[m]+ax[m]*8;
    y[m]=y[m]+ay[m]*8;
    ax[m]=mouseX-x[m];//speed of homing
    ay[m]=mouseY-y[m];//speed of homing
    x[m]=x[m]+ax[m]*0.04;
    y[m]=y[m]+ay[m]*0.04;
      fill(0,255,0);// setting barrage color
      show_balla(m); 
}

  if(m*2-ts+1<0){//frequency of shot ball
    ax[m]=-cos(m);       //changing speed
    ay[m]=-sin(m);       //changing speed
    x[m]=x[m]+ax[m]*0.5; //changing speed by time
    y[m]=y[m]+ay[m]*0.5; //changing speed by time
      fill(255,255,0);
      show_balla(m);    
  }  
}


void sneak(int m){  // kind of barrage 
  if(m*2-ts+100>0){ 
   x[m]=b_x+b_w/2;// gaining position information
   y[m]=b_y+b_h/2;// gaining position information
  }
  if(m*2-ts+100<0){
    ax[m]=cos(m); // speed of spiral
    ay[m]=sin(m); // speed of spiral
    x[m]=x[m]+ax[m]*8;
    y[m]=y[m]+ay[m]*8;
    ax[m]=mouseX-x[m]; // speed of homing
    ay[m]=mouseY-y[m]; // speed of homing
    x[m]=x[m]+ax[m]*0.04;
    y[m]=y[m]+ay[m]*0.04;
      fill(0,250,0);// setting barrage color
      show_balla(m); 
  }
}
     
void rose(int m){  // kind of barrage 
  if(m*2-ts+100>=0){ // gaining position information
   x[m]=b_x+b_w/2;
   y[m]=b_y+b_h/2;
  }
  if(m*2-ts+100<0){//frequency of shot ball
    ax[m]=cos(m*5)*5;//changing speed
    ay[m]=sin(m*5)*5;//changing speed
    x[m]=x[m]+ax[m];
    y[m]=y[m]+ay[m];
      fill(250,0,0);//setting barrage color
      show_balla(m);
  }
}

void maspa(int m){// kind of barrage 
   if(m*2-ts+100>=0){ 
   x[m]=b_x+b_w/2;// gaining position information
   y[m]=b_y+b_h/2;// gaining position information
  }
  if(m*2-ts+100<0){//frequency of shot ball
    if(m%2==0){//separate
    ax[m]=radians(m)*0.7; //changing speed
      }else{
    ax[m]=-radians(m)*0.7;//changing speed
      }
    ay[m]=ts*0.01-6;      //changing speed
   noStroke();  
     if(ts<500){//after 5 second, ball don't moved right and left
    x[m]=x[m]+ax[m];
    }
    y[m]=y[m]+ay[m];
    if(m==0){}else{//m is disappear because m don't gain position information
    noStroke();  
    fill(255,255,0);//setting barrage color
    show_ballaSP(m);
    }
      stroke(0); //a frame is appeared
  }
}

void dable(int m){// kind of barrage 
 if(m*2-ts+100>=0){ // gaining position information
   x[m]=b_x+b_w/2;
   y[m]=b_y+b_h/2;
  }  
  if(m*2-ts+100<0){//frequency of shot ball
   
    if(ts<600){
    if(m%2!=0){// ball is separated
    ax[m]=cos(m+ts*0.03)*10;//speed of spiral
    ay[m]=sin(m+ts*0.03)*10;//speed of spiral
      }else{//changing speed
    ax[m]=-cos(m+ts*0.03)*10;//speed of spiral
    ay[m]=sin(m+ts*0.03)*10;//speed of spiral
      }
    }
    x[m]=x[m]+ax[m];
    y[m]=y[m]+ay[m]; 
    fill(255,255,0);//setting barrage color
    show_balla(m);
    }
  }
  

void enuma(int m){// kind of barrage 
  if(m*2-ts+100<0){//frequency of shot ball
 
      y[m]=m*3;// y is fixed
    if(m%2==0){
    ax[m]=cos(m*10)*3;//speed of spiral
      }else{
    ax[m]=-cos(m*10)*3;//speed of spiral
      }
     if(ts<500){}else{
    x[m]=x[m]+ax[m];
     }
    if(m%2==0){// ball is separated
    fill(255,0,0);//setting barrage color
    show_balla(m);
    }else{
    fill(0,255,0);//setting barrage color
    show_balla(m);
    }
  }
  }
  
  void aqua(int m){// kind of barrage 
  if(m%6*10-ts+100>=0){ // gaining position information
    x[m]=b_x+b_w/2;
    y[m]=b_y+b_h/2;
  }
  if(m%6*10-ts+100<0){//frequency of shot ball
    if(m%2==0){// ball is separated
    ax[m]=cos(0.03-m)*(300-ts)*0.05;//speed of spiral
      }else{
    ax[m]=-cos(0.03-m)*(300-ts)*0.05;//speed of spiral
      }
    ay[m]=sin(0.03-m)*(300-ts)*0.05;//speed of spiral
     if(ts<10000){    //changing speed by time
    x[m]=x[m]+ax[m];
    y[m]=y[m]+ay[m];
    }else{            //changing speed
    x[m]=x[m]-ax[m];
    y[m]=y[m]-ay[m];//changing speed
    }
    fill(0,255,255);//setting barrage color
    show_balla(m);
  }
  }
void show_ball(int n) {//ball can refrected ball
    if(exist[n]==1){//judge that ball appeared or not
  fill(255);//setting barrage color
  ellipse(truex[n],truey[n], 10, 10);
  
    truex[n]=truex[n]+trueax[n]/40;//ball can refrected ball
    truey[n]=truey[n]+trueay[n]/40;//ball can refrected ball
    }
  }
void show_balla(int n) {//ball cannot refrected ball and can refrect ball
  if(n%7==0){
   if(exist[n]==1){//ball is not appeared
  }else{
  fill(125);
  ellipse(x[n],y[n], 10, 10);//ball can refrected ball
  }
  }else{
  ellipse(x[n],y[n], 10, 10);//ball cannot refrected ball
  }
}

void show_ballaSP(int n) {
  if(n%7==0){ 
    if(exist[n]==1){// jugde appear or not
  ellipse(x[n],y[n], 30, 100);//ball can refrected ball but coler is not blue
  }else{
  ellipse(x[n],y[n], 30, 100);//ball can refrected ball but coler is not blue
  }
  }else{
  ellipse(x[n],y[n], 30, 100);//ball cannot refrected ball
  }
}    
 
void draw() {  
  frameRate(n);
  background(50, 50, 250);//I image sky
  
cloudy=cloudy+3;//cloud flow
if(cloudy==1500){// repeat cloud
  cloudy=0;
}

fill(255);// cloud color
noStroke();
ellipse(50,cloudy,220,70);//cloud No.1
ellipse(50,cloudy,100,80);//cloud No.1
ellipse(0,cloudy,90,70);  //cloud No.1
ellipse(100,cloudy,90,70);//cloud No.1

ellipse(350,cloudy-800,290,80);//cloud No.2
ellipse(350,cloudy-800,110,100);//cloud No.2
ellipse(290,cloudy-800,110,90);//cloud No.2
ellipse(410,cloudy-800,110,90);//cloud No.2
 
  stroke(25,0,25);      //block area
  strokeWeight(10);
  strokeJoin(BEVEL);
  fill(55,0,55);        //purple
  rect(b_x,b_y,b_w,b_h);//block
  strokeWeight(1);
   stroke(0);
   
   if(s%4==0 && ss<20){ //big eye closed or not
  fill(255);
  ellipse(b_x+b_w/2,b_y+b_h/2,50,1);//eye closed
  fill(255,boxhit,0);
  ellipse(b_x+b_w/2,b_y+b_h/2,30,1);//eye closed
  fill(0);
  ellipse(b_x+b_w/2,b_y+b_h/2,5,1);//eye closed
}else{  
  fill(255);
  ellipse(b_x+b_w/2,b_y+b_h/2,50,30);//eyelid
  fill(255,boxhit,0);
  ellipse(b_x+b_w/2-((b_x+b_w/2)-mouseX)*0.01,
  b_y+b_h/2-((b_y+b_h/2)-mouseY)*0.002,30,30);//eye mouved to mouse
  fill(255);
  ellipse(b_x+b_w/2-((b_x+b_w/2)-mouseX)*0.015,
  b_y+b_h/2-((b_y+b_h/2)-mouseY)*0.0025,5,5);//eye mouved to mouse
}
  for(int eye = 1; eye < 11; eye++){
    if((eye>boxhit/20) || (s%4==0 && ss<20) ){//eye closed or not
      if((3<=eye && eye<=3) || (8<=eye && eye<=8)){}else{
    if(eye<=5){
  fill(255);
  ellipse(29*eye+b_x,17*eye+b_y,30,1);//eye closed
  fill(255,boxhit,0);
  ellipse(29*eye+b_x,17*eye+b_y,15,1);//eye closed
  fill(0);
  ellipse(29*eye+b_x,17*eye+b_y,3,1);//eye closed
    }else{
  fill(255);
  ellipse(29*(eye-5)+b_x,-17*(eye-5)+b_y+100,30,1);//eye closed
  fill(255,boxhit,0);
  ellipse(29*(eye-5)+b_x,-17*(eye-5)+b_y+100,15,1);//eye closed
  fill(0);
  ellipse(29*(eye-5)+b_x,-17*(eye-5)+b_y+100,3,1);//eye closed
    }
    }
    }else{
  if( (3<=eye && eye<=3) || (8<=eye && eye<=8) ){}else{
    if(eye<=5){
  fill(255);
  ellipse(29*eye+b_x,17*eye+b_y,20,10);//eyelid
  fill(255,boxhit,0);
  ellipse(29*eye+b_x-((b_x+b_w/2)-mouseX)*0.005,
  17*eye+b_y-((b_y+b_h/2)-mouseY)*0.0010,10,10);//eye mouved to mouse
  fill(255);
  ellipse(29*eye+b_x-((b_x+b_w/2)-mouseX)*0.0055,
  17*eye+b_y-((b_y+b_h/2)-mouseY)*0.0015,1,1);//eye mouved to mouse
  }else{
  fill(255);
  ellipse(29*(eye-5)+b_x,-17*(eye-5)+b_y+100,20,10);//eyelid
  fill(255,boxhit,0);
  ellipse(29*(eye-5)+b_x-((b_x+b_w/2)-mouseX)*0.005,
  -17*(eye-5)+b_y+100-((b_y+b_h/2)-mouseY)*0.0010,10,10);//eye mouved to mouse
  fill(255);
  ellipse(29*(eye-5)+b_x-((b_x+b_w/2)-mouseX)*0.0055,
  -17*(eye-5)+b_y+100-((b_y+b_h/2)-mouseY)*0.0015,1,1);//eye mouved to mouse   
    }
  }
  }
  }
  stroke(0);
  for(int i = 0; i<200; i++) { //number of barrage is 200
  int ref;
  ref = checkHitBlock(b_x,b_y, truex[i], truey[i]);
   show_ball(i);   //barrage is appeared
   switch (ref) {
        case 1://changing speed by how to hit              
        case 2://changing speed by how to hit   
        case 8://changing speed by how to hit   
        trueay[i] = -100;
        boxhit--;
        case 5://changing speed by how to hit   
        case 4://changing speed by how to hit   
        case 6://changing speed by how to hit   
        trueay[i] = 100;        
      }
      switch (ref) {
        case 2://changing speed by how to hit   
        case 3://changing speed by how to hit   
        case 4://changing speed by how to hit   
          trueax[i] = 100;
           boxhit--;
          break;
        case 6://changing speed by how to hit   
        case 7://changing speed by how to hit   
        case 8://changing speed by how to hit   
          trueax[i] = -100;
           boxhit--;
         break;
      } 
   if(450<truex[i]){//screen right
   trueax[i]=-trueax[i];
 }
 if(truex[i]<0){//screen left
   trueax[i]=-trueax[i];
 }
 if(truey[i]<0){//screen above
   trueay[i]=-trueay[i];
 }
     
  if(height<truey[i]){//screen below
    int fall = 1;//in order to do only once
    while(fall<1){//in order to do only once
    truex[i]=10;//can refrect ball
    truey[i]=10;//can refrect ball
    trueax[i]=1;//can refrect ball
    trueay[i]=1;//can refrect ball
    fall=1; //in order to do only once
    }
    exist[i]=0;////can refrect ball is disappeared
 } 
 
 if (checkHit(truex[i], truey[i])) {//racket 
    trueax[i] =(truex[i]-mouseX)*5;//changing speed by refrected place
    trueay[i] = -200;
  }
  
// barrage area
if(s==0){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball
  y[i]=80; //cannnot refrect ball and can refrect ball
  ax[i]=1; //cannnot refrect ball and can refrect ball
  ay[i]=1; //cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
  b_x=140;
  b_y=40;
}
if(0<s && s<7){
 rose(i);//kind of barrage
 b_x=b_x+0.001;
}
if(s==7){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball 
  y[i]=80; //cannnot refrect ball and can refrect ball 
  ax[i]=1; //cannnot refrect ball and can refrect ball 
  ay[i]=1; //cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
}
if(7<s && s<15){
  sneak(i);//kind of barrage
  b_x=b_x-0.001;
}
if(s==15 && ss<10){//initialization
  ts=0;//time since shot barrage
}
if(15<=s && s<22){
 rain(i);
}
if(s==22){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball 
  y[i]=80; //cannnot refrect ball and can refrect ball 
  ax[i]=1;//cannnot refrect ball and can refrect ball 
  ay[i]=1;//cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
  b_x=140;
}
if(22<s && s<29){
   aqua(i);//kind of barrage
}
if(s==30){//initialization
  x[i]=225; //cannnot refrect ball and can refrect ball 
  y[i]=40; //cannnot refrect ball and can refrect ball 
  ax[i]=1;//cannnot refrect ball and can refrect ball 
  ay[i]=1;//cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
  b_y=b_y-0.01;
}
if(31<s && s<43){
   maspa(i);//kind of barrage
   b_y=-120;
}
if(s==43){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball 
  y[i]=80; //cannnot refrect ball and can refrect ball 
  ax[i]=1;//cannnot refrect ball and can refrect ball 
  ay[i]=1;//cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
  b_y=b_y+0.015;
}

if(43<s && s<51){
   dable(i);//kind of barrage
}
if(s==51){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball 
  y[i]=80; //cannnot refrect ball and can refrect ball 
  ax[i]=1;//cannnot refrect ball and can refrect ball 
  ay[i]=1;//cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
  b_y=-120;
}
if(51<s && s<59){
   enuma(i);//kind of barrage
}
if(s==59){//initialization
  x[i]=225;//cannnot refrect ball and can refrect ball 
  y[i]=80; //cannnot refrect ball and can refrect ball 
  ax[i]=1;//cannnot refrect ball and can refrect ball 
  ay[i]=1;//cannnot refrect ball and can refrect ball 
  ts=0;//time since shot barrage
}
 if(i%7==0){//refrect by racket 
   if (checkHit(x[i], y[i])) {
    trueax[i] =(truex[i]-mouseX);//changing speed by refrect place
    trueay[i] = -200;//can refrect ball's y 
   if(exist[i]==0){
    truex[i]=x[i];//can refrect ball's x
    truey[i]=y[i];//can refrect ball's y
    trueax[i]=ax[i];//can refrect ball's dx
    trueay[i]=ay[i];//can refrect ball's dy
   }
   exist[i]=1;//from "refrect" to "refrected"
 }
  }else{//hitting ball to own fighter     
   if(mouseY-15<y[i] && y[i]<=mouseY+15){//judge hit own fighter or not
   if(mouseX-15<x[i] && x[i]<=mouseX+15){//judge hit own fighter or not
  strokeWeight(4);   
  stroke(255,0,0);
  line(mouseX-10,mouseY-10,mouseX+10,mouseY+10);// X mark
  line(mouseX-10,mouseY+10,mouseX+10,mouseY-10);// X mark
  strokeWeight(1); 
  stroke(255);
  life--;//reduce life
  live_time=0;//live time is since not hit own fighter
   }
 }else{
  fill(255,255,255,10);
  ellipse(mouseX,mouseY,15,15);//own fighter
 }
 stroke(0);
  fill(255);
  rect(mouseX-25, mouseY-10, r_w, 3); // pad
  }  
}

  fill(125);
  rect(450,0,width,height);//place texted some information
  fill(255);
  textSize(15);
  text("HP",465,100);//notaion HP
  
  if(50<life){
  fill(0,255,0);//changing HP bar color
  }else if(20<life){
  fill(255,255,0);//changing HP bar color
  }else if(0<=life){
  fill(255,0,0);//changing HP bar color
  }
  
  if(life>0){// life's bar
  rect(465,110,life*1.2,5);// life's bar
  }else{
  rect(465,110,0.2,5);//minimum life's bar
  }
  fill(0);
  text("BOSS",20,545);//notation boss
  fill(255,0,0);
  rect(20,550,boxhit*2,10);//boss bar
  fill(255);
  text("Static Time  "+ws+" s",465,270);
  //amount time that used slowly time
  ss = ss+1;//time is 0.01second
  ts = ts+1;//time since shot barrage 
  game_time++;//amont time is 0.01second
  live_time++;//time since not hit
 
 if(ss>=100){
    s = s+1;//1 second
    ss = 0; //0.01 second
  }
  if(s>=60){
    m = m+1;//1 minute
    s = 0;  //1 second
  }

 if(m>=10){//how to notation
  if(s>=10){
    if(ss>=10){
      fill(255);
      textSize(13);
      text("Time   "+m+":"+s+":"+ss,465,190);//0 is
    }else{//defferece notation
      fill(255);
      textSize(13);
      text("Time   "+m+":"+s+":0"+ss,465,190);//0 is not
    }
  }else{//defferece notation
    if(ss>=10){
      fill(255);
      textSize(13);
      text("Time   "+m+":0"+s+":"+ss,465,190);//0 is
    }else{//defferece notation
      fill(255);
      textSize(13);
      text("Time   "+m+":0"+s+":0"+ss,465,190);//0 are two
    }
  }
  }else{//defferece notation
    if(s>=10){
    if(ss>=10){//defferece notation
      fill(255);
      textSize(13);
      text("Time   0"+m+":"+s+":"+ss,465,190);//0 is
    }else{//defferece notation
      fill(255);
      textSize(13);
      text("Time   0"+m+":"+s+":0"+ss,465,190);//0 is
    }
  }else{//defferece notation
    if(ss>=10){
      fill(255);
      textSize(13);
      text("Time   0"+m+":0"+s+":"+ss,465,190);//0 is
    }else{//defferece notation
      fill(255);
      textSize(13);
      text("Time   0"+m+":0"+s+":0"+ss,465,190);//0 is
    }
  }
  }
  
  if(0<=live_time && live_time<200){//changing text by live time
    fill(255);
    textSize(23);
    text("ope!",493,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("D",470,50);//initial
  }else if(200<=live_time && live_time<400){//changing text by live time
    fill(255);
    textSize(23);
    text("razy!",494,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("C",470,50);//initial
  }else if(400<=live_time && live_time<600){//changing text by live time
    fill(255);
    textSize(23);
    text("rast!",489,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("B",470,50);//initial
  }else if(600<=live_time && live_time<800){//changing text by live time
    fill(255);
    textSize(23);
    text("llright!",492,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("A",470,50);//initial
  }else if(800<=live_time && live_time<1000){//changing text by live time
    fill(255);
    textSize(23);
    text("weet!",490,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("S",470,50);//initial
  }else if(1000<=live_time && live_time<1200){//changing text by live time
    fill(255);
    textSize(22);
    text("how time!",493,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("SS",460,50);//initial
  }else if(1200<=live_time){//changing text by live time
    fill(255);
    textSize(25);
    text("urvival!",510,50);//not initial
    fill(255,0,0);
    textSize(30);
    text("SSS",460,50);//initial
  }

if(mousePressed){//in order to slowly area
  r = r + 70;    //effect gray ellipse's diameter 
  fill(0,0,0,125);
  ellipse(mouseX,mouseY,r,r);//effect glay ellipse
  if(ww==0){//in order to do only once
  tt = game_time;//gain information of time
  ww=1;//it is key in order to do only once
  }
  if(tt<game_time-20){//start after 0.2 second
  n = 5;
  wss=wss+1;//time which used how long
  if(wss==5){//time which used how long
  ws=ws+1;// 1 second
  wss=0;  // 0.2 second
  }
  }
}else{ //return origine time and effect diameter
    fill(0,0,0,125);
    ellipse(mouseX,mouseY,r,r);
    tt = 0; //gained information of time
    n = 100;//framerate
    r = 0;  //effect diameter
    ww = 0; //key in order to do only once   
}

if (ending(boxhit)) {// if box hit is 0
    fill(0);
    rect(0,0,width,height);//result screen
    fill(255);
    textSize(70);
    text("Congraturtion!",50,250);//result comment
  }
}
