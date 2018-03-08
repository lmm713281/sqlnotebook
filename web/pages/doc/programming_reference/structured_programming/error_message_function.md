# `ERROR_MESSAGE` Function

Returns the error message set by the last [`THROW`](throw_statement.html) statement.

## Syntax

`ERROR_MESSAGE` `(` `)`

## Return Value

The last error message. This value may be of any type (not just text).

## Examples

- Prints "Message".

    ```
    BEGIN TRY    
        THROW 'Message';
    END TRY    
    BEGIN CATCH    
        PRINT ERROR_MESSAGE();  
    END CATCH;
    ```
