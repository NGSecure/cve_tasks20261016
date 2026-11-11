<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Produtos</title>

        <!-- Bootstrap -->
        <link href="../css/bootstrap.min.css" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
    <jsp:include page="navAnonimo.jsp"/>
    <br /><br /><br />
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="list-group">
                        <a href="listarProdutos.jsp" class="list-group-item">Ação</a>
                        <a href="#" class="list-group-item">Aventura</a>
                        <a href="#" class="list-group-item">Infantil</a>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="col-md-12">
                        <h1 class="text-center">Quadrinho X-men 1824 Raro</h1>
                    </div>
                    <div class="col-md-6">
                        <img src="http://placehold.it/360x360">
                    </div>
                    <div class="col-md-6">
                        <table class="table">
                            <tr>
                                <th>Autor</th>
                                <td>Maurício de Souza</td>
                            </tr>
                            <tr>
                                <th>Editora</th>
                                <td>Abril</td>
                            </tr>
                            <tr>
                                <th>Categoria</th>
                                <td>Ação</td>
                            </tr>
                        </table>
                        <h2 class="text-primary ">R$ 23,99</h2>
                        <div class="form-group">
                            <label for="qtd" class="control-label">Quantidade</label>
                            <input class="form-control" id="qtd" type="number" maxlength="10" value="1"/>
                        </div>
                        
                        <br />
                        <a href="carrinhoCompras.jsp">
                        <button class="btn btn-success btn-lg">
                            <span class="glyphicon glyphicon-shopping-cart"></span> Adicionar ao carrinho
                        </button></a>
                    </div>
                </div>
            </div>
        </div>
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>