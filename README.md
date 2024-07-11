# Assembly-String-Manipulations
A sophisticated Assembly programming project designed to perform efficient and powerful string operations.
This project showcases the integration of low-level Assembly code with high-level C programming to manipulate and analyze strings.

## Files
- `main.c`: The main C program calls 'run_main'.
- `pstring.h`: Header file declaring the functions used in the project.
- `func_select.s`: Assembly file responsible for selecting and invoking the appropriate string manipulation function based on user input.
- `pstring.s`: Contains the Assembly implementations of various string manipulation functions.
- `run_main.s`: Assembly code that coordinates the execution of functions after parsing user input.

## String Manipulation Functions
The program expects five inputs from the user at the start:

1. Length of the first string (str1)
2. The first string (str1)
3. Length of the second string (str2)
4. The second string (str2)
5. An option to select the desired operation on the strings

### Available Options
#### <ins>pstrlen</ins> (31)

Computes and prints the length of both strings. (Not using the length input from the user)

#### <ins>replaceChar</ins> (32, 33)

Scans two characters from the input and replaces the first character with the second in both strings, then prints the modified strings.

#### <ins>pstrijcpy</ins> (35)

Copies a substring from one string to another. The start index and end index of the substring are specified by the user. The modified strings are then printed.

#### <ins>swapcase</ins> (36)

Converts lowercase characters to uppercase and vice versa in both strings. Other characters remain unchanged. The modified strings are then printed.

#### <ins>pstrijcmp</ins> (37)

Compares specified substrings of both strings. Returns 0 if they are equal, otherwise returns 1.

## Try it:
Open a terminal in your preferred directory, then run these commands:
```bash
git clone https://github.com/tomerp1812/Assembly-String-Manipulations.git
cd Assembly-String-Manipulations
make
```

Run the code with:
```bash
./a.out
```
