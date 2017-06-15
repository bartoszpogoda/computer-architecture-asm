
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "SDL.h"
#include "SDL_image.h"

// function defined in counter.s (lab 3.2)
extern unsigned long long int counter();

extern void FilterASM(unsigned char * buf, int width,int height);

void FilterC(unsigned char * buf, int width, int height){
	int size = width*height;
	int PIXEL_DISTANCE = 50;

	while(size--){
		*(buf) = (*buf/4)*3 + (*(buf + PIXEL_DISTANCE)/4);

		buf += 1;
	}
}

// Most of the code below is not written by me (source http://zak.ict.pwr.wroc.pl)

SDL_Surface* Load_image(char *file_name){
		/* Open the image file */
		SDL_Surface* tmp = IMG_Load(file_name);
		if ( tmp == NULL ) {
			fprintf(stderr, "Couldn't load %s: %s\n",
			        file_name, SDL_GetError());
				exit(0);
		}
		return tmp;
}

void Paint(SDL_Surface* image, SDL_Surface* screen)
{
		SDL_BlitSurface(image, NULL, screen, NULL);
		SDL_UpdateRect(screen, 0, 0, 0, 0);
};

int main(int argc, char *argv[])
{
	Uint32 flags;
	SDL_Surface *screen, *image;
	int depth, done;
	SDL_Event event;

	/* Check command line usage */
	if ( ! argv[1] ) {
		fprintf(stderr, "Usage: %s <image_file>, (int) size\n", argv[0]);
		return(1);
	}

	if ( ! argv[2] ) {
		fprintf(stderr, "Usage: %s <image_file>, (int) size\n", argv[0]);
		return(1);
	}

	/* Initialize the SDL library */
	if ( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
		fprintf(stderr, "Couldn't initialize SDL: %s\n",SDL_GetError());
		return(255);
	}

	flags = SDL_SWSURFACE;
	image = Load_image( argv[1] );
	printf( "\n\nImage properts:\n" );
	printf( "BitsPerPixel = %i \n", image->format->BitsPerPixel );
	printf( "BytesPerPixel = %i \n", image->format->BytesPerPixel );
	printf( "width %d ,height %d \n\n", image->w, image->h );


	printf("Usage: F - filterC , G - filterASM, R - reload\n");

	SDL_WM_SetCaption(argv[1], "showimage");

	/* Create a display for the image */
	depth = SDL_VideoModeOK(image->w, image->h, 32, flags);
	/* Use the deepest native mode, except that we emulate 32bpp
	   for viewing non-indexed images on 8bpp screens */
	if ( depth == 0 ) {
		if ( image->format->BytesPerPixel > 1 ) {
			depth = 32;
		} else {
			depth = 8;
		}
	} else
	if ( (image->format->BytesPerPixel > 1) && (depth == 8) ) {
    		depth = 32;
	}
	if(depth == 8)
		flags |= SDL_HWPALETTE;
	screen = SDL_SetVideoMode(image->w, image->h, depth, flags);
	if ( screen == NULL ) {
		fprintf(stderr,"Couldn't set %dx%dx%d video mode: %s\n",
			image->w, image->h, depth, SDL_GetError());
	}

	/* Set the palette, if one exists */
	if ( image->format->palette ) {
		SDL_SetColors(screen, image->format->palette->colors,
	              0, image->format->palette->ncolors);
	}


	/* Display the image */
	Paint(image, screen);

	unsigned long long int timerStart = 0, timerEnd = 0;

	done = 0;
	int size =atoi( argv[2] );
	while ( ! done ) {
		if ( SDL_PollEvent(&event) ) {
			switch (event.type) {
			    case SDL_KEYUP:
				switch (event.key.keysym.sym) {
				    case SDLK_ESCAPE:
				    case SDLK_TAB:
				    case SDLK_q:
					done = 1;
					break;
				    case SDLK_SPACE:
				    case SDLK_f:
					SDL_LockSurface(image);


					printf("Start filtering (C)...  ");
					timerStart = counter();
					FilterC(image->pixels,image->w,image->h);
					timerEnd = counter();
					printf("Done in %llu cycles.\n", timerEnd-timerStart);

					SDL_UnlockSurface(image);

					printf("Repainting after filtered...  ");
					Paint(image, screen);
					printf("Done.\n");

					break;
					case SDLK_g:
					SDL_LockSurface(image);


					printf("Start filtering (ASM)...  ");
					timerStart = counter();
					FilterASM(image->pixels,image->w,image->h);
					timerEnd = counter();
					printf("Done in %llu cycles.\n", timerEnd-timerStart);

					SDL_UnlockSurface(image);

					printf("Repainting after filtered...  ");
					Paint(image, screen);
					printf("Done.\n");

					break;
				    case SDLK_r:
					printf("Reloading image...  ");
					image = Load_image( argv[1] );
					Paint(image,screen);
					printf("Done.\n");
					break;
				    case SDLK_PAGEDOWN:
				    case SDLK_DOWN:
				    case SDLK_KP_MINUS:
					size--;
					if (size==0) size--;
					printf("Actual size is: %d\n", size);
				        break;
				    case SDLK_PAGEUP:
				    case SDLK_UP:
				    case SDLK_KP_PLUS:
					size++;
					if (size==0) size++;
					printf("Actual size is: %d\n", size);
					break;
				   case SDLK_s:
					printf("Saving surface at nowy.bmp ...");
					SDL_SaveBMP(image, "nowy.bmp" );
					printf("Done.\n");
				    default:
					break;
				}
				break;
//			    case  SDL_MOUSEBUTTONDOWN:
//				done = 1;
//				break;
                            case SDL_QUIT:
				done = 1;
				break;
			    default:
				break;
			}
		} else {
			SDL_Delay(10);
		}
	}
	SDL_FreeSurface(image);
	/* We're done! */
	SDL_Quit();
	return(0);
}
