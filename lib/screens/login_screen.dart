import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //Control paaara mostrar/ocultar la contraseña
  bool _isObscure = true;

  //1.1 Crear el cerebro de la animacion
  StateMachineController? _controller;

  //1.2 SMI: StateMachineInput / Entrada de máquina de estado
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;
  SMINumber? _numLook;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                //Contiene la animacion
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                    'assets/login-bear-animation.riv', 
                    //1.3 Vincular la animación
                    onInit: (artboard){
                      _controller = StateMachineController.fromArtboard(
                        artboard,
                        'Login Machine',
                        );
                      //1.4 Verificaar que inicio bien
                      if(_controller == null) return;

                      //Agregar el controlador aal taablero
                      artboard.addController(_controller!);
                      //Vinculamos laas variables
                      _isChecking = _controller!.findSMI('isChecking');
                      _isHandsUp = _controller!.findSMI('isHandsUp');
                      _trigSuccess = _controller!.findSMI('trigSuccess');
                      _trigFail = _controller!.findSMI('trigFail');
                      _numLook = _controller!.findSMI('numLook');
                    },
                    )),
                  //Para separar
                  const SizedBox(height: 10),
                  //Email
                  TextField(
                    onTap: () {
                      _isHandsUp?.change(false);
                      _isChecking?.change(true);
                    },
                    //1.5 vincular a campos de texto
                    onChanged: (value){
                      if(_isHandsUp != null){
                        //No taapes los ojos
                        _isHandsUp!.change(false);
                      }
                      //Si is Checking es null
                      if(_isChecking == null) return;
                      //Activar el modo chismoso
                      _isChecking!.change(true);
                      _numLook?.change(value.length.toDouble());
                    },
                    //Para mostrar un tipo de teclado
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  //Contraseña
                  TextField(
                    onTap: () {
                      _isChecking?.change(false);
                      _isHandsUp?.change(true);
                    },
                    //1.5 vincular a campos de texto
                    onChanged: (value){
                      if(_isChecking != null){
                        //No taapes los ojos
                        _isChecking!.change(false);
                      }
                      //Si is Checking es null
                      if(_isHandsUp == null) return;
                      //Activar el modo chismoso
                      _isHandsUp!.change(true);
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            //Para refrescar el icono
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                          )
                    ),
                  )
              ],
            ),
          )),
      ),
    );
  }
}