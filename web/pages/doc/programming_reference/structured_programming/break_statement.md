# `BREAK` Statement

Terminates the enclosing [`WHILE`](while_statement.html) or [`FOR`](for_statement.html) loop. It is an error to call `BREAK` outside of a `WHILE` or `FOR` loop.  

## Syntax

`BREAK`

## Examples

- Prints the numbers 1 to 10 in increasing order.

    ```
    DECLARE @counter = 1;  
    WHILE 1 BEGIN  
        PRINT @counter;  
        SET @counter = @counter + 1;  
        IF @counter > 10  
            BREAK;  
    END;
    ```
