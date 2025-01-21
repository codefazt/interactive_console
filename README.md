# interactive_console
Una consola interactiva que lee archivos de un directorio y muestra cambios en tiempo real permite a los usuarios monitorear y gestionar archivos de manera eficiente.

# Interactive File Monitor Script

This Bash script monitors files in a specified directory and provides real-time updates on changes. It can display the last few lines of modified files or the first few lines, depending on the user's preference. The script is designed to be interactive and can be customized with various command-line arguments.

## Features

- Monitors a specified directory for file changes.
- Displays the last few lines of modified files or the first few lines based on user input.
- Provides help documentation for command-line arguments.
- Supports dynamic path setting for file monitoring.

## Requirements

- A Unix-like environment (Linux, macOS, or WSL on Windows).
- Bash shell.

## Usage

1. **Make the Script Executable**:
   Before running the script, ensure it is executable. You can do this by running:
   ```bash
   chmod +x interactive_file_monitor.sh

## Run the Script

    ./interactive_file_monitor.sh [options]

## Command-Line Options
--help or -h: Displays help information about the script and its options.

--path <directory>: Sets the path of the directory to monitor for file changes. This argument is required.

-l <number>: Specifies the number of lines to display from modified files. If not set, the default is 20 lines.

--head: Displays the first lines of each modified file instead of the last lines.

-wc: Activates a mode that only shows the last changes affecting the files in the selected directory. Note that this mode may be slower for files with a large number of lines.


## Script Explanation ----------------------------------------------------------------------------------

# Variables
1.- arguemnts: An array to store command-line arguments.

2.- files_array: An array to keep track of files and their modification details.

3,- path: The directory path to monitor.

4.- max_lines: The maximum number of lines to display from modified files (default is 20).

5.- is_wc_method: A boolean flag to indicate if the -wc method is activated.

6.- output_orientation: Determines whether to show the last lines (tail) or the first lines (head) of modified files.

## ------------- Main Logic -------------------------------------------------------------------
# Argument Parsing: The script processes command-line arguments to set the path, line count, and output orientation.

# File Monitoring:

The script lists files in the specified directory and checks their modification dates.
It enters an infinite loop to continuously monitor the files for changes.
Change Detection:

If a file is modified, the script checks how many lines have changed and displays the appropriate lines based on the user's settings.
Output:

Depending on the output_orientation, the script will either show the last few lines or the first few lines of the modified files.