import 'package:flutter/material.dart';
import 'package:flutter_glass_ui_kit/flutter_glass_ui_kit.dart';

void main() {
  runApp(const GlassUIKitExampleApp());
}

class GlassUIKitExampleApp extends StatelessWidget {
  const GlassUIKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassTheme(
      data: GlassThemeData.dark(),
      child: MaterialApp(
        title: 'Glass UI Kit Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const ExampleHomePage(),
      ),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  int _selectedIndex = 0;
  GlassPerformance _performance = GlassPerformance.medium;
  bool _isAnimatedActive = false;

  final List<_ExamplePage> _pages = const [
    _ExamplePage(title: 'Containers', icon: Icons.square_rounded),
    _ExamplePage(title: 'Cards', icon: Icons.credit_card),
    _ExamplePage(title: 'Buttons', icon: Icons.touch_app),
    _ExamplePage(title: 'Animated', icon: Icons.animation),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: Text(_pages[_selectedIndex].title),
        performance: _performance,
        actions: [
          PopupMenuButton<GlassPerformance>(
            icon: const Icon(Icons.tune),
            onSelected: (value) => setState(() => _performance = value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: GlassPerformance.low,
                child: Row(
                  children: [
                    if (_performance == GlassPerformance.low)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Low Performance'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: GlassPerformance.medium,
                child: Row(
                  children: [
                    if (_performance == GlassPerformance.medium)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('Medium Performance'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _GradientBackground(),
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _ContainersDemo(performance: _performance),
                _CardsDemo(performance: _performance),
                _ButtonsDemo(performance: _performance),
                _AnimatedDemo(
                  performance: _performance,
                  isActive: _isAnimatedActive,
                  onToggle: () =>
                      setState(() => _isAnimatedActive = !_isAnimatedActive),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _GlassBottomNav(
        selectedIndex: _selectedIndex,
        pages: _pages,
        performance: _performance,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: GlassIconButton(
        icon: Icons.info_outline,
        performance: _performance,
        onPressed: () => _showInfoBottomSheet(context),
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context) {
    showGlassBottomSheet(
      context: context,
      builder: (context) => GlassBottomSheet(
        performance: _performance,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Glass UI Kit',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'A complete Glassmorphism / Frosted UI system for Flutter.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            const _InfoItem(
              icon: Icons.blur_on,
              title: 'BackdropFilter',
              description: 'Real-time blur effect behind widgets',
            ),
            const _InfoItem(
              icon: Icons.gradient,
              title: 'Gradient Borders',
              description: 'Beautiful gradient border effects',
            ),
            const _InfoItem(
              icon: Icons.grain,
              title: 'Noise Overlay',
              description: 'Optional grain texture for authenticity',
            ),
            const _InfoItem(
              icon: Icons.speed,
              title: 'Performance Modes',
              description: 'Low, Medium, and Ultra quality settings',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    performance: _performance,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1B263B),
            Color(0xFF415A77),
            Color(0xFF778DA9),
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.6),
                    Colors.purple.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.5),
                    Colors.blue.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: 30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.pink.withValues(alpha: 0.5),
                    Colors.pink.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            right: 20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.cyan.withValues(alpha: 0.5),
                    Colors.cyan.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            top: 450,
            left: 100,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.45),
                    Colors.orange.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            right: 80,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.green.withValues(alpha: 0.4),
                    Colors.green.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  const _GlassBottomNav({
    required this.selectedIndex,
    required this.pages,
    required this.performance,
    required this.onTap,
  });

  final int selectedIndex;
  final List<_ExamplePage> pages;
  final GlassPerformance performance;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      performance: performance,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(pages.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    pages[index].icon,
                    color: isSelected ? Colors.white : Colors.white54,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pages[index].title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white54,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ExamplePage {
  const _ExamplePage({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

class _ContainersDemo extends StatelessWidget {
  const _ContainersDemo({required this.performance});

  final GlassPerformance performance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'GlassContainer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Default glass container with standard settings.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            blur: 20,
            opacity: 0.2,
            padding: const EdgeInsets.all(24),
            child: const Text(
              'High blur (20) and increased opacity (0.2).',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            blur: 5,
            opacity: 0.05,
            borderRadius: BorderRadius.circular(32),
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Low blur (5), low opacity (0.05), rounded corners.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            frostColor: Colors.purple,
            opacity: 0.15,
            padding: const EdgeInsets.all(24),
            borderGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withValues(alpha: 0.5),
                Colors.pink.withValues(alpha: 0.2),
              ],
            ),
            child: const Text(
              'Purple frost color with gradient border.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            backgroundGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.withValues(alpha: 0.2),
                Colors.cyan.withValues(alpha: 0.1),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: const Text(
              'Container with background gradient overlay.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Nested Glass',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            performance: performance,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Outer container',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                GlassContainer(
                  performance: performance,
                  blur: 5,
                  opacity: 0.1,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Nested inner container',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _CardsDemo extends StatelessWidget {
  const _CardsDemo({required this.performance});

  final GlassPerformance performance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'GlassCard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            performance: performance,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Glass Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'A simple card with default padding and styling.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            performance: performance,
            elevation: 8,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elevated Card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This card has elevation for a shadow effect.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'GlassCardWithHeader',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassCardWithHeader(
            performance: performance,
            header: const Row(
              children: [
                Icon(Icons.account_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(color: Colors.white54),
                ),
                SizedBox(height: 8),
                Text(
                  'Flutter developer passionate about beautiful UIs.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCardWithHeader(
            performance: performance,
            frostColor: Colors.amber,
            opacity: 0.1,
            header: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.amber),
                SizedBox(width: 12),
                Text(
                  'Warning',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            content: const Text(
              'This is a warning card with custom frost color.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ButtonsDemo extends StatefulWidget {
  const _ButtonsDemo({required this.performance});

  final GlassPerformance performance;

  @override
  State<_ButtonsDemo> createState() => _ButtonsDemoState();
}

class _ButtonsDemoState extends State<_ButtonsDemo> {
  int _pressCount = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'GlassButton',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassButton(
            performance: widget.performance,
            onPressed: () => setState(() => _pressCount++),
            child: Text('Press me (Count: $_pressCount)'),
          ),
          const SizedBox(height: 16),
          GlassButton(
            performance: widget.performance,
            onPressed: () {},
            borderRadius: BorderRadius.circular(32),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.rocket_launch, size: 18),
                SizedBox(width: 8),
                Text('Launch'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassButton(
            performance: widget.performance,
            enabled: false,
            child: const Text('Disabled Button'),
          ),
          const SizedBox(height: 16),
          GlassButton(
            performance: widget.performance,
            onPressed: () {},
            frostColor: Colors.green,
            opacity: 0.2,
            borderGradient: LinearGradient(
              colors: [
                Colors.green.withValues(alpha: 0.5),
                Colors.teal.withValues(alpha: 0.2),
              ],
            ),
            child: const Text('Custom Colors'),
          ),
          const SizedBox(height: 24),
          const Text(
            'GlassTextButton',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GlassTextButton(
                  text: 'Cancel',
                  performance: widget.performance,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GlassTextButton(
                  text: 'Confirm',
                  performance: widget.performance,
                  frostColor: Colors.blue,
                  opacity: 0.2,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'GlassIconButton',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GlassIconButton(
                icon: Icons.home,
                performance: widget.performance,
                onPressed: () {},
                tooltip: 'Home',
              ),
              GlassIconButton(
                icon: Icons.search,
                performance: widget.performance,
                onPressed: () {},
                tooltip: 'Search',
              ),
              GlassIconButton(
                icon: Icons.favorite,
                performance: widget.performance,
                frostColor: Colors.red,
                iconColor: Colors.red,
                onPressed: () {},
                tooltip: 'Favorite',
              ),
              GlassIconButton(
                icon: Icons.settings,
                performance: widget.performance,
                size: 56,
                iconSize: 28,
                onPressed: () {},
                tooltip: 'Settings',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Button Row',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            performance: widget.performance,
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Music Player',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Now playing: Glass Symphony',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GlassIconButton(
                  icon: Icons.skip_previous,
                  performance: widget.performance,
                  size: 40,
                  iconSize: 20,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.play_arrow,
                  performance: widget.performance,
                  size: 48,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.skip_next,
                  performance: widget.performance,
                  size: 40,
                  iconSize: 20,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _AnimatedDemo extends StatelessWidget {
  const _AnimatedDemo({
    required this.performance,
    required this.isActive,
    required this.onToggle,
  });

  final GlassPerformance performance;
  final bool isActive;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'AnimatedGlassContainer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the toggle to animate properties',
            style: TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 16),
          Center(
            child: GlassButton(
              performance: performance,
              onPressed: onToggle,
              child: Text(isActive ? 'Deactivate' : 'Activate'),
            ),
          ),
          const SizedBox(height: 24),
          AnimatedGlassContainer(
            performance: performance,
            blur: isActive ? 20 : 5,
            opacity: isActive ? 0.25 : 0.1,
            borderRadius:
                isActive ? BorderRadius.circular(32) : BorderRadius.circular(8),
            padding: const EdgeInsets.all(24),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActive ? 'Active State' : 'Inactive State',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isActive
                      ? 'Blur: 20, Opacity: 0.25, Radius: 32'
                      : 'Blur: 5, Opacity: 0.1, Radius: 8',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'GlassToggleContainer',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GlassToggleContainer(
            isActive: isActive,
            performance: performance,
            activeBlur: 15,
            inactiveBlur: 8,
            activeOpacity: 0.2,
            inactiveOpacity: 0.08,
            activeFrostColor: Colors.purple,
            inactiveFrostColor: Colors.white,
            activeBorderRadius: BorderRadius.circular(24),
            inactiveBorderRadius: BorderRadius.circular(12),
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isActive ? Icons.star : Icons.star_border,
                    key: ValueKey(isActive),
                    color: isActive ? Colors.amber : Colors.white54,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Starred Item' : 'Regular Item',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        isActive
                            ? 'This item is favorited'
                            : 'Tap toggle to favorite',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Multiple Animated Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AnimatedGlassContainer(
                  performance: performance,
                  blur: isActive ? 15 : 5,
                  opacity: isActive ? 0.2 : 0.1,
                  frostColor: Colors.blue,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  duration: const Duration(milliseconds: 300),
                  child: const Column(
                    children: [
                      Icon(Icons.cloud, color: Colors.lightBlue, size: 32),
                      SizedBox(height: 8),
                      Text('Cloud', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedGlassContainer(
                  performance: performance,
                  blur: isActive ? 15 : 5,
                  opacity: isActive ? 0.2 : 0.1,
                  frostColor: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  duration: const Duration(milliseconds: 400),
                  child: const Column(
                    children: [
                      Icon(Icons.eco, color: Colors.lightGreen, size: 32),
                      SizedBox(height: 8),
                      Text('Nature', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedGlassContainer(
                  performance: performance,
                  blur: isActive ? 15 : 5,
                  opacity: isActive ? 0.2 : 0.1,
                  frostColor: Colors.orange,
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.all(16),
                  duration: const Duration(milliseconds: 500),
                  child: const Column(
                    children: [
                      Icon(Icons.wb_sunny, color: Colors.orange, size: 32),
                      SizedBox(height: 8),
                      Text('Sun', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
