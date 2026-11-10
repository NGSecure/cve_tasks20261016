package br.com.magazine.entidade;

public class Itempedido {
    int idItempedido;
    int idPedido;
    int idProduto;
    int quantidade;
    double valor;
   
    public int getIdItempedido() {
        return idItempedido;
    }

    public void setIdItempedido(int idItempedido) {
        this.idItempedido = idItempedido;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdProduto() {
        return idProduto;
    }

    public void setIdProduto(int idProduto) {
        this.idProduto = idProduto;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    
    
}
