# X Phishing Template

## Coded By

![Syed Sameer ul Hassan](https://github.com/syed-sameer-ul-hassan.png)

**Name:** Syed Sameer ul Hassan  
**GitHub:** [@syed-sameer-ul-hassan](https://github.com/syed-sameer-ul-hassan)

## How It Works

This template simulates the X (formerly Twitter) login page to capture user credentials.

### Features

- **Realistic Design**: Mimics the official X login interface with accurate styling, colors, and layout
- **Credential Capture**: Captures username, email, or phone and password entered by users
- **Data Collection**: Records IP address, user agent, and timestamp of capture attempts
- **Responsive Layout**: Works seamlessly on desktop and mobile devices
- **Form Validation**: Includes client-side validation for realistic user experience
- **Redirect Behavior**: After credential submission, redirects users to the official X login page
- **Social Login Buttons**: Displays phone, Google, and Apple login options
- **Modal Interface**: Uses a modal popup for the login form matching X's design

### Technical Details

- **Entry Point**: `index.php` - Redirects to login page
- **Login Page**: `login.html` - Main login interface with modal
- **Form Handler**: `login.php` - Processes credential submission
- **JavaScript**: `login.js` - Enhanced interactivity and form handling
- **Styling**: `login.css` - Custom CSS matching X's design language
- **Data Storage**: Captured data saved to JSON format in the capture directory

### Usage

1. Select this template when starting a FishMe session
2. Configure your desired port and tunneling options
3. Share the generated URL with target users
4. Monitor captured credentials through the FishMe viewer
