#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h> // Required for dynamic linking (dlopen, dlsym, dlclose)
#include <string.h>

int main() {
    char op[10];      // Buffer for the operation name (e.g., "grok")
    int num1, num2;   // The two integer operands

    /* Read input formatted as "<string> <int> <int>".
      scanf returns the number of successfully matched items; 
      it will return 3 until it hits EOF (End Of File).
     */
    while (scanf("%s %d %d", op, &num1, &num2) == 3) {
        char lib_path[32];
        
        /*  Construct the file path string. 
          If op is "grok", lib_path becomes "./libgrok.so".
         */
        snprintf(lib_path, sizeof(lib_path), "./lib%s.so", op);

        /* dlopen: Loads the shared library into the process's memory.
          RTLD_NOW: Resolves all symbols immediately. 
          Returns a 'handle' (pointer) to the library.
         */
        void *handle = dlopen(lib_path, RTLD_NOW);
        
        // If the file doesn't exist or cannot be opened, skip this iteration.
        if (!handle) continue;

        /*  dlsym: Searches for the address of the function named 'op' inside 'handle'.
          We cast the return value to a function pointer that takes two ints and returns an int.
         */
        int (*operation)(int, int) = dlsym(handle, op);
        
        if (operation) {
            // Call the dynamically loaded function and print the result.
            printf("%d\n", operation(num1, num2));
        }

        /* dlclose: Unloads the library and frees its memory.
          CRITICAL: Each library is 1.5GB, and our limit is 2GB. 
          We MUST close the current library before the next loop starts
          to avoid a Memory Limit Exceeded error.
         */
        dlclose(handle);
    }
    
    return 0;
}
