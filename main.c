
/***************************************************************/
// Proyecto
// Ley de ohm
// compilar:    gcc -o main main.c -lSDL2 -lm
// run:      ./main  
/***************************************************************/
#include <stdio.h>
#include <SDL2/SDL.h>
#define anchoVentana 640  //pixels
#define altoVentana 480 //pixels
SDL_Window *ventana = NULL;
SDL_Renderer *renderizador = NULL;
int estado0 = 0; //0= detenido; 1= corriendo

/************************** Funciones **************************/
// Inicia SDL
void iniciarSDL(){
    SDL_Init(SDL_INIT_EVERYTHING);
    if(SDL_Init(SDL_INIT_EVERYTHING) < 0){
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,"Error de inicialización en SDL",  SDL_GetError(), NULL);
        SDL_Quit();
    }
    
}
// Crea la ventana
void creaVentana(){
    ventana = SDL_CreateWindow("Laboratorio: Ley de Ohm",0,0,anchoVentana,altoVentana,SDL_WINDOW_SHOWN);
    if(ventana == NULL){
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,"Error de crreación de ventana",  SDL_GetError(), NULL);
        SDL_Quit();
    }
}
// Inicia el renderizador
void iniciaRenderizador(){
    renderizador = SDL_CreateRenderer(ventana,-1,SDL_RENDERER_ACCELERATED);
    if(renderizador == NULL){
        SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR,"Error de crreación de inicio del renderizador",  SDL_GetError(), NULL);
        SDL_Quit();
    }
}
// Renderiza la interfaz del simulador
void renderizaInterfaz(){
    char cF0[] = {0xDF,0xE6,0xE9,255}; //Color de fondo
    char cF1[] = {0xB2,0xBE,0xC3,255};
    char cC0[] = {0x00,0x00,0x00,255}; // Color de contorno
    // --Funciones
    // Dibuja recuadros no sólidos
    void dibujarRecu(int x, int y, int ancho, int altura, char color[]) {
        int i,j,aux;
        SDL_SetRenderDrawColor(renderizador,color[0],color[1],color[2],color[3]);
        aux=x;
        for(i = 1; i < 3 ; i++) { //Dibuja las dos columnas
            if(i==2){x= x + ancho - 1;} 
            for(j = y; j < y + altura; j++) {
                SDL_RenderDrawPoint(renderizador,x,j);
            }
        }
        x =aux;
        for(i = 1; i < 3 ; i++) { // Dibuja las dos filas 
            if(i==2){y= y + altura -1;}   
            for( j = x; j < x + ancho; j++) {
                SDL_RenderDrawPoint(renderizador,j,y);
            }
        }
    }
    // Dibuja recuadros sólidos
    void dibujarRecuSo(int x, int y, int ancho, int altura, char color[]) {
        int i,j,aux;
        SDL_SetRenderDrawColor(renderizador,color[0],color[1],color[2],color[3]);
        aux=y;
        for(i = x; i < x + ancho ; i++) { //Dibuja columnas
            for(j = y; j < aux + altura; j++) {
                SDL_RenderDrawPoint(renderizador,i,j);
            }
            y=aux;
        }
    }
    // Fondo
    SDL_SetRenderDrawColor(renderizador,cF0[0] ,cF0[1] ,cF0[2] ,cF0[3]); // RGB,alpha
    SDL_RenderClear(renderizador);
    // Contenedores
    dibujarRecu(5,5,anchoVentana - 5 * 2,altoVentana - 5 * 2,cC0);// contorno - principal
    dibujarRecuSo(6,6,anchoVentana - 6 * 2,altoVentana - 6 * 2,cF1);// relleno-  principal
    dibujarRecu(anchoVentana /2 -50,20,100,25,cC0);// contorno - titulo
    dibujarRecu(20,60,anchoVentana/4-30,altoVentana/2-60 - 5 + 10,cC0);// contorno - fuente de voltaje
    dibujarRecu(anchoVentana/4,60,anchoVentana/4,altoVentana/2-60 - 5 +10 ,cC0);// contorno - amperimetro
    dibujarRecu(anchoVentana/4 + 5,65,anchoVentana/4 -10,anchoVentana/4 -10,cC0);// contorno - medidor - amperimetro
    dibujarRecu(20,altoVentana/2-60 - 5 + 60 + 30,anchoVentana/2-30+10,altoVentana/2-60 - 5 +20,cC0);// contorno - protoboard
    dibujarRecu(anchoVentana/2+10,60,anchoVentana/2-30,40,cC0);// contorno - voltaje
    dibujarRecu(anchoVentana/2+10 +160,65,anchoVentana/2-30 -165,40-10,cC0);// contorno - voltaje-entrada
    dibujarRecu(anchoVentana/2+10,110,anchoVentana/2-30,40,cC0);// contorno - Resistencia
    dibujarRecu(anchoVentana/2+10 +160,65+50,anchoVentana/2-30 -165,40-10,cC0);// contorno - resistencia-entrada
    dibujarRecu(anchoVentana/2+10,160,anchoVentana/2-30,40,cC0);// contorno - Boton simular
    dibujarRecu(anchoVentana/2+10,220,anchoVentana/2-30,altoVentana/2-60 - 5 +65,cC0);// contorno - protoboard



}

void salir(){
    SDL_DestroyWindow(ventana);
    SDL_DestroyRenderer(renderizador);
    ventana = NULL;
    renderizador = NULL;
    SDL_Quit();
}
// Escucha eventos del teclado
void escuchaEventos(){
    SDL_Event evento;
    // manejador de eventos del teclado
    void manejadorEventosTeclado(SDL_Keysym* keysym){
        switch(keysym -> sym){
            case SDLK_ESCAPE:
                estado0 = 0;
                salir();
                break;
            case SDLK_RETURN:
                printf("Apretaste ENTER");
                break;
            default:
                printf("simbolo desconocido");
        }
    }
    while(estado0){
        while(SDL_PollEvent(&evento)){
            switch (evento.type){
                case SDL_QUIT :     
                    estado0 = 0;
                    salir();
                    break;//icono de salir
                case SDL_KEYDOWN :  
                    manejadorEventosTeclado(&evento.key.keysym);
                    break;     
                default : ;
                    // printf("Evento no programado.");
            }
        }
    }
}

/********************* Programa Principal **********************/
void main(){
    iniciarSDL();
    creaVentana();
    iniciaRenderizador();
    renderizaInterfaz();
    estado0 = 1; //
    SDL_RenderPresent(renderizador);
    escuchaEventos();
    // creaVentana();
    

}

