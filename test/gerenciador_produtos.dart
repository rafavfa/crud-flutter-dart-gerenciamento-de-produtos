class GerenciadorProdutos {
  List<String> produtos = [];

  void cadastrar(String produto) {
    if (produto.trim().isNotEmpty) {
      produtos.add(produto);
    }
  }

  void atualizar(int indice, String novoProduto) {
    if (indice >= 0 && indice < produtos.length && novoProduto.trim().isNotEmpty) {
      produtos[indice] = novoProduto;
    }
  }

  void deletar(int indice) {
    if (indice >= 0 && indice < produtos.length) {
      produtos.removeAt(indice);
    }
  }

  int get quantidade => produtos.length;
}