import 'package:flutter/material.dart';

/// ============================================================================
/// GLOBAL DESIGN SYSTEM
/// ============================================================================
/// This file contains a comprehensive design system for the SmartRide UG app.
/// All widgets, styles, and components follow a consistent visual language
/// and brand guidelines. Use these components throughout the app for consistency.
/// ============================================================================

// ============================================================================
// PRIMARY BUTTON COMPONENT
// ============================================================================
/// [PrimaryButton] is the main call-to-action button used across the app.
///
/// **Features:**
/// - Blue background with white text
/// - Rounded corners (8px radius)
/// - Consistent padding for touch targets (20px horizontal, 12px vertical)
/// - Responds to user taps with the [onPressed] callback
///
/// **Usage Example:**
/// ```dart
/// PrimaryButton(
///   label: 'Login',
///   onPressed: () => Navigator.push(context, ...),
/// )
/// ```
///
/// **When to use:**
/// - Primary actions (Submit, Login, Confirm)
/// - Main navigation buttons
/// - Form submissions
/// - Important user actions
///
/// **Parameters:**
/// - [label] (String): Text displayed on the button
/// - [onPressed] (VoidCallback): Function called when button is tapped
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

// ============================================================================
// CARD WIDGET COMPONENT
// ============================================================================
/// [CardWidget] is a reusable container for grouping related content.
///
/// **Features:**
/// - Rounded corners (12px radius)
/// - Subtle shadow for depth (elevation: 4)
/// - Built-in padding (16px all sides)
/// - White background on light theme
/// - Separates content visually from background
///
/// **Usage Example:**
/// ```dart
/// CardWidget(
///   child: Column(
///     children: [
///       Text('Title'),
///       SizedBox(height: 8),
///       Text('Description'),
///     ],
///   ),
/// )
/// ```
///
/// **When to use:**
/// - Trip information display
/// - Bus details
/// - User profiles
/// - Stats or metrics
/// - Any grouped information that needs visual separation
///
/// **Parameters:**
/// - [child] (Widget): The content to display inside the card
///
/// **Styling:**
/// - Elevation: 4 (creates shadow)
/// - Border Radius: 12px
/// - Padding: 16px (all sides)
/// - Margin: 8px (all sides)
class CardWidget extends StatelessWidget {
  final Widget child;

  const CardWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// ============================================================================
// LOADING WIDGET COMPONENT
// ============================================================================
/// [LoadingWidget] displays a centered circular loading indicator.
///
/// **Features:**
/// - Centered on screen
/// - Blue-colored spinner
/// - Smooth animation
/// - Stroke width: 3 for visibility
/// - Indicates to users that data is loading
///
/// **Usage Example:**
/// ```dart
/// if (isLoading) {
///   LoadingWidget()
/// } else {
///   YourContentWidget()
/// }
/// ```
///
/// **When to use:**
/// - While fetching data from API
/// - During file uploads
/// - While processing user actions
/// - Initial page load
/// - Network requests in progress
///
/// **Styling:**
/// - Color: Blue (consistent with theme)
/// - Stroke Width: 3px
/// - Centered: Both horizontally and vertically
/// - Size: 50x50 (default CircularProgressIndicator)
class LoadingWidget extends StatelessWidget {
  const LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.blue,
      ),
    );
  }
}

// ============================================================================
// STATUS BADGE COMPONENT
// ============================================================================
/// [StatusBadge] displays a status indicator with custom color.
///
/// **Features:**
/// - Pill-shaped container (20px border-radius)
/// - Customizable background color (20% opacity)
/// - Bold text in the main color
/// - Compact size for inline display
/// - Typically used for status indicators (Active, Pending, Completed, etc.)
///
/// **Usage Examples:**
/// ```dart
/// // Active status (green)
/// StatusBadge(status: 'Active', color: Colors.green)
///
/// // Pending status (orange)
/// StatusBadge(status: 'Pending', color: Colors.orange)
///
/// // Completed status (blue)
/// StatusBadge(status: 'Completed', color: Colors.blue)
/// ```
///
/// **When to use:**
/// - Trip status (Active, Completed, Cancelled)
/// - Bus status (Available, In Service, Maintenance)
/// - Request status (Pending, Accepted, Rejected)
/// - User roles (Admin, Operator, Passenger)
/// - Any status that needs visual categorization
///
/// **Parameters:**
/// - [status] (String): Text to display in the badge
/// - [color] (Color): Color theme for the badge
///   - Use green for success/active states
///   - Use orange for warning/pending states
///   - Use red for error/cancelled states
///   - Use blue for neutral/info states
///
/// **Styling:**
/// - Padding: 12px (horizontal), 6px (vertical)
/// - Border Radius: 20px (pill shape)
/// - Background: Color with 20% opacity
/// - Text: Bold weight, main color
class StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// ============================================================================
// PASSENGER COUNT CARD COMPONENT
// ============================================================================
/// [PassengerCountCard] displays the number of passengers in a formatted card.
///
/// **Features:**
/// - Uses [CardWidget] for consistent styling
/// - Displays passenger count with icon
/// - People icon (blue color, 24px)
/// - Readable text format: "X Passengers"
/// - Horizontal layout (icon + text)
///
/// **Usage Example:**
/// ```dart
/// PassengerCountCard(count: 4)
/// // Displays: [👥 icon] "4 Passengers"
/// ```
///
/// **When to use:**
/// - Trip overview screens
/// - Bus capacity display
/// - Booking summary
/// - Trip details view
/// - Passenger information display
///
/// **Parameters:**
/// - [count] (int): Number of passengers to display
///
/// **Styling:**
/// - Icon: Blue people icon (24px default)
/// - Spacing: 8px between icon and text
/// - Text Size: 16px
/// - Layout: Horizontal (Row)
/// - Centered: Content centered within card
class PassengerCountCard extends StatelessWidget {
  final int count;

  const PassengerCountCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people, color: Colors.blue),
          const SizedBox(width: 8),
          Text('$count Passengers', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// ============================================================================
// CUSTOM TEXT FIELD COMPONENT
// ============================================================================
/// [CustomTextField] is a styled text input field following design system.
///
/// **Features:**
/// - Rounded corners (8px radius)
/// - Light gray background for visibility
/// - Outline border for clear boundaries
/// - Placeholder text (hint)
/// - Integrated with [TextEditingController] for state management
/// - Consistent padding and sizing
///
/// **Usage Example:**
/// ```dart
/// final emailController = TextEditingController();
///
/// CustomTextField(
///   hint: 'Enter your email',
///   controller: emailController,
/// )
/// ```
///
/// **When to use:**
/// - Login/signup forms
/// - User input (text, numbers, passwords)
/// - Search fields
/// - Filter inputs
/// - Any text data collection
///
/// **Parameters:**
/// - [hint] (String): Placeholder text shown when field is empty
/// - [controller] (TextEditingController): Manages the text value
///
/// **Styling:**
/// - Border: Outline with 8px border-radius
/// - Background: Light gray fill (Colors.grey.shade100)
/// - Filled: True (background color visible)
/// - Border Radius: 8px
/// - Minimum height: 48px (standard touch target)
///
/// **Best Practices:**
/// - Always use a controller for form fields
/// - Dispose controllers when done: controller.dispose()
/// - Provide clear hint text to users
/// - Validate input before processing
/// - Use inputFormatters for specific input types
class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const CustomTextField({required this.hint, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}

// ============================================================================
// DESIGN SYSTEM USAGE GUIDE
// ============================================================================
/// 
/// **Color Palette:**
/// - Primary: Colors.blue (main actions, links)
/// - Success: Colors.green (completed, active states)
/// - Warning: Colors.orange (pending, caution states)
/// - Error: Colors.red (cancelled, error states)
/// - Background: Colors.white (default)
/// - Text: Colors.black87 (primary), Colors.black54 (secondary)
///
/// **Typography:**
/// - Heading: 20px, Bold (FontWeight.bold)
/// - Subheading: 16px, SemiBold (FontWeight.w600)
/// - Body: 14px, Regular (FontWeight.normal)
/// - Caption: 12px, Regular (FontWeight.normal)
/// - Button Text: 14px, SemiBold (FontWeight.w600)
///
/// **Spacing Standards:**
/// - XS: 4px (minimal spacing)
/// - S: 8px (small gaps)
/// - M: 16px (standard padding)
/// - L: 24px (large sections)
/// - XL: 32px (major sections)
///
/// **Border Radius:**
/// - Small: 4px (subtle)
/// - Medium: 8px (standard buttons, inputs)
/// - Large: 12px (cards)
/// - XL: 20px (badges, pills)
///
/// **Icon Sizes:**
/// - Small: 16px
/// - Standard: 24px
/// - Large: 32px
/// - XL: 48px
///
/// **Implementation Tips:**
/// 1. Always use components from this design system
/// 2. Never hardcode colors - reference the palette
/// 3. Maintain consistent spacing using the standards
/// 4. Follow naming conventions (PascalCase for widgets)
/// 5. Document custom components with similar detail
/// 6. Test accessibility on all screen sizes
/// 7. Use const constructors for performance
///

