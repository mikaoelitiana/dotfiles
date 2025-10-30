function reset_windowserver -d "Reset Window Server preferences and restart computer"
    # Check if running with sudo privileges
    if test (id -u) -ne 0
        echo "This function requires administrator privileges."
        echo "Running with sudo..."
        sudo fish -c reset_windowserver
        return
    end

    # Backup the current plist file
    set backup_file "/Library/Preferences/com.apple.windowserver.displays.plist.backup."(date +%Y%m%d_%H%M%S)
    echo "Creating backup at: $backup_file"
    cp /Library/Preferences/com.apple.windowserver.displays.plist $backup_file

    # Delete the Window Server preferences
    echo "Removing Window Server preferences..."
    rm /Library/Preferences/com.apple.windowserver.displays.plist

    echo "Window Server preferences have been reset."
    echo "You will now be prompted to restart your computer..."
    
    # Restart the computer with native macOS dialog
    osascript -e 'tell app "System Events" to restart'
end
