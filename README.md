# Luxury Restaurant App

A Flutter mobile application for a luxury restaurant with comprehensive features including authentication, food ordering, table reservations, and user profile management.

## Features

### Authentication
- Login and Registration screens
- Persistent login state using SharedPreferences

### Dashboard
- Search functionality for dishes
- Horizontal scrolling categories (Starters, Non-Veg, etc.)
- Featured dishes with ratings and prices
- User favorites section
- Profile access via user icon

### Food Management
- Detailed food item view with images, ratings, descriptions
- Quantity selection and add to cart functionality
- Shopping cart with item management
- Checkout process with order/reservation options

### Reservations
- Calendar-based table reservation system
- Guest count selection
- Available time slots
- Reservation confirmation and management

### User Profile
- User information and statistics
- Order history with filtering (All, Completed, Cancelled, Upcoming)
- Favorites management with recommendations
- Loyalty points system with rewards
- Payment method selection
- Reservation management with cancellation
- Settings (language, profile editing, notifications, logout)

## Setup Instructions

1. **Install Flutter**: Make sure you have Flutter installed on your system
2. **Get Dependencies**: Run `flutter pub get` in the project directory
3. **Run the App**: Use `flutter run` to start the application

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── app_data.dart        # Data models and dummy data
└── screens/
    ├── auth/                # Authentication screens
    ├── dashboard/           # Main dashboard
    ├── food/               # Food detail screens
    ├── cart/               # Shopping cart
    ├── checkout/           # Checkout process
    ├── reservation/        # Table reservation
    ├── search/             # Search functionality
    └── profile/            # User profile and settings
```

## Key Dependencies

- `shared_preferences`: For persistent login state
- `table_calendar`: For reservation calendar functionality
- `cupertino_icons`: For iOS-style icons

## Design Features

- Luxury black and gold color scheme
- Card-based UI with shadows and rounded corners
- Horizontal scrolling sections for better UX
- Responsive design with proper spacing
- Emoji-based food images for simplicity

## Dummy Data

The app includes comprehensive dummy data for:
- Food items with categories, prices, and ratings
- User profile with statistics
- Sample orders and reservations
- Loyalty points and rewards system

## Future Enhancements

- Real backend integration
- Payment processing
- Push notifications
- Image upload for food items
- Advanced search filters
- Multi-language support implementation
- Real-time order tracking
