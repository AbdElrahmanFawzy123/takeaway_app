import 'package:flutter/material.dart';
import '../../../../screens/input_screen.dart';
import '../../../chart/presentation/screens/chart_screen.dart';
import '../animations/home_animations.dart';
import '../routes/home_routes.dart';
import '../widgets/action_button.dart';
import '../widgets/grid_background.dart';
import '../widgets/hero_logo.dart';
import '../widgets/stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late HomeAnimations anim;

  @override
  void initState() {
    super.initState();
    anim = HomeAnimations(this);
    anim.init();
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: Stack(
        children: [
          const GridBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    HeroLogo(animation: anim),
                    const SizedBox(height: 35),
                    const Text(
                      'Takeaway',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFF8C00), Color(0xFFFFD700)],
                      ).createShader(bounds),
                      child: const Text(
                        'Simulation',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Analyze queue performance in real-time',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: 45),
                    const Row(
                      children: [
                        StatCard(
                            title: "M/M/1",
                            subtitle: "Single Server",
                            icon: Icons.person),
                        SizedBox(width: 10),
                        StatCard(
                            title: "M/M/2",
                            subtitle: "Double Server",
                            icon: Icons.group),
                        SizedBox(width: 10),
                        StatCard(
                            title: "Live",
                            subtitle: "Real-time",
                            icon: Icons.bolt),
                      ],
                    ),
                    const SizedBox(height: 35),
                    ActionButton(
                      label: "Start Simulation",
                      icon: Icons.play_arrow,
                      primary: true,
                      onTap: () => Navigator.push(
                        context,
                        HomeRoutes.fade(const InputScreen()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ActionButton(
                      label: "Compare Results",
                      icon: Icons.bar_chart,
                      primary: false,
                      onTap: () => Navigator.push(
                        context,
                        HomeRoutes.fade(const ChartScreen()),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
