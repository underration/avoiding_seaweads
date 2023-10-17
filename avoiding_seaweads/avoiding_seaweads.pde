/*avoiding seaweads.pde 2022/11/23 */

import ddf.minim.*;  //minimライブラリのインポート
Minim minim;  //Minim型変数であるminimの宣言
AudioPlayer player,BGM;  //サウンドデータ格納用の変数

float vx,vy,x,y;//自物体のベクトル・座標
float Fx,Fy;//成分方向の外力
int r = 30;//一辺の長さ
int rate = 60;//frameRate変数
int NumberOfObjects = 256;//障害物の配列数(ただし偶数)
int h = 50;//障害物の高さ
int[] w = new int[NumberOfObjects];//障害物の幅
int[] objx = new int[NumberOfObjects];
int[] objy = new int[NumberOfObjects];//障害物の座標(x,yが最小の頂点) 

int[] touch= new int[NumberOfObjects];//衝突後判定
int numberofcollision = 0;//衝突回数
int time = 0;//時間変数
int score = 0;//スコア変数
int speed = 0;
int[] highscore = new int[16];
int count = 1;
PImage img1,imgr,imgl,imgf1,imgf2,imgf3,imgf4,imgf5,imgf6;

void setup()
{
    PFont font = createFont("Meiryo", 12);
    textFont(font);
    size(400,400);
    frameRate(rate);
    x = 200;
    y = 180;
    vx = 0;
    vy = -5;
    Fx = 0;
    Fy = 0.3;
    img1 = loadImage("bg_natural_ocean.jpg");
    imgr = loadImage("kaisou_konbu_right.png");
    imgl = loadImage("kaisou_konbu_left.png");
    imgf1 = loadImage("fish1_red_1.png");
    imgf2 = loadImage("fish1_red_2.png");
    imgf3 = loadImage("fish8_yellow.png");
    imgf4 = loadImage("fish8_yellow_2.png");
    imgf5 = loadImage("fish6_purple.png");
    imgf6 = loadImage("fish6_purple_2.png");
    for(int i = 0 ; i < NumberOfObjects ; i ++){
        touch[i] = 0;
    }
    
    
    minim = new Minim(this);  //初期化
    player = minim.loadFile("Motion-Pop08-2.mp3");  //Motion-Pop08-2.mp3をロードする
   

    //BGM.play();  //再生
    //BGM.rewind();
    
}

void draw()
{
     println(vy);
    image(img1,0,0,400,400);
    fill(255,255,255);
    if(numberofcollision<3){
    if( objy[NumberOfObjects -1 ] + h < 0 || numberofcollision == -1){
       //障害物は２つで一組扱い
       numberofcollision = 0;
        for ( int i = 0 ;i < NumberOfObjects; i = i +2){
            w[i]  = 30*(int)random(1,11);
            w[i+1] = 400 - w[i];
            objx[i] = 0;
            objx[i+1] = w[i] + 100;//左の物体の幅と100の隙間を足した位置
            objy[i] = 100*(i+4);
            objy[i+1] = 100*(i+4);
        } 
    }
    //障害物の衝突判定
    for ( int i = 0 ; i < NumberOfObjects; i ++){
        if  ( (objx[i] < x + r && x < objx[i] + w[i]) && (objy[i] < y + r && y < objy[i] + r) )
            {
                touch[i] = 1;
                println(i);
                break;
            }
        if ( touch[i] == 1){
            numberofcollision++;
            touch[i] = 0;
        }
    }

    //操作する図形の制御
    vx = Fx + 0.8*vx;
    vy = Fy +0.8*vy + 0.5;
    y = y + vy;
    x = x + vx;
    /*rect(x,y,r,r);//当たり判定部分の表示*/
    //操作する魚描写関数 衝突回数1:赤,2:黄色, 3:紫
    if(vx<0){
        switch(numberofcollision){
            case 0:
            image(imgf1,x-5,y-5,40,40);
            break;
            case 1:
            image(imgf3,x-5,y-5,40,40);
            break;
            case 2:
            image(imgf5,x-5,y-5,40,40);
            break;
        }
    }else{
        switch(numberofcollision){
            case 0:
            image(imgf2,x-5,y-5,40,40);
            break;
            case 1:
            image(imgf4,x-5,y-5,40,40);
            break;
            case 2:
            image(imgf6,x-5,y-5,40,40);
            break;
        }
    }

    if ( y + r > height){
        y = 400 -r;
        vy = -vy*0.4;
    }
    if ( y < 0){
        y = 0;
        vy = -vy*0.4;
    }
    if ( x + r> width){
        x = 400-r;
        vx = -vx*0.4;
    }
    if ( x < 0){
        x = 0;
        vx = -vx*0.4;
    }

    for (int i = 0 ; i < NumberOfObjects; i ++){
        if((objx[i] < x + r && x < objx[i] + w[i]) && (objy[i] < y + r && y < objy[i] + r)){
            if ( objx[i] < x + r +1 || x < objx[i] + w[i] -1 ){
                vx = -vx;
            }
            if (objy[i] < y + r || y < objy[i] + r ){
                vy = - vy;
            }
        }
    }
    //障害物生成し動かす
    int konbuHeight = h + 50;//昆布の画像の高さ
    if ( time % (10*rate) == 0){
        speed++;
    }
    for (int i = 0; i < NumberOfObjects ; i ++){
        /*rect(objx[i],objy[i],w[i],h);*/
        if( i % 2 == 0){
            image(imgl,objx[i]-20,objy[i]-25,w[i]*1.1,konbuHeight);
        }
        else {
            image(imgr,objx[i],objy[i]-25,w[i]*1.1+20,konbuHeight);
        }
        objy[i] = objy[i] - speed;
     }
    //スコア演算
    time++;
    score = time/60;
    //デバッグ
    text("(x,y)=("+(int)x+","+(int)y+")",0,10);
    text("さかなの元気さ:"+(3-numberofcollision),0,30);
    text("スコア:"+score,0,50);
    //text("Turn on or off BGM: B",260,10);
    text("：ルール説明：",0,360);
    text("十字キー：移動",0,380);
    text("スペース：上に泳ぐ",0,400);
    }

    else{
        text("Try again by pressing 'R'",width/2,height/2);
        highscore[count] = score;
        sort(highscore);
        if(count > 8){
            count = 8;
        }
        for(int i = 0 ; i < count ; i ++){
        text("highscore",100,100);
        text((i+1)+":"+highscore[count-i],100,(120+20*i));
        }
    }
}
//キー入力判定
void keyPressed() {
    if ( keyCode == UP || keyCode == ' '){
    vy = -10;
    }
    if ( keyCode == RIGHT){
        vx = 7;
    }
    if ( keyCode == LEFT){
        vx = -7;
    }
    if ( keyCode == DOWN){
        vy = vy + 5;
    }
    if( numberofcollision < 3){
        player.play();  //再生
        player.rewind();
        }
    //'r','R'keyでリセット
    if ( key == 'r' || key == 'R'){
    x = 200;
    y = 180;
    vx = 0;
    vy = -10;
    numberofcollision = -1;
    time = 0;
    count++;
    speed = 0;
    }
    /*if ( key =='b'){
        boolean  ret  =  BGM.isPlaying( ) ;
        if(ret == true){
            BGM.pause( ) ;
        }
        else{
            BGM.play( ) ;
        }
    }*/
}
