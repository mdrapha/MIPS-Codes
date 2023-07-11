# Constants
FOOD_CHAR       .asciiz  "X"  # Character to represent food on the grid
SNAKE_CHAR      .asciiz  "O"  # Character to represent the snake on the grid
WALL_CHAR       .asciiz  "#"  # Character to represent the walls of the grid
GRID_ROWS       .word    20   # Number of rows in the grid
GRID_COLS       .word    20   # Number of columns in the grid
INITIAL_LENGTH  .word    3    # Initial length of the snake

# Data structures
SnakeNode       .struct  x:word, y:word, next:.word  # Structure to represent a node in the snake
Food            .struct  x:word, y:word              # Structure to represent a piece of food

# Data
grid            .space   GRID_ROWS*GRID_COLS         # 2D array to represent the grid
snake           .space   SnakeNode*INITIAL_LENGTH    # Linked list to represent the snake
food            .space   Food                       # Single piece of food
game_over       .asciiz  "Game over!\n"             # Message to print when the game is over
# Initialize the grid
li      $t0, WALL_CHAR
li      $t1, GRID_ROWS
li      $t2, GRID_COLS
li      $t3, 0
li      $t4, 0

init_grid_loop1:
    beq    $t3, $t1, exit_init_grid_loop1
    li     $t4, 0

    init_grid_loop2:
        beq    $t4, $t2, exit_init_grid_loop2
        sb     $t0, grid($t4)
        addi   $t4, $t4, 1
        j      init_grid_loop2

    exit_init_grid_loop2:
        addi   $t3, $t3, 1
        j      init_grid_loop1

exit_init_grid_loop1:

# Initialize the snake
li      $t0, SNAKE_CHAR
li      $t1, INITIAL_LENGTH
li      $t2, 0
li      $t3, 0
li      $t4, snake

init_snake_loop:
    beq    $t2, $t1, exit_init_snake_loop
    sb     $t0, grid($t3)
    sw      $t4, SnakeNode.next($t4)
    addi   $t4, $t4, SnakeNode
    addi   $t2, $t2, 1
    j      init_snake_loop

exit_init_snake_loop:

# Place the food
li      $t0, FOOD_CHAR
li      $t1, Food.x($food)
li      $t2, Food.y($food)

sb      $t0, grid($t1*GRID_COLS+$t2)

# Main game loop
li      $t0, 0    # Initialize direction to "up"
li      $t1, 1    # Initialize speed to 1

game_loop:
    # Update the direction of the snake based on user input
    li $v0, 12
    syscall
    move $t7, $v0

    beq    $t7, 119, move_up    # w
    beq    $t7, 115, move_down  # s
    beq    $t7, 97, move_left   # a
    beq    $t7, 100, move_right # d

    # Update the position of the snake
    li      $t2, SnakeNode.x($snake)
    li      $t3, SnakeNode.y($snake)
    li      $t4, SnakeNode.next($snake)

    # Move the snake in the appropriate direction
    move_up:
        addi   $t2, $t2, -1
        j      update_snake
    move_down:
        addi   $t2, $t2, 1
        j      update_snake
    move_left:
        addi   $t3, $t3, -1
        j      update_snake
    move_right:
        addi   $t3, $t3, 1

update_snake:
    # Check if the snake has hit the wall or itself
    beq    $t2, 0, game_over    # Hit top wall
    beq    $t2, GRID_ROWS, game_over    # Hit bottom wall
    beq    $t3, 0, game_over    # Hit left wall
    beq    $t3, GRID_COLS, game_over    # Hit right wall

    # Check if the snake has eaten the food
    li      $t5, Food.x($food)
    li      $t6, Food.y($food)
    beq    $t2, $t5, eat_food
    beq    $t3, $t6, eat_food

    # Update the snake's position on the grid
    sb      $t0, grid($t2*GRID_COLS+$t3)
    sw      $t4, SnakeNode.next($snake)
    sw      $t2, SnakeNode.x($snake)
    sw      $t3, SnakeNode.y($snake)
    add     $snake, $snake, SnakeNode

    # Update the speed 

    addi	$t6, $t6, 1
    beq     $t6, 10, increase_speed

    increase_speed:
        li $t6,0
        addi $t1, $t1, -1

    # Wait for a short period of time
    j      game_loop

eat_food:
    # Generate new food
    # Generate random row for food
    li      $t0, GRID_ROWS
    li      $t1, 0
    li      $t2, 1
    li      $t3, 1
    li      $t4, 0

    li      $v0, 42      # System call for generating a random number
    move    $a0, $t0     # Load upper bound into $a0
    move    $a1, $t1     # Load lower bound into $a1
    syscall              # Generate random number and store it in $v0
    move    $t4, $v0     # Store random number in $t4

    # Generate random column for food
    li      $t0, GRID_COLS
    li      $t1, 0
    li      $t2, 1
    li      $t3, 1
    li      $t5, 0

    li      $v0, 42      # System call for generating a random number
    move    $a0, $t0     # Load upper bound into $a0
    move    $a1, $t1     # Load lower bound into $a1
    syscall              # Generate random number and store it in $v0
    move    $t5, $v0     # Store random number in $t5

    # Update food structure
    sw      $t4, Food.x($food)
    sw      $t5, Food.y($food)

    # Update grid to show food at new position
    li      $t6, FOOD_CHAR
    sb      $t6, grid($t4*GRID_COLS+$t5)

    j      game_loop

game_over:
        # Display game over message
    li      $v0, 4       # System call for printing a string
    la      $a0, game_over_msg    # Load address of game over message into $a0
    syscall              # Print game over message

    # Wait for user input before exiting
    li      $v0, 12      # System call for reading a single character
    syscall              # Read character from user

    # Exit game
    li      $v0, 10      # System call for exiting the program
    syscall              # Exit program

# Display the grid
display_grid:
li      $t0, 0    # Initialize row counter
li      $t1, 0    # Initialize column counter

display_grid_loop1:
    beq    $t0, GRID_ROWS, exit_display_grid_loop1   # Check if all rows have been printed
    li      $t1, 0    # Reset column counter

    display_grid_loop2:
        beq    $t1, GRID_COLS, exit_display_grid_loop2
                # Print the character at the current position in the grid
        lb      $t2, grid($t0*GRID_COLS+$t1)
        li      $v0, 11      # System call for printing a character
        move    $a0, $t2     # Load character to be printed into $a0
        syscall              # Print character

        # Move to the next column
        addi   $t1, $t1, 1
        j      display_grid_loop2

exit_display_grid_loop2:
    # Move to the next row
    addi   $t0, $t0, 1
    j      display_grid_loop1

exit_display_grid_loop1:
    # Wait for user input before continuing
    li      $v0, 12      # System call for reading a single character
    syscall              # Read character from user

    # Continue with main game loop
    j      game_loop


