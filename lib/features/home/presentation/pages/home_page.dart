import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _yellow = Color(0xFFF7B500);
  static const _blue = Color(0xFF1677FF);
  static const _green = Color(0xFF25B84D);
  static const _surface = Color(0xFF0D1A2B);
  static const _line = Color(0xFF22324B);

  final _screens = const [
    _AuthGateway(),
    _PassengerHome(),
    _BusesScreen(),
    _TrackingScreen(),
    _BookingsScreen(),
    _OperatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        backgroundColor: _surface,
        indicatorColor: _blue.withValues(alpha: 0.22),
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.login_outlined),
            label: 'Login',
          ),
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.directions_bus_outlined),
            label: 'Buses',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            label: 'Track',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Operator',
          ),
        ],
      ),
    );
  }
}

class _AuthGateway extends StatefulWidget {
  const _AuthGateway();

  @override
  State<_AuthGateway> createState() => _AuthGatewayState();
}

class _AuthGatewayState extends State<_AuthGateway> {
  var _isRegister = false;
  var _role = 'Passenger';

  @override
  Widget build(BuildContext context) {
    return _ScreenShell(
      title: 'SMART RIDE UG',
      subtitle: 'Login or register by user category',
      accent: _roleColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _BrandHero(),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                icon: Icon(Icons.login_outlined),
                label: Text('Login'),
              ),
              ButtonSegment(
                value: true,
                icon: Icon(Icons.person_add_alt_1_outlined),
                label: Text('Register'),
              ),
            ],
            selected: {_isRegister},
            onSelectionChanged: (value) {
              setState(() => _isRegister = value.first);
            },
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RoleChip(
                label: 'Passenger',
                icon: Icons.person_outline,
                selected: _role == 'Passenger',
                color: _HomeScreenState._blue,
                onSelected: () => setState(() => _role = 'Passenger'),
              ),
              _RoleChip(
                label: 'Driver',
                icon: Icons.drive_eta_outlined,
                selected: _role == 'Driver',
                color: _HomeScreenState._green,
                onSelected: () => setState(() => _role = 'Driver'),
              ),
              _RoleChip(
                label: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                selected: _role == 'Admin',
                color: _HomeScreenState._yellow,
                onSelected: () => setState(() => _role = 'Admin'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${_isRegister ? 'Create' : 'Access'} $_role Account',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _roleDescription,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.68)),
                ),
                const SizedBox(height: 16),
                if (_isRegister) ...[
                  const _AuthField(
                    label: 'Full name',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 10),
                  if (_role == 'Driver') ...[
                    const _AuthField(
                      label: 'Driver ID or bus number',
                      icon: Icons.confirmation_number_outlined,
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
                const _AuthField(label: 'Email', icon: Icons.mail_outline),
                const SizedBox(height: 10),
                const _AuthField(label: 'Password', icon: Icons.lock_outline),
                if (_isRegister) ...[
                  const SizedBox(height: 10),
                  const _AuthField(
                    label: 'Phone number',
                    icon: Icons.phone_outlined,
                  ),
                ],
                const SizedBox(height: 16),
                _PrimaryAction(
                  label: _isRegister ? 'Register as $_role' : 'Login as $_role',
                  color: _roleColor,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister
                        ? 'Already have an account? Login'
                        : 'New to Smart Ride UG? Create account',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _roleColor {
    return switch (_role) {
      'Driver' => _HomeScreenState._green,
      'Admin' => _HomeScreenState._yellow,
      _ => _HomeScreenState._blue,
    };
  }

  String get _roleDescription {
    return switch (_role) {
      'Driver' => 'Manage assigned bus trips, live status, and passengers.',
      'Admin' => 'Control operators, buses, booking approvals, and reports.',
      _ => 'Browse buses, book seats, track trips, and receive notifications.',
    };
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onSelected;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => onSelected(),
      avatar: Icon(icon, size: 18, color: selected ? Colors.black : color),
      label: Text(label),
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.white,
        fontWeight: FontWeight.w800,
      ),
      selectedColor: color,
      backgroundColor: _HomeScreenState._surface,
      side: BorderSide(color: selected ? color : _HomeScreenState._line),
    );
  }
}

class _AuthField extends StatelessWidget {
  final String label;
  final IconData icon;

  const _AuthField({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: label == 'Password',
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFF091524),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _HomeScreenState._line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _HomeScreenState._line),
        ),
      ),
    );
  }
}

class _PassengerHome extends StatelessWidget {
  const _PassengerHome();

  @override
  Widget build(BuildContext context) {
    return const _ScreenShell(
      title: 'SMART RIDE UG',
      subtitle: 'Moving Uganda Forward',
      accent: _HomeScreenState._yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BrandHero(),
          SizedBox(height: 16),
          _SearchBox(),
          SizedBox(height: 16),
          _QuickActions(),
          SizedBox(height: 18),
          _SectionTitle('Available Buses'),
          SizedBox(height: 10),
          _BusTile(name: 'SMART RIDE Bus 01', route: 'Kyaliwajjala to Town'),
          _BusTile(name: 'SMART RIDE Bus 02', route: 'Kira to Town'),
          _BusTile(name: 'SMART RIDE Bus 03', route: 'Ntinda to Town'),
        ],
      ),
    );
  }
}

class _BusesScreen extends StatelessWidget {
  const _BusesScreen();

  @override
  Widget build(BuildContext context) {
    return const _ScreenShell(
      title: 'Book a Seat',
      subtitle: 'SMART RIDE Bus 01',
      accent: _HomeScreenState._blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TripCard(),
          SizedBox(height: 16),
          _SeatStepper(),
          SizedBox(height: 16),
          _PrimaryAction(
            label: 'Confirm Booking',
            color: _HomeScreenState._blue,
          ),
          SizedBox(height: 20),
          _SectionTitle('Other Buses'),
          SizedBox(height: 10),
          _BusTile(name: 'SMART RIDE Bus 02', route: 'Kira to Town'),
          _BusTile(name: 'SMART RIDE Bus 03', route: 'Ntinda to Town'),
        ],
      ),
    );
  }
}

class _TrackingScreen extends StatelessWidget {
  const _TrackingScreen();

  @override
  Widget build(BuildContext context) {
    return const _ScreenShell(
      title: 'Live Tracking',
      subtitle: 'SMART RIDE Bus 01',
      accent: _HomeScreenState._yellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MapMockup(),
          SizedBox(height: 16),
          _InfoPanel(
            title: 'SMART RIDE Bus 01',
            rows: [
              'Speed: 40 km/h',
              'Next stop: Naalya',
              'ETA: 5 min',
              'Passengers: 20/50',
            ],
          ),
          SizedBox(height: 16),
          _PrimaryAction(label: 'Board Bus', color: _HomeScreenState._yellow),
        ],
      ),
    );
  }
}

class _BookingsScreen extends StatelessWidget {
  const _BookingsScreen();

  @override
  Widget build(BuildContext context) {
    return const _ScreenShell(
      title: 'My Bookings',
      subtitle: 'Upcoming and completed trips',
      accent: _HomeScreenState._blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BookingTile(
            title: 'SMART RIDE Bus 01',
            route: 'Kyaliwajjala to Town',
            status: 'Confirmed',
            color: _HomeScreenState._green,
          ),
          _BookingTile(
            title: 'SMART RIDE Bus 02',
            route: 'Kira to Town',
            status: 'Pending',
            color: _HomeScreenState._yellow,
          ),
          SizedBox(height: 18),
          _CompletionCard(),
          SizedBox(height: 18),
          _SectionTitle('Notifications'),
          SizedBox(height: 10),
          _NoticeTile('Your booking for Bus 01 is confirmed'),
          _NoticeTile('Bus 03 is near your stop'),
          _NoticeTile('Trip completed. Rate your trip'),
        ],
      ),
    );
  }
}

class _OperatorScreen extends StatelessWidget {
  const _OperatorScreen();

  @override
  Widget build(BuildContext context) {
    return const _ScreenShell(
      title: 'Driver & Admin',
      subtitle: 'Requests, buses, passengers, reports',
      accent: _HomeScreenState._green,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MetricGrid(),
          SizedBox(height: 18),
          _SectionTitle('Booking Requests'),
          SizedBox(height: 10),
          _BookingTile(
            title: 'Fahad',
            route: 'Kyaliwajjala to Town - Seat 12',
            status: 'Pending',
            color: _HomeScreenState._yellow,
          ),
          _BookingTile(
            title: 'Mable',
            route: 'Kira to Town - Seat 13',
            status: 'Confirmed',
            color: _HomeScreenState._green,
          ),
          SizedBox(height: 16),
          _OperatorActions(),
          SizedBox(height: 18),
          _InfoPanel(
            title: 'Reports',
            rows: [
              'Total earnings: UGX 360,000',
              'Total trips: 7',
              'Total passengers: 210',
              'Cancelled bookings: 5',
            ],
          ),
        ],
      ),
    );
  }
}

class _ScreenShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;
  final Widget child;

  const _ScreenShell({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withValues(alpha: 0.45)),
                ),
                child: Icon(Icons.directions_bus, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class _BrandHero extends StatelessWidget {
  const _BrandHero();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          Image.asset(
            'assets/images/bus_logo.png',
            height: 116,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.directions_bus,
              size: 88,
              color: _HomeScreenState._yellow,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Connecting passengers. Empowering transport.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search route or location',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: _HomeScreenState._surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _HomeScreenState._line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _HomeScreenState._line),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _ActionTile(
            icon: Icons.airline_seat_recline_normal,
            label: 'Book a Seat',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _ActionTile(icon: Icons.pin_drop_outlined, label: 'Track Bus'),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        children: [
          Icon(icon, color: _HomeScreenState._yellow, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _BusTile extends StatelessWidget {
  final String name;
  final String route;

  const _BusTile({required this.name, required this.route});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.directions_bus, color: _HomeScreenState._blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(
                  route,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                ),
                const SizedBox(height: 4),
                const Text('Seats available', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const _StatusPill(text: 'Yes', color: _HomeScreenState._green),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard();

  @override
  Widget build(BuildContext context) {
    return const _InfoPanel(
      title: 'Trip Details',
      rows: [
        'From: Kyaliwajjala',
        'To: Kampala Town',
        'Date: 24 May 2025',
        'Time: 07:30 AM',
        'Fare: UGX 3,000',
      ],
    );
  }
}

class _SeatStepper extends StatelessWidget {
  const _SeatStepper();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Row(
        children: [
          const Expanded(
            child: Text('Seats', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.remove),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

class _MapMockup extends StatelessWidget {
  const _MapMockup();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        color: const Color(0xFF0A1624),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _HomeScreenState._line),
      ),
      child: CustomPaint(
        painter: _MapPainter(),
        child: const Stack(
          children: [
            Positioned(
              left: 78,
              top: 56,
              child: Icon(
                Icons.directions_bus,
                color: _HomeScreenState._yellow,
                size: 36,
              ),
            ),
            Positioned(
              right: 76,
              bottom: 74,
              child: Icon(
                Icons.location_pin,
                color: Colors.redAccent,
                size: 38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    for (var x = 0.0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x + 42, size.height), grid);
    }
    for (var y = 0.0; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 18), grid);
    }

    final route = Paint()
      ..color = _HomeScreenState._blue
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * .28, size.height * .23)
      ..cubicTo(
        size.width * .36,
        size.height * .34,
        size.width * .46,
        size.height * .46,
        size.width * .52,
        size.height * .58,
      )
      ..cubicTo(
        size.width * .58,
        size.height * .72,
        size.width * .66,
        size.height * .75,
        size.width * .74,
        size.height * .72,
      );
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BookingTile extends StatelessWidget {
  final String title;
  final String route;
  final String status;
  final Color color;

  const _BookingTile({
    required this.title,
    required this.route,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                Text(
                  route,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.66)),
                ),
                const SizedBox(height: 5),
                const Text('24 May, 07:30 AM', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          _StatusPill(text: status, color: color),
        ],
      ),
    );
  }
}

class _CompletionCard extends StatelessWidget {
  const _CompletionCard();

  @override
  Widget build(BuildContext context) {
    return const _Panel(
      child: Column(
        children: [
          Icon(Icons.check_circle, color: _HomeScreenState._green, size: 62),
          SizedBox(height: 8),
          Text(
            'Trip Completed',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 4),
          Text('Thank you for travelling with Smart Ride UG'),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: _HomeScreenState._yellow),
              Icon(Icons.star, color: _HomeScreenState._yellow),
              Icon(Icons.star, color: _HomeScreenState._yellow),
              Icon(Icons.star, color: _HomeScreenState._yellow),
              Icon(Icons.star_border, color: _HomeScreenState._yellow),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoticeTile extends StatelessWidget {
  final String text;

  const _NoticeTile(this.text);

  @override
  Widget build(BuildContext context) {
    return _Panel(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: _HomeScreenState._blue,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'Total Buses',
            value: '12',
            color: _HomeScreenState._blue,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MetricTile(
            label: 'Active Buses',
            value: '8',
            color: _HomeScreenState._green,
          ),
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.68)),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperatorActions extends StatelessWidget {
  const _OperatorActions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _PrimaryAction(
            label: 'Confirm',
            color: _HomeScreenState._green,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _PrimaryAction(label: 'Reject', color: Colors.redAccent),
        ),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final String title;
  final List<String> rows;

  const _InfoPanel({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                row,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.76)),
              ),
            ),
        ],
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final Color color;

  const _PrimaryAction({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color == _HomeScreenState._yellow
            ? Colors.black
            : Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}

class _Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const _Panel({required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _HomeScreenState._surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _HomeScreenState._line),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusPill({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
