import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';// sintetizador de voz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode temaActual = ThemeMode.light;
    
  void cambiarTema(){
    setState(() {
      temaActual = temaActual == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: temaActual, // cambio de tema
      debugShowCheckedModeBanner: false,
      home: CalculadoraPage(cambiarTema),
    );
  }
}

class CalculadoraPage extends StatefulWidget {
  final VoidCallback cambiarTema;
  const CalculadoraPage(this.cambiarTema, {super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  dynamic resultado = 0; // uso dinamic por que cuando la division es entre cero, en vez de un entero la respuesta es un string
  final FlutterTts flutterTts = FlutterTts();//instancia de sintetizador de voz

  @override //configuracion del sintetizador de voz, opcional pero ayuda.
  void initState(){
    super.initState();
    flutterTts.setLanguage("es-ES");
  }
  

  void cambiarOperacion(String operacion) {
    final double num1 = double.tryParse(num1Controller.text) ?? 0;
    final double num2 = double.tryParse(num2Controller.text) ?? 0;

    setState(() {
      if (operacion =="SUMA"){
        resultado = num1 + num2; 
        flutterTts.speak("el resultado de la suma es ${resultado.toStringAsFixed(2)}"); //Se define lo que dice el sintetizador de voz segun el resultado SUMA
        } 
      else if (operacion == "RESTA") {
        resultado = num1 - num2; 
        flutterTts.speak("el resultado de la resta es ${resultado.toStringAsFixed(2)}"); //Se define lo que dice el sintetizador de voz segun el resultado RESTA
        } 
      else if (operacion == "MULTIPLICACION") {
        resultado = num1 * num2; 
        flutterTts.speak("el resultado de la multiplicacion es ${resultado.toStringAsFixed(2)}"); //Se define lo que dice el sintetizador de voz segun el resultado MULTIPLICACION
        }
      else if (operacion == "DIVISION") {
        resultado = num2 != 0 ? num1 / num2 : "No se puede dividir entre cero"; 
        flutterTts.speak(resultado is String ? resultado : "El resultado de la división es ${resultado.toStringAsFixed(2)}"); //Se define lo que dice el sintetizador de voz segun el resultado DIVISION
        } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.cambiarTema,
          ),
        ],
        ),
      body: Column(
        children: [
          IntroNumber(controller: num1Controller),
          IntroNumber(controller: num2Controller),
          SeleccionarBoton(cambiarOperacion),
          const SizedBox(height: 20),
          Text(
            "Resultado: ${resultado.toStringAsFixed(2)}", //redondeo de decimales en el resultado
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
class IntroNumber extends StatelessWidget {
  final TextEditingController controller;
  const IntroNumber({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], //validacion de solo inputs numericos
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Ingrese numero",
        ),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------------------------------

class SeleccionarBoton extends StatelessWidget  {
  final Function(String) cambiarOperacion;
  const SeleccionarBoton(this.cambiarOperacion, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => cambiarOperacion("SUMA"),
          child: const Text("SUMA"),
        ),
        ElevatedButton(
          onPressed: () => cambiarOperacion("RESTA"),
          child: const Text("RESTA"),
        ),
        ElevatedButton(
          onPressed: () => cambiarOperacion("MULTIPLICACION"),
          child: const Text("MULTIPLICACION"),
        ),
        ElevatedButton(
          onPressed: () => cambiarOperacion("DIVISION"),
          child: const Text("DIVISION"),
        ),
      ],
    );
  }
}

//--------------------------------------------------------------------------------------------------------------------
class OperacionSuma extends StatefulWidget {
  final TextEditingController num1Controller; 
  final TextEditingController num2Controller;

  const OperacionSuma(this.num1Controller, this.num2Controller, {super.key});

  @override
  State<OperacionSuma> createState() => _OperacionSumaState();
}

class _OperacionSumaState extends State<OperacionSuma> {
  double resultado = 0;

  void sumar(){
    final double num1 = double.tryParse(widget.num1Controller.text) ?? 0;
    final double num2 = double.tryParse(widget.num2Controller.text) ?? 0;

    setState(() {
      resultado = num1 + num2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        ElevatedButton(
          onPressed: sumar,
          child: const Text("calcular SUMA"),
        ),
        Text(
          "Resultado: $resultado",
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }
}

//--------------------------------------------------------------------------------------------------------------------
class OperacionResta extends StatefulWidget {
  final TextEditingController num1Controller; 
  final TextEditingController num2Controller;

  const OperacionResta(this.num1Controller, this.num2Controller, {super.key});

  @override
  State<OperacionResta> createState() => _OperacionRestaState();
}

class _OperacionRestaState extends State<OperacionResta> {
  double resultado = 0;

  void restar(){
    final double num1 = double.tryParse(widget.num1Controller.text) ?? 0;
    final double num2 = double.tryParse(widget.num2Controller.text) ?? 0;

    setState(() {
      resultado = num1 - num2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children:[
        ElevatedButton(
          onPressed: restar,
          child: const Text("calcular RESTA"),
        ),
        Text(
          "Resultado: $resultado",
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }
}

//--------------------------------------------------------------------------------------------------------------------
class OperacionMultiplicacion extends StatefulWidget {
  final TextEditingController num1Controller; 
  final TextEditingController num2Controller;

  const OperacionMultiplicacion(this.num1Controller, this.num2Controller, {super.key});

  @override
  State<OperacionMultiplicacion> createState() => _OperacionMultiplicacionState();
}

class _OperacionMultiplicacionState extends State<OperacionMultiplicacion> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  double resultado = 0;

  void multiplicacion(){
    final double num1 = double.tryParse(widget.num1Controller.text) ?? 0;
    final double num2 = double.tryParse(widget.num2Controller.text) ?? 0;

    setState(() {
      resultado = num1 * num2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children:[
        ElevatedButton(
          onPressed: multiplicacion,
          child: const Text("calcular MULTIPLICACION"),
        ),
        Text(
          "Resultado: $resultado",
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }
}

//--------------------------------------------------------------------------------------------------------------------
class OperacionDivision extends StatefulWidget {
  final TextEditingController num1Controller; 
  final TextEditingController num2Controller;

  const OperacionDivision(this.num1Controller, this.num2Controller, {super.key});


  @override
  State<OperacionDivision> createState() => _OperacionDivisionState();
}

class _OperacionDivisionState extends State<OperacionDivision> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  double resultado = 0;

  void division(){
    final double num1 = double.tryParse(widget.num1Controller.text) ?? 0;
    final double num2 = double.tryParse(widget.num2Controller.text) ?? 0;

    setState((){
      resultado = num1 / num2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children:[
        ElevatedButton(
          onPressed: division,
          child: const Text("calcular DIVISION"),
        ),
        Text(
          "Resultado: $resultado",
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }
}
