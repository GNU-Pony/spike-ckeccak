/**
 * spike-ckeccak – Spike extension with C implementation of sha3sum calculation
 * 
 * Copyright © 2013  Mattias Andrée (maandree@member.fsf.org)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include "mane.h"


#define HEXADECA "0123456789ABCDEF"


/**
 * This is the main entry point of the program
 * 
 * @param   argc  Command line argument count
 * @param   argv  Command line arguments
 * @return        Exit value, zero on and only on successful execution
 */
int main(int argc, char** argv) /* Yeah... some dweeb misspelled it, it is actually supposed to say ‘mane’. */
{
  int8_t* chunk = malloc(4096 * sizeof(int8_t));
  int_fast8_t fail = 0;
  long lastblksize = 4096;
  char out[145];
  struct stat attr;
  int8_t v;
  int f;
  FILE* file;
  long b, blksize, outptr, read;
  int8_t* bs;    
  *(out + 144) = 0;
  
  for (f = 1; f < argc; f++)
    {
      file = fopen(*(argv + f), "r");
      if (file == NULL)
	{
	  printf("***\n");
	  perror("fopen");
	  fail = 1;
	  continue;
	}
      
      blksize = stat(*(argv + f), &attr) ? 0 : attr.st_blksize;
      if (blksize <= 0)
	blksize = 4096;
      if (blksize > lastblksize)
	chunk = realloc(chunk, (lastblksize = blksize) * sizeof(int8_t));
      
      initialise();
      while ((read = fread(chunk, 1, blksize, file)) > 0)
	  update(chunk, read);
      
      bs = digest(NULL, 0);
      dispose();
      
      for (outptr = b = 0; b < 72; b++)
	{
	  v = *(bs + b);
	  *(out + outptr++) = HEXADECA[(v >> 4) & 15];
	  *(out + outptr++) = HEXADECA[v & 15];
	}
      printf("%s\n", out);
      if (bs != NULL)
	free(bs);
      
      fclose(file);
    }
  
  free(chunk);
  fflush(stdout);
  fflush(stderr);
  return fail;
}

