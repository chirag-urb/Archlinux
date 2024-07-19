# Function to modify display settings
aliothm() {
    # Read port number from the temporary file
    if [ -f /tmp/alioth_port ]; then
        PORT=$(cat /tmp/alioth_port)
    else
        echo "Port number not found. Please run aliothd first."
        return 1
    fi

    adb shell settings put system accelerometer_rotation 1
    adb shell settings put system user_rotation 0
    adb shell wm density 440
    adb shell wm size 1080x2400
    adb disconnect 192.168.2.245:$PORT

    echo "Modified display settings successfully."
}

# Function to connect and modify display settings
aliothd() {
    echo "Enter the port number:"
    read PORT

    # Save the port number to a temporary file
    echo "$PORT" > /tmp/alioth_port

    adb connect 192.168.2.245:$PORT
    adb shell settings put system accelerometer_rotation 0
    adb shell settings put system user_rotation 1
    adb shell wm density 160
    adb shell wm size 1080x1920
    scrcpy

    echo "Connected and modified display settings successfully."
}
