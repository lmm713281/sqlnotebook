# `PRINT` Statement

Prints the *expression* to the script or console output.  

## Syntax

<railroad-diagram>
'PRINT',
NonTerminal('expression')
</railroad-diagram>

## Parameters

- *expression*: The value to be printed.

## Examples

- Prints 5.

    ```
    PRINT 5;
    ```

- Prints 3.

    ```
    PRINT 1 + 2;
    ```

- Prints "Hello world".

    ```
    PRINT 'Hello world';
    ```

- Prints the number of rows in `mytable`.

    ```
    PRINT (SELECT COUNT(*) FROM mytable);
    ```
