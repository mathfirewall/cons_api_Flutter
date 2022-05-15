import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //função que chama o json via GET
  Future<List> pegaUsers() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    var response = await http.get(url);
    //aqui verifica se a API está respondendo se tiver ok passa
    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      //caso a API não responda emite um erro e não deixa crancha o APP
      throw Exception('Erro ao Carregar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Usuários',
            style: TextStyle(fontSize: 40),
          ),
        ),
        // aqui cria uma list e chama a função acima
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FutureBuilder<List>(
              future: pegaUsers(),
              builder: (context, snapshot) {
                // verifica se deu algum erro
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erro ao Carregar Usuários'),
                  );
                }
                //aqui como foi tudo OK ele passa a chamar e mostrar a consulta
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final dados = snapshot.data![index];
                        return ListTile(
                          
                          title: Text(
                              "Titulo: " +
                                  dados['title'].toString(),
                              style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                          subtitle: Text(
                              "Completed: " +
                                  dados['completed'].toString(),
                              style: TextStyle(fontSize: 16, color: Colors.black87)),
                        );
                      });
                }
                // essa função se caso aja algum problema no carregamento ele mostra o carregamento em Tela
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }
}
