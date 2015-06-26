# fpcron
Simple multiplatform interval based task scheduler.

# Usage
```
/path/to/fpcron <check interval in milliseconds> /path/to/task/list
```

# Compile

## Requirements
The mighty Free Pascal compiler, any recent version

## Command
```
fpc <add whatever optimizations you want here, -CX -XXs -O3 should be good for everybody> fpcron.pas
```

# How Does It Work?
When you first feed it with a task list file, the program will remember that path. It then check the file every <check interval in milliseconds>, reading the task list one by one.

For each task, it will be computed whether last time the task was executed + its interval in seconds <= now (milliseconds at that time). If the expression is true, the task will be executed and last execution time is updated.

After all tasks have been executed, the task list file is written back with updated last execution time.

# Task List File Format
<16 digits precision floating point, denoting last execution time> <task execution interval in seconds> <task command>

example:

42182.2263973958324641 1 /bin/bash -c 'echo "Hello"'

