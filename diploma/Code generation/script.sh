#!/bin/bash
install_cocoapods() {
    if ! [ -x "$(command -v pod)" ]; then
        echo 'CocoaPods is not installed. Installing CocoaPods...'
        sudo gem install cocoapods
    fi
    check_and_create_podfile
}

check_and_create_podfile() {
    if [ ! -f "Podfile" ]; then
        echo 'Podfile not found. Creating a new Podfile...'
        pod init
        echo 'Podfile created.'
        add_line_to_podfile
        pod install
    else
        echo 'Podfile already exists.'
        add_line_to_podfile
        pod install
    fi
}

add_line_to_podfile() {
    echo "Adding pod 'SwiftTrace' to Podfile..."
    sed -i '' "/# Pods for .*$/a\\
    pod 'SwiftTrace'
    " Podfile
    echo "SwiftTrace added."
}

install_cocoapods
