import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultado = "Resultado";
  TextEditingController _controllerCep = TextEditingController();

  void _recuperarCep() async {
    setState(() {
      _resultado = '';
    });

    var cepDigitado = _controllerCep.text;

    if (cepDigitado.isEmpty) {
      return;
    }

    String url = 'https://viacep.com.br/ws/$cepDigitado/json/';
    http.Response response;

    response = await http.get(url);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return;
    }

    Map<String, dynamic> retorno = json.decode(response.body);

    String logradouro = retorno['logradouro'];
    String complemento = retorno['complemento'];
    String bairro = retorno['bairro'];
    String localidade = retorno['localidade'];

    setState(() {
      _resultado = "$logradouro, $complemento, $bairro, $localidade";
    });

    print(
        "Resposta - logradouro: $logradouro complemento: $complemento bairro: $bairro localidade: $localidade");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumo de serviço web'),
      ),
      body: Container(
        padding: EdgeInsets.all(040),
        child: Column(
          children: <Widget>[
            TextField(
              decoration:
                  InputDecoration(labelText: 'Digite o CEP ex: 13050000'),
              style: TextStyle(fontSize: 20),
              controller: _controllerCep,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: RaisedButton(
                onPressed: _recuperarCep,
                child: Text('Clique aqui'),
              ),
            ),
            Text(_resultado),
          ],
        ),
      ),
    );
  }
}
