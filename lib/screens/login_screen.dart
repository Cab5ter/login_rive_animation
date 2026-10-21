import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //control para mostrar u ocultar la contraseña
  bool _isObscuretext = true;

  //1.1 Crear el cerebro de la animacion
  StateMachineController? _controller;

  //1.2 SMI: StateMachineInput / Entrada de maquina de estado
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMINumber? _numLook;

  void _checkEmail() {
    _isHandsUp?.change(false);
    _isChecking?.change(true);
  }

  void _coverEyes() {
    _isChecking?.change(false);
    _isHandsUp?.change(true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Obtain the size of the screen .i.
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/login-bear-animation.riv',
                    //1.3 Vincular la animacion
                    onInit: (artboard) {
                      _controller = StateMachineController.fromArtboard(
                        artboard,
                        'Login Machine',
                      );
                      //1.4 verificar si inicio bien
                      if (_controller == null) return;

                      //agregar el controlador al tablero
                      artboard.addController(_controller!);

                      //1.5 Vincular las entradas de la maquina de estado
                      _isChecking = _controller?.findInput<bool>(
                        'isChecking',
                      ) as SMIBool?;
                      _isHandsUp =
                          _controller?.findInput<bool>('isHandsUp') as SMIBool?;
                      _numLook = _controller?.findInput<double>(
                        'numLook',
                      ) as SMINumber?;
                    },
                  ),
                ),

                const SizedBox(height: 10),
                //Email
                TextField(
                  onTap: _checkEmail,
                  onChanged: (value) {
                    _checkEmail();
                    _numLook?.change(value.length.toDouble());
                  },
                  //para mostrar un tipo de teclado
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Password
                TextField(
                  onTap: _coverEyes,
                  onChanged: (value) {
                    _coverEyes();
                  },
                  obscureText: _isObscuretext,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscuretext
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscuretext = !_isObscuretext;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
