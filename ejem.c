
//gcc -o ejem ejem.c -lSDL2 -lm -lSDL2_ttf


#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<SDL2/SDL.h>
#include<SDL2/SDL_ttf.h>

#define XSIZE 800 //Ancho de pantalla
#define YSIZE 400 // Alto de pantalla

float Frec=1,Amp=151; //Frecuencia y amplitud de la señal //151
int   HXSIZEM=600,HYSIZEM=200; //Para posicionar la señal en el centro del marco



//Dibuja la rejilla
void drawGrid(int x, int y,int w, int h,SDL_Renderer *renderer) {
  int i,j,auxx,auxy;
  int cols = 20;
  int rows = 20;
  int cellWidth = roundf((float)w / (float)cols);
  int cellHeight = roundf((float)h / (float)rows);
  auxx = x;
  auxy = y;
  SDL_SetRenderDrawColor(renderer,0,0,0,0);
  //Dibuja columnas
  for(i = 1; i < cols; i++) {
    x = i * cellWidth;
    for( j = 0; j < h; j++) {
	SDL_RenderDrawPoint(renderer,x+auxx,j+auxy);
        if(j%5==0){j=j+2;}
    }
  }
  // Dibuja las filas 
  for( i = 1; i < rows; i++) {
    y = i * cellHeight;
    for( j = 0; j < w; j++) {
	SDL_RenderDrawPoint(renderer,j+auxx,y+auxy);
        if(j%5==0){j=j+2;}
    }
  }
}

//Dibuja recuadros
void drawRecu(int x,int y,int w, int h,SDL_Renderer *renderer) {
  int i,j,aux;
  SDL_SetRenderDrawColor(renderer,255,0,0,0);
  aux=x;
  //Dibuja las dos columnas
  for(i = 1; i < 3 ; i++) {
    if(i==2){
     x= x+w;} 

    for(j = y; j < y+h+1; j++) {
	SDL_RenderDrawPoint(renderer,x,j);
    }
  }
 x =aux;
  // Dibuja las dos filas 
  for(i = 1; i <3 ; i++) {
    if(i==2){
    y= y+h;}   

    for( j = x; j < x+w+1; j++) {
	SDL_RenderDrawPoint(renderer,j,y);
    }
  }
}

//Dibuja recuadros Solidos
void drawRecSo(int x,int y,int w, int h,SDL_Renderer *renderer) {
  int i,j,aux;
  SDL_SetRenderDrawColor(renderer,255,255,255,0);
  aux=y;
  //Dibuja las columnas
  for(i = x; i < x+w+1 ; i++) {
    for(j = y; j < aux+h+1; j++) {
	SDL_RenderDrawPoint(renderer,i,j);
    }
    y=aux;
  }


}

void drawtext(SDL_Renderer *renderer,SDL_Surface *superficie,SDL_Texture *textura,
              TTF_Font *font0,TTF_Font *font1,TTF_Font *font2){

   char mensaje0[] = "GRAFICADOR DE FUNCIONES";
   char mensaje1[] = "Amplitud(de 1 a 190)";
   char mensaje2[] = "Frecuencia(potencias de 10, de 1 a 1000)";
   char mensaje31[] = "Ingrese los valores de Amplitud y frecuencia, luego";
   char mensaje311[] = "presione:";
   char mensaje32[] = " S para graficar una onda senoidal";
   char mensaje33[] = " C para graficar una onda cuadrada";
   char mensaje34[] = " D para graficar una onda diente de sierra";
   char mensaje35[] = " T para graficar una onda triangular";
   char mensaje4[] = "ETN-903   GRUPO-";
   int texW = 0;
   int texH = 10;

   SDL_Color color0 = { 0xFF,0xF8,0x3B };
   SDL_Color color1 = { 0xFF,0xF8,0x00 };
   SDL_Color color2 = { 0xFF,0xF8,0x3B };
   superficie = TTF_RenderText_Solid(font0, mensaje0, color0);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect = { 10, 10, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect); 

   superficie = TTF_RenderText_Solid(font1, mensaje1, color1);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect1 = { 10, 50, texW, texH };// posicion x,y //recuadro 10,80,370,20
   SDL_RenderCopy(renderer, textura, NULL, &dstrect1);  

   superficie = TTF_RenderText_Solid(font1, mensaje2, color1);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect2 = { 10, 110, texW, texH };// posicion x,y//recuadro10,140,370,20
   SDL_RenderCopy(renderer, textura, NULL, &dstrect2);

   superficie = TTF_RenderText_Solid(font2, mensaje31, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect3 = { 10, 170, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect3); 
   superficie = TTF_RenderText_Solid(font2, mensaje311, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect31 = { 10, 200, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect31);   
   superficie = TTF_RenderText_Solid(font2, mensaje32, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect4 = { 10, 230, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect4);  
   superficie = TTF_RenderText_Solid(font2, mensaje33, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect5 = { 10, 260, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect5);  
   superficie = TTF_RenderText_Solid(font2, mensaje34, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect6 = { 10, 290, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect6);  
   superficie = TTF_RenderText_Solid(font2, mensaje35, color2);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect7 = { 10, 320, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect7);  

   superficie = TTF_RenderText_Solid(font0, mensaje4, color0);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect8 = { 10, 350, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect8);
}
// Grafica la funcion seno
int seno(float F,float A,SDL_Renderer *renderer)
#define DELTA 2
#define N 1.05*360
#define W M_PI/180
{
    float t=0, y;
    int X[390], Y[390];//Y151 Amplitud maxima
    SDL_SetRenderDrawColor(renderer, 0,0,255,0);
    for(int i=0;i<=N/DELTA;i++)//N/DELTA
    {
        X[i] = floor(t) ;
        y = floor(A*sin(F*W*t));
        Y[i] = -y + HYSIZEM;
        t = t + DELTA;
    }
    for(int i=0;i<=N/DELTA-1;i++)
        SDL_RenderDrawLine(renderer,410+X[i],Y[i],410+X[i+1],Y[i+1]);
}

void escala(int F,int A,SDL_Surface *superficie,SDL_Texture *textura,
            TTF_Font *font3,SDL_Renderer *renderer )
{
   char xxmax[100];
   char yymax[100];
   int texW = 0;
   int texH = 10;
   
   if( F==1){
   char xxmax[10]="1 [s]";
   }
   else if (F==10){
   char xxmax[10]="0.1 [s]";
   }   
   else if (F==100){
   char xxmax[10]="0.01 [s]";
   }  
   else if (F==1000){
   char xxmax[10]="0.001 [s]";
   }     

   if( A==1){
   char yymax[10]="1 [V]";
   }
   else if (A==2){
   char yymax[10]="2 [V]";
   }   
   else if (A==3){
   char yymax[10]="3 [V]";
   }  
   else if (A==4){
   char yymax[10]="4 [V]";
   }  
   else if (A==5){
   char yymax[10]="5 [V]";
   }  
   else if (A==6){
   char yymax[10]="6 [V]";
   }  
   else if (A==7){
   char yymax[10]="7 [V]";
   }  
   else if (A==8){
   char yymax[10]="8 [V]";
   }  
   else if (A==9){
   char yymax[10]="9 [V]";
   }  
   else if (A==10){
   char yymax[10]="10 [V]";
   }
 
   


   

   SDL_Color color = { 255,0,0 };
   superficie = TTF_RenderText_Solid(font3, xxmax, color);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect = { 762, 380, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect);
   
   superficie = TTF_RenderText_Solid(font3, yymax, color);
   textura = SDL_CreateTextureFromSurface(renderer, superficie);
   SDL_QueryTexture(textura, NULL, NULL, &texW, &texH);
   SDL_Rect dstrect1 = { 420, 200-A, texW, texH };// posicion x,y
   SDL_RenderCopy(renderer, textura, NULL, &dstrect1);



}

// Grafica la funcion cuadrada
int cuadrado(float F,float A,SDL_Renderer *renderer)
{
        SDL_SetRenderDrawColor(renderer, 0,0,255,0);
        SDL_RenderDrawLine(renderer,410,200-A,410+181,200-A);
	SDL_RenderDrawLine(renderer,410+181,200-A,410+181,200+A);
	SDL_RenderDrawLine(renderer,410+181,200+A,410+361,200+A);
	SDL_RenderDrawLine(renderer,410+361,200+A,410+361,200-A);
	SDL_RenderDrawLine(renderer,410+361,200-A,410+380,200-A);
}

// Grafica la funcion triangular
int triangular(float F,float A,SDL_Renderer *renderer)
{
        SDL_SetRenderDrawColor(renderer, 0,0,255,0);
        SDL_RenderDrawLine(renderer,410,200,410+91,200-A);
	SDL_RenderDrawLine(renderer,410+91,200-A,410+272,200+A);
	SDL_RenderDrawLine(renderer,410+272,200+A,410+380,200-38);

}
// Grafica la funcion triangular
int dienteS(float F,float A,SDL_Renderer *renderer)
{
        SDL_SetRenderDrawColor(renderer, 0,0,255,0);
        SDL_RenderDrawLine(renderer,410,200+A,410+181,200-A);
	SDL_RenderDrawLine(renderer,410+181,200-A,410+181,200+A);
	SDL_RenderDrawLine(renderer,410+181,200+A,410+361,200-A);
	SDL_RenderDrawLine(renderer,410+361,200-A,410+361,200+A);
	SDL_RenderDrawLine(renderer,410+361,200+A,410+380,200+A-38);

}


// Programa principal
int main(void)
{   // Verificacion de inicio de SDL
   if(SDL_Init(SDL_INIT_EVERYTHING) < 0){
     SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,"Error",SDL_GetError(), NULL);
     SDL_Quit();
     return -1; 
   }
   else  {
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_INFORMATION,"ok","SDL iniciado", NULL);
   }
   TTF_Init();
   int terminar;  //Si es 1 el programa finaliza
   unsigned typeEvent; //Evento de entrada
   const unsigned char *keys; 
   char path[] = "/usr/share/fonts/truetype/ubuntu/Ubuntu-B.ttf";
   
   SDL_Window *window;     //Pantalla
   SDL_Renderer *renderer;
   SDL_Event event;
   SDL_Surface *superficie;// texto
   SDL_Texture *textura;  
   TTF_Font *font0 = TTF_OpenFont(path,20);// tamaño titulos
   TTF_Font *font1 = TTF_OpenFont(path,18);// tamaño subtitulos
   TTF_Font *font2 = TTF_OpenFont(path,16);// tamaño mensaje
   TTF_Font *font3 = TTF_OpenFont(path,10);// tamaño escala
   window = SDL_CreateWindow("Graficadora",SDL_WINDOWPOS_UNDEFINED,
				SDL_WINDOWPOS_UNDEFINED, XSIZE, YSIZE,
				SDL_WINDOW_SHOWN);//Crea la ventana con titulo

   renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

   terminar = 0;//Esta condicion mantiene al programa abierto
   keys = SDL_GetKeyboardState(NULL);//Guarda en keys el evento del teclado

      SDL_SetRenderDrawColor(renderer,0,0,100,0);//Color dela ventana:negro
      SDL_RenderClear(renderer);//Limpia la ventana
      SDL_RenderPresent(renderer);//Actualiza la ventana
      drawtext(renderer,superficie, textura,font0,
               font1,font2);// Crea los textos de interfaz
      SDL_RenderPresent(renderer);
      drawRecSo(410,10,380,380,renderer); // x,y, ancho, altura
      SDL_RenderPresent(renderer); // para grafica
      drawRecSo(10,80,370,20,renderer); // x,y, ancho, altura
      SDL_RenderPresent(renderer); // para recuadro de amplitud
      drawRecSo(10,140,370,20,renderer); // x,y, ancho, altura
      SDL_RenderPresent(renderer);// para recuadro de frecuencia
      drawGrid(410,10,380,380, renderer);//Dibuja la rejilla
      SDL_RenderPresent(renderer);
   while(!terminar) //Mientras terminar sea 0 estara en el bucle
   {  //Eventos
      if(SDL_PollEvent(&event))
      {
             typeEvent = event.type;
	     if(typeEvent==SDL_QUIT)//Click en el icono de cerrar de la ventana
     	     {
	        terminar =1; //Finaliza el el siguiente ciclo
             }
	     else if (typeEvent==SDL_KEYDOWN) // Evento presionar tecla
	     {
                if(keys[SDL_SCANCODE_ESCAPE]) //Se presiono ESC
		{
		   terminar=1;		
		}
		else if (keys[SDL_SCANCODE_S])//Se presiono S
		{
		   // seno
		    seno(Frec,Amp,renderer);
                    SDL_RenderPresent(renderer);
		}
		else if (keys[SDL_SCANCODE_C])//Se presiono C
		{
		   //pendiente cuadrado
	             cuadrado(Frec,Amp,renderer);
		     SDL_RenderPresent(renderer);

		}
		else if (keys[SDL_SCANCODE_T])//Se presiono T
		{
		   //pendiente triangular
	             triangular(Frec,Amp,renderer);
		     SDL_RenderPresent(renderer);
		}
		else if (keys[SDL_SCANCODE_D])//Se presiono D
		{
		   //pendiente diente de sierra
	             dienteS(Frec,Amp,renderer);
		     SDL_RenderPresent(renderer);
		}
                escala(Frec,Amp,superficie, textura,font3, renderer);
                SDL_RenderPresent(renderer);
	     }
      }

   }
   //Cerrando servicios y librerias
   SDL_DestroyRenderer(renderer);
   SDL_DestroyWindow(window);

   TTF_CloseFont(font0);
   TTF_CloseFont(font1);
   TTF_CloseFont(font2);
   TTF_CloseFont(font3);
   SDL_DestroyTexture(textura);
   SDL_FreeSurface(superficie);   
   TTF_Quit();
   SDL_Quit();
return 0;//exit
}



