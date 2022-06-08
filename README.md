# League Backend Challenge

The original Challenge consists of a main.go with web server written in GoLang. It accepts a single request _/echo_.

I have chosen to solve this challenge using Ruby and Sinatra, as I am most familiar with this stack.
I added the below actions to the server as requested for this challenge.

Given an uploaded csv file
```
1,2,3
4,5,6
7,8,9
```

1. Echo (given)
    - Return the matrix as a string in matrix format.
    
    ```
    // Expected output
    1,2,3
    4,5,6
    7,8,9
    ``` 
2. Invert
    - Return the matrix as a string in matrix format where the columns and rows are inverted
    ```
    // Expected output
    1,4,7
    2,5,8
    3,6,9
    ``` 
3. Flatten
    - Return the matrix as a 1 line string, with values separated by commas.
    ```
    // Expected output
    1,2,3,4,5,6,7,8,9
    ``` 
4. Sum
    - Return the sum of the integers in the matrix
    ```
    // Expected output
    45
    ``` 
5. Multiply
    - Return the product of the integers in the matrix
    ```
    // Expected output
    362880
    ``` 

The input file to these functions is a matrix, of any dimension where the number of rows are equal to the number of columns (square). Each value is an integer, and there is no header row. matrix.csv is example valid input.  

Setup application

Checkout repo and then
```
cd league-matrix
rvm use 2.7.2 # or use any other Ruby version manager to install and use Ruvy version >= 2.7.2
bundle install
```

Run web server
```
ruby run_server.rb # Server will listen on http://localhost:4567
```

Send request
```
curl -X POST -F 'file=@matrix.csv' "http://localhost:4567/echo"
```

Run tests
```
rspec # inside root application folder
```

Tests include all scenerias validation for the valid matrix.csv and also tests for invalid matrix and no file sent.
A get '/' endpoint was added to return an example of request the user can try.

## What we're looking for

- The solution runs
- The solution performs all cases correctly
- The code is easy to read
- The code is reasonably documented
- The code is tested
- The code is robust and handles invalid input and provides helpful error messages
