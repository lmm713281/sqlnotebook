# `CONTINUE` Statement

Restarts the enclosing [`WHILE`](while_statement.html) or [`FOR`](for_statement.html) loop. It is an error to call `CONTINUE` outside of a `WHILE` or `FOR` loop.  

## Syntax

`CONTINUE`

## Examples

- Prints the odd numbers from 1 to 9 in increasing order.

    ```
    DECLARE @counter = 0;  
    WHILE @counter < 10 BEGIN  
        SET @counter = @counter + 1;  
        IF @counter % 2 = 0  
            CONTINUE;  
            PRINT @counter;  
    END;
    ```
