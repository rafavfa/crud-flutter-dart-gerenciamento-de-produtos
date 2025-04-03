import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Produtos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GerenciadorProdutosScreen(),
    );
  }
}

class GerenciadorProdutosScreen extends StatefulWidget {
  const GerenciadorProdutosScreen({super.key});

  @override
  State<GerenciadorProdutosScreen> createState() => _GerenciadorProdutosScreenState();
}

class _GerenciadorProdutosScreenState extends State<GerenciadorProdutosScreen> {
  final List<String> produtos = [];
  final TextEditingController _inputController = TextEditingController();
  String _outputText = '';
  int? _indiceEdicao;

  void _executarOpcao(String opcao) {
    switch (opcao) {
      case '1':
        _cadastrarProduto();
        break;
      case '2':
        _atualizarProduto();
        break;
      case '3':
        _listarProdutos();
        break;
      case '4':
        _deletarProduto();
        break;
      case '5':
        _outputText = 'Programa encerrado. Até mais!';
        setState(() {});
        break;
      default:
        _outputText = 'Opção inválida! Tente novamente.';
        setState(() {});
    }
  }

  void _cadastrarProduto() {
    if (_inputController.text.trim().isNotEmpty) {
      setState(() {
        produtos.add(_inputController.text);
        _outputText = "'${_inputController.text}' cadastrado com sucesso!";
        _inputController.clear();
      });
    } else {
      setState(() {
        _outputText = 'Nome inválido!';
      });
    }
  }

  void _atualizarProduto() {
    if (produtos.isEmpty) {
      setState(() {
        _outputText = 'Nenhum produto cadastrado!';
      });
      return;
    }

    final indice = int.tryParse(_inputController.text);
    if (indice == null || indice < 0 || indice >= produtos.length) {
      setState(() {
        _outputText = 'Índice inválido!';
      });
      return;
    }

    _indiceEdicao = indice;
    _outputText = 'Digite o novo nome do produto:';
    setState(() {});
  }

  void _confirmarAtualizacao() {
    if (_inputController.text.trim().isNotEmpty && _indiceEdicao != null) {
      setState(() {
        final produtoAntigo = produtos[_indiceEdicao!];
        produtos[_indiceEdicao!] = _inputController.text;
        _outputText = "'$produtoAntigo' foi atualizado para '${_inputController.text}'!";
        _inputController.clear();
        _indiceEdicao = null;
      });
    } else {
      setState(() {
        _outputText = 'Nome inválido!';
      });
    }
  }

  void _listarProdutos() {
    if (produtos.isEmpty) {
      setState(() {
        _outputText = 'Nenhum produto cadastrado!';
      });
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('=== LISTA DE PRODUTOS ===');
    for (int i = 0; i < produtos.length; i++) {
      buffer.writeln('$i: ${produtos[i]}');
    }
    buffer.writeln('Total de itens: ${produtos.length}');

    setState(() {
      _outputText = buffer.toString();
    });
  }

  void _deletarProduto() {
    if (produtos.isEmpty) {
      setState(() {
        _outputText = 'Nenhum produto cadastrado!';
      });
      return;
    }

    final indice = int.tryParse(_inputController.text);
    if (indice == null || indice < 0 || indice >= produtos.length) {
      setState(() {
        _outputText = 'Índice inválido!';
      });
      return;
    }

    setState(() {
      final produtoRemovido = produtos.removeAt(indice);
      _outputText = "'$produtoRemovido' foi removido da lista!";
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gerenciador de Produtos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _outputText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: _indiceEdicao != null ? 'Novo nome do produto' : 'Entrada',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (_indiceEdicao != null) {
                  _confirmarAtualizacao();
                }
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () => _executarOpcao('1'),
                  child: const Text('1. Cadastrar'),
                ),
                ElevatedButton(
                  onPressed: () => _executarOpcao('2'),
                  child: const Text('2. Atualizar'),
                ),
                ElevatedButton(
                  onPressed: () => _executarOpcao('3'),
                  child: const Text('3. Listar'),
                ),
                ElevatedButton(
                  onPressed: () => _executarOpcao('4'),
                  child: const Text('4. Deletar'),
                ),
                ElevatedButton(
                  onPressed: () => _executarOpcao('5'),
                  child: const Text('5. Sair'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}