#!/bin/bash

# Check Enviremont
flutter doctor

# Run flutter run, test whether app can be built without issue
# Have to navigate the selection of device, maybe "flutter run --device-id=<device_name>&"
# Supposedly run in the "background" was not able to completely automate this
# flutter run

# Run flutter test command test whether the test cases pass
flutter test


