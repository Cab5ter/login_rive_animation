import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'dart:async'; //3.1 Importar el timer

class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  //Control para mostrar/ocultar contraseña
  bool _isObscure = true;

  //1.1 Crear el cerebro de la animación
  StateMachineController? _controller;

  //paso 1.2 SMI: StateMachineInput / Entrada de maquina de estado
  SMIBool? _isChecking;
  SMIBool? _isHandsUp;
  SMITrigger? _trigSuccess;
  SMITrigger? _trigFail;
  SMINumber? _numLook;


  //3.2 TImer para detener la mirada al dejar de escribir
  Timer? _typingDebounce;

  // 2.1 Crear variables para FocusNode
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();


  //2.2 Crear los listeners (oyentes/chismosos)

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener((){
      if (_emailFocusNode.hasFocus) {
        if(_isHandsUp != null) {
          //ojos sin cerrar
          _isHandsUp?.change(false);

          //3.3 Mirada neutral
          _numLook?.value = 50; //mirada neutral
        }
      }
    });
    _passwordFocusNode.addListener((){
      //Manos arriba en password
      _isHandsUp?.change(_passwordFocusNode.hasFocus);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    //Obtener el tamaño de la pantalla del dispositivo
    final Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20 ),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 200,
                  child: RiveAnimation.asset(
                  'assets/login-bear-animation.riv', 
                  stateMachines: ['Login Machine'],
                  //1.3 Vincular la animacion
                  onInit: (artboard) {
                    _controller = StateMachineController.fromArtboard(
                      artboard, 
                      'Login Machine',
                      );
                    //1.4 Verificar que inicio bien
                    if (_controller == null) return;


                    //Agregar el controlador al tablero
                    artboard.addController(_controller!);

                    //Vincular las variables
                    _isChecking = _controller!.findSMI('isCheking');
                    _isHandsUp = _controller!.findSMI('isHandsUp');
                    _trigSuccess = _controller!.findSMI('trigSuccess');
                    _trigFail = _controller!.findSMI('trigFail');
                    _numLook = _controller!.findSMI('numLook');




                  }

                  )
                  ),
                  //Para separar
                  const SizedBox(height: 10),
                  //Email
                  TextField(
                    //2.3 asignar foco al campo de texto
                    focusNode: _emailFocusNode,

                    //1.5 Vincular a campos de texto
                    onChanged: (value){
                      if (_isHandsUp != null){
                        //no tapes los ojos
                        //_isHandsUp!.change(false); //Esto ya esta puesto arriba en 2.1
                      }

                      //si isCheking es null
                      if (_isChecking == null) return;

                      //Activar el modo chismoso
                      _isChecking!.change(true);

                      //3.4 Implementar numLook
                      //Ajustes del 0 al 100
                      //80 es medida de calibracion. clamp es el rango "(abrazadera)"
                      final look = (value.length / 80.0 * 100).clamp(0.0, 100.0);
                      _numLook?.value = look;

                      //3.5 Debounce: si  vuelve a teclar reinicia el contador
                      _typingDebounce?.cancel(); //cancelamos cualquier timer existente
                      //crear nuevo timer
                      _typingDebounce = Timer(const Duration(seconds: 3),(){
                        //si se cierra la pantalla (!mounted)
                        if(!mounted) return;
                        _isChecking?.change(false);
                      });

                    },


                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      ),
                  ),
                  SizedBox(height: 10),
                  //Constraseña
                  TextField(
                    //2.3 Asignar foco al campo de texto
                    focusNode: _passwordFocusNode,
                    onChanged: (value){
                    
                    
                      //1.5 Vincular a campos de texto
                      if (_isChecking != null){
                        //no tapes los ojos
                        //_isChecking!.change(false);
                      }

                      //si isCheking es null
                      if (_isHandsUp == null) return;

                      //Activar el modo chismoso
                      _isHandsUp!.change(true);
                    },
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ), // El icono se cierra aquí correctamente
                      onPressed: () {
                        // Para refrescar el icono
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),

                    ),
                  )
              ],
            ),
          )
        ),
      ),
    );
  }
  @override
  void dispose(){
    //paso 2.4 liberar recursos de los FocusNode
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    //3.5 Liberar Timer
    _typingDebounce?.cancel();
    super.dispose();
  }
}