#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    // Accept a single command-line argument
    if (argc != 2)
    {
        printf("Usage: ./recover file\n");
        return 1;
    }

    // Open the memory card
    FILE *input = fopen(argv[1], "r");
    if (input == NULL)
    {
        printf("Could not open file.\n");
        return 1;
    }

    // Create a buffer to store 512 bytes from the memory card
    uint8_t buffer[512];

    // Array to store the filename of each recovered JPEG (e.g., "000.jpg")
    char filename[8];

    // Pointer for the output JPEG file, initialized to NULL
    FILE *output = NULL;

    // Counter to keep track of the number of images found
    int count = 0;

    // Read the memory card block by block (512 bytes each) until the end of the file
    while (fread(buffer, sizeof(uint8_t), 512, input) == 512)
    {
        // Check if the current block marks the beginning of a new JPEG file
        // JPEGs start with: 0xff, 0xd8, 0xff, and the fourth byte ranges from 0xe0 to 0xef
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff &&
            (buffer[3] & 0xf0) == 0xe0)
        {
            // If a previous JPEG file is already open, close it before opening a new one
            if (output != NULL)

            {
                fclose(output);
            }

            // Create a formatted filename for the new JPEG image (e.g., 000.jpg, 001.jpg)
            sprintf(filename, "%03i.jpg", count);

            count++;

            // Open a new file to write the recovered JPEG data
            output = fopen(filename, "w");

            if (output == NULL)

            {

                fclose(input);

                return 1;
            }
        }

        // If a JPEG file is currently open, write the 512-byte block to it

        if (output != NULL)

        {

            fwrite(buffer, sizeof(uint8_t), 512, output);
        }
    }

    // Close any remaining open files (both output and input) to prevent memory leaks

    if (output != NULL)

    {

        fclose(output);
    }

    fclose(input);

    return 0;
}
