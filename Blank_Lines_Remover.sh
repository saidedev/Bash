#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Select the method to remove blank lines:"
    echo "1. Using sed"
    echo "2. Using grep"
    echo "3. Using awk"
    echo "4. Using perl"
    echo "5. Exit"
}

# Function to remove blank lines using sed
remove_blank_lines_sed() {
    sed -i '/^$/d' "$1"
    echo "Blank lines removed from $1 using sed."
}

# Function to remove blank lines using grep
remove_blank_lines_grep() {
    grep -v '^$' "$1" > "$1.temp" && mv "$1.temp" "$1"
    echo "Blank lines removed from $1 using grep."
}

# Function to remove blank lines using awk
remove_blank_lines_awk() {
    awk 'NF' "$1" > "$1.temp" && mv "$1.temp" "$1"
    echo "Blank lines removed from $1 using awk."
}

# Function to remove blank lines using perl
remove_blank_lines_perl() {
    perl -i -ne 'print unless /^$/' "$1"
    echo "Blank lines removed from $1 using perl."
}

# Main function
main() {
    while true; do
        display_menu
        read -p "Enter your choice [1-5]: " choice

        # If "Exit" is selected, break the loop
        if [[ "$choice" -eq 5 ]]; then
            echo "Exiting the loop. Goodbye!"
            break
        fi

        # Ask for file(s) to process
        read -p "Enter the filename(s) (separate multiple files with space): " -a files

        case $choice in
            1) # Using sed
                for file in "${files[@]}"; do
                    if [[ -f "$file" ]]; then
                        remove_blank_lines_sed "$file"
                    else
                        echo "File '$file' not found."
                    fi
                done
                ;;
            2) # Using grep
                for file in "${files[@]}"; do
                    if [[ -f "$file" ]]; then
                        remove_blank_lines_grep "$file"
                    else
                        echo "File '$file' not found."
                    fi
                done
                ;;
            3) # Using awk
                for file in "${files[@]}"; do
                    if [[ -f "$file" ]]; then
                        remove_blank_lines_awk "$file"
                    else
                        echo "File '$file' not found."
                    fi
                done
                ;;
            4) # Using perl
                for file in "${files[@]}"; do
                    if [[ -f "$file" ]]; then
                        remove_blank_lines_perl "$file"
                    else
                        echo "File '$file' not found."
                    fi
                done
                ;;
            *) # Invalid option
                echo "Invalid option. Please try again."
                ;;
        esac
    done

    # After exiting the loop, you can add any code here if needed.
    echo "Script has ended. Thank you for using it!"
}

# Run the script
main
