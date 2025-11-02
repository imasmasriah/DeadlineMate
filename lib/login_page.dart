import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'dart:math' as math;

const Color blushPinkLight = Color(0xFFFDE7EB);
const Color roseMauveSoft = Color(0xFFD8436B);
const Color mintCreamLight = Color(0xFFE9F5E8);
const Color forestGreenLight = Color(0xFF81C784);
const Color charcoalDark = Color(0xFF3A4750);
const Color greyHint = Color(0xFFBDBDBD);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: roseMauveSoft,
        ),
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color1;
  final Color color2;

  WavePainter({
    required this.animationValue,
    required this.color1,
    required this.color2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Path path1 = Path();
    final Path path2 = Path();

    final double waveHeight = size.height * 0.15;
    final double waveLength = size.width / 2;
    final double offset = animationValue * waveLength;

    // Wave 1
    path1.moveTo(0 - offset, size.height * 0.6);
    for (double i = -waveLength; i < size.width + waveLength; i += 1) {
      path1.lineTo(
        i,
        size.height * 0.6 +
            waveHeight * 0.5 * (1 + (math.sin(i / size.width * 2))),
      );
    }
    path1.lineTo(size.width + waveLength, size.height);
    path1.lineTo(0 - offset, size.height);
    path1.close();

    path2.moveTo(0 - offset + (waveLength / 4), size.height * 0.7);
    for (double i = -waveLength; i < size.width + waveLength; i += 1) {
      path2.lineTo(
        i,
        size.height * 0.7 +
            waveHeight * 0.4 * (1 + (math.cos(i / size.width * 2))),
      );
    }
    path2.lineTo(size.width + waveLength, size.height);
    path2.lineTo(0 - offset + (waveLength / 4), size.height);
    path2.close();

    canvas.drawPath(
        path1,
        Paint()
          ..color = color1
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path2,
        Paint()
          ..color = color2
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  late AnimationController _blobAnimationController;
  late Animation<double> _blobRotationAnimation;
  late Animation<Alignment> _blobAlignmentAnimation;

  late AnimationController _waveAnimationController;
  late Animation<double> _waveOffsetAnimation;

  @override
  void initState() {
    super.initState();

    _blobAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat(reverse: true);

    _blobRotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _blobAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _blobAlignmentAnimation = Tween<Alignment>(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(
        parent: _blobAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );

    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _waveOffsetAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _waveAnimationController,
        curve: Curves.linear,
      ),
    );

    _emailFocusNode.addListener(() => setState(() {}));
    _passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _blobAnimationController.dispose();
    _waveAnimationController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      if (!_isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email atau Kata Sandi tidak boleh kosong."),
            backgroundColor: roseMauveSoft,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    if (!_emailController.text.contains('@') && !_isLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Format Email tidak valid."),
          backgroundColor: roseMauveSoft,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login berhasil! Email: ${_emailController.text}"),
        backgroundColor: forestGreenLight,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildBackgroundBlobs() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _blobAnimationController,
        builder: (context, child) {
          return Stack(
            children: [
              Align(
                alignment: _blobAlignmentAnimation.value,
                child: Transform.rotate(
                  angle: _blobRotationAnimation.value,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      color: blushPinkLight.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: blushPinkLight.withOpacity(0.7),
                          blurRadius: 180,
                          spreadRadius: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentTween(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ).animate(_blobAnimationController).value,
                child: Transform.rotate(
                  angle: -_blobRotationAnimation.value * 1.5,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: mintCreamLight.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: mintCreamLight.withOpacity(0.7),
                          blurRadius: 150,
                          spreadRadius: 80,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedWaveBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _waveAnimationController,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(
              animationValue: _waveOffsetAnimation.value,
              color1: roseMauveSoft.withOpacity(0.1),
              color2: forestGreenLight.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool isPassword = false,
  }) {
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: isFocused
            ? Border.all(color: roseMauveSoft.withOpacity(0.8), width: 3.0)
            : Border.all(color: greyHint.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: roseMauveSoft.withOpacity(isFocused ? 0.4 : 0.1),
            spreadRadius: isFocused ? 2 : 0,
            blurRadius: isFocused ? 20 : 10,
            offset: Offset(0, isFocused ? 6 : 4),
          ),
        ],
        color: Colors.white.withOpacity(0.9),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType:
            isPassword ? TextInputType.text : TextInputType.emailAddress,
        style:
            const TextStyle(color: charcoalDark, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: isFocused ? roseMauveSoft : greyHint,
              fontWeight: FontWeight.w500),
          prefixIcon: Icon(icon, color: isFocused ? roseMauveSoft : greyHint),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: roseMauveSoft,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        ),
      ),
    );
  }

  Widget _buildLogoFallback() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
          color: blushPinkLight,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: roseMauveSoft.withOpacity(0.6), width: 4)),
      alignment: Alignment.center,
      child: const Icon(
        Icons.lock_person_outlined,
        size: 70,
        color: charcoalDark,
      ),
    );
  }

  Widget _buildAnimatedLoginButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      height: 65,
      width: _isLoading ? 65.0 : double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isLoading ? 32.5 : 20),
        gradient: LinearGradient(
          colors: [
            roseMauveSoft.withOpacity(0.9),
            roseMauveSoft,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: roseMauveSoft.withOpacity(0.6),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleLogin,
          borderRadius: BorderRadius.circular(_isLoading ? 32.5 : 20),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3.5,
                      ),
                    )
                  : const Text(
                      "MASUK",
                      key: ValueKey('text'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3.0,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseBackground = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            blushPinkLight,
            mintCreamLight.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          baseBackground,
          _buildBackgroundBlobs(),
          _buildAnimatedWaveBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                from: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width > 600
                          ? 450
                          : double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 60.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: roseMauveSoft.withOpacity(0.3),
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: charcoalDark.withOpacity(0.18),
                            blurRadius: 45,
                            spreadRadius: -10,
                            offset: const Offset(0, 25),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: FadeInDown(
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 700),
                              from: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 35.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.asset(
                                    'assets/images/sampul.png',
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildLogoFallback();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInLeft(
                            delay: const Duration(milliseconds: 300),
                            duration: const Duration(milliseconds: 700),
                            from: 20,
                            child: const Text(
                              "DeadlineMate",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                color: charcoalDark,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FadeInRight(
                            delay: const Duration(milliseconds: 400),
                            duration: const Duration(milliseconds: 700),
                            from: 20,
                            child: Text(
                              "Kelola tugasmu secara cerdas & efektif.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: greyHint,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          FadeInUp(
                            delay: const Duration(milliseconds: 500),
                            duration: const Duration(milliseconds: 800),
                            child: _buildTextField(
                              label: "Alamat Email",
                              icon: Icons.alternate_email,
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                            ),
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 600),
                            duration: const Duration(milliseconds: 800),
                            child: _buildTextField(
                              label: "Kata Sandi",
                              icon: Icons.lock_open_outlined,
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              isPassword: true,
                            ),
                          ),
                          FadeIn(
                            delay: const Duration(milliseconds: 700),
                            duration: const Duration(milliseconds: 700),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        debugPrint("Lupa Kata Sandi Diklik!");
                                      },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Lupa Password?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: roseMauveSoft,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          FadeInUp(
                            delay: const Duration(milliseconds: 800),
                            duration: const Duration(milliseconds: 800),
                            from: 10,
                            child: _buildAnimatedLoginButton(),
                          ),
                          const SizedBox(height: 40),
                          FadeIn(
                            delay: const Duration(milliseconds: 900),
                            duration: const Duration(milliseconds: 800),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        color: greyHint.withOpacity(0.3),
                                        thickness: 1.8)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  child: Text("ATAU LANJUTKAN DENGAN",
                                      style: TextStyle(
                                          color: greyHint.withOpacity(0.8),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Expanded(
                                    child: Divider(
                                        color: greyHint.withOpacity(0.3),
                                        thickness: 1.8)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          FadeInUp(
                            delay: const Duration(milliseconds: 1000),
                            duration: const Duration(milliseconds: 800),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: charcoalDark.withOpacity(0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: OutlinedButton.icon(
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 28,
                                  width: 28,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.login,
                                          color: charcoalDark.withOpacity(0.8),
                                          size: 32),
                                ),
                                label: Text("Masuk dengan Google",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: charcoalDark,
                                        fontWeight: FontWeight.w700)),
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        debugPrint(
                                            "Login dengan Google Diklik!");
                                      },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 65),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                      color: forestGreenLight.withOpacity(0.7),
                                      width: 2.8),
                                  foregroundColor: charcoalDark,
                                  backgroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                          FadeIn(
                            delay: const Duration(milliseconds: 1100),
                            duration: const Duration(milliseconds: 800),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Belum punya akun?",
                                    style: TextStyle(
                                        color: charcoalDark, fontSize: 15)),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () {
                                          debugPrint(
                                              "Daftar Akun Baru Diklik!");
                                        },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "Daftar Sekarang",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: roseMauveSoft,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
