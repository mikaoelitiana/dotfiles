function reset_windowserver -d "Reset Window Server preferences and restart computer"
    # Check if running with sudo privileges
    if test (id -u) -ne 0
        echo "This function requires administrator privileges."
        echo "Running with sudo..."
        sudo fish -c "reset_windowserver"
        return
    end
    
    # Backup the current plist file
    set backup_file "/Library/Preferences/com.apple.windowserver.plist.backup."(date +%Y%m%d_%H%M%S)
    echo "Creating backup at: $backup_file"
    cp /Library/Preferences/com.apple.windowserver.plist $backup_file
    
    # Delete the Window Server preferences
    echo "Removing Window Server preferences..."
    rm /Library/Preferences/com.apple.windowserver.plist
    
    echo "Window Server preferences have been reset."
    echo "The computer will restart in 5 seconds..."
    sleep 5
    
    # Restart the computer
    shutdown -r now
end
