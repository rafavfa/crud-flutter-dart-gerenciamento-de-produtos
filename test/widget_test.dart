import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListaComprasScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ListaComprasScreen extends StatefulWidget {
  const ListaComprasScreen({super.key});

  @override
  State<ListaComprasScreen> createState() => _ListaComprasScreenState();
}

class _ListaComprasScreenState extends State<ListaComprasScreen> {
  final List<String> produtos = [];
  final TextEditingController _produtoController = TextEditingController();
  final TextEditingController _indiceController = TextEditingController();
  int? _indiceEdicao;

  @override
  void dispose() {
    _produtoController.dispose();
    _indiceController.dispose();
    super.dispose();
  }

  void _mostrarMenuOpcoes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Listar Todos'),
            onTap: () {
              Navigator.pop(context);
              _mostrarListaCompleta(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Limpar Lista'),
            onTap: () {
              setState(() => produtos.clear());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _mostrarListaCompleta(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lista Completa'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: produtos.length,
            itemBuilder: (context, index) => Text('${index + 1}. ${produtos[index]}'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _adicionarOuAtualizarProduto() {
    if (_produtoController.text.trim().isEmpty) return;

    setState(() {
      if (_indiceEdicao != null) {
        produtos[_indiceEdicao!] = _produtoController.text;
        _indiceEdicao = null;
      } else {
        produtos.add(_produtoController.text);
      }
      _produtoController.clear();
    });
  }

  void _editarProduto(int index) {
    _indiceEdicao = index;
    _produtoController.text = produtos[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Produto'),
        content: TextField(
          controller: _produtoController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nome do produto',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _produtoController.clear();
              _indiceEdicao = null;
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _adicionarOuAtualizarProduto();
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Total de itens: ${produtos.length}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _produtoController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _adicionarOuAtualizarProduto(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _adicionarOuAtualizarProduto,
                  child: Text(_indiceEdicao != null ? 'Atualizar' : 'Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: produtos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum produto cadastrado!',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text(produtos[index]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarProduto(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() => produtos.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarMenuOpcoes(context),
        child: const Icon(Icons.menu),
      ),
    );
  }
}