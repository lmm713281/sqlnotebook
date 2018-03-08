# `DOWNLOAD` Function

Downloads a file from an HTTP/HTTPS site and returns its contents as a string.

## Syntax

`DOWNLOAD` `(` *url* `)`

## Parameters

- *url* (text): The URL of the file to download.

## Return Value

A string containing the contents of the file.

## Examples

- Prints many lines of text starting with "User-agent: *".

    ```
    PRINT DOWNLOAD('http://google.com/robots.txt');
    ```
