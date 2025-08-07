import 'package:digia_ui/digia_ui.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DigiaUIExample());
}

class DigiaUIExample extends StatelessWidget {
  const DigiaUIExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Digia UI Example',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  DigiaUI? _digiaUI;
  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _initializeDigiaUI();
  }

  void _setupAnimation() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoController.forward().then((_) {
      _startCountdown();
    });
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown > 0) {
          _startCountdown();
        } else {
          _navigateToMainApp();
        }
      }
    });
  }

  Future<void> _initializeDigiaUI() async {
    try {
      final initConfig = DigiaUIOptions(
        accessKey: "68930cce1963e358762b546b",
        flavor: Flavor.debug(environment: Environment.production),
        networkConfiguration: const NetworkConfiguration(
          defaultHeaders: {'X-App-Type': 'SimpleApp'},
          timeoutInMs: 25000,
        ),
      );
      final digiaUI = await DigiaUI.initialize(initConfig);
      _digiaUI = digiaUI;
    } catch (error) {
      debugPrint('Initialization failed: $error');
    }
  }

  void _navigateToMainApp() {
    if (_digiaUI != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainAppScreen(digiaUI: _digiaUI!),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F51B5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScale.value,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/logo.png'),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Redirecting you to Digia in $_countdown',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainAppScreen extends StatelessWidget {
  final DigiaUI digiaUI;

  const MainAppScreen({super.key, required this.digiaUI});

  @override
  Widget build(BuildContext context) {
    return DigiaUIApp(
      digiaUI: digiaUI,
      builder: (context) => DUIFactory().createInitialPage(),
    );
  }
}
