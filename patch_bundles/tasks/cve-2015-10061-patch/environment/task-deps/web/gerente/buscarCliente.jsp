<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Cadastro de Categoria</title>

         <!--JQuery CSS-->
        <link rel="stylesheet" href="../js/jquery-ui.css">

        <!-- Bootstrap -->
        <link href="../css/bootstrap.min.css" rel="stylesheet">
        
                <!-- Custom CSS -->
        <link href="../css/shop-homepage.css" rel="stylesheet">
        
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <script src="../js/jquery-ui.js"></script>

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <!--Inclui cabeçalho-->
        <jsp:include page="navGerente.jsp"/>
        
        <div class="container">
           <div class="row">
            <div class="col-md-3">
                <p class="lead">Magazine Store</p>
                <div class="list-group">
                    <a href="buscarCliente.jsp" class="list-group-item">Buscar Cliente</a>
                    <a href="../administrador/cadastrarProduto.jsp" class="list-group-item">Cadastrar Produto</a>
                    <a href="../administrador/cadastrarCategoria.jsp" class="list-group-item">Cadastrar Categoria</a>
                    <a href="../administrador/cadastrarEditora.jsp" class="list-group-item">Cadastrar Editora</a>
                    <a href="../administrador/cadastrarEditora.jsp" class="list-group-item">Cadastrar Editora</a>
                    
                    <a href="./cadastrarUsuario.jsp" class="list-group-item">Cadastrar Usuário</a>
                </div>
            </div>
            <div class="col-md-9 ">
                <h1>Buscar Cliente</h1>
                <form action="./Gerentes?action=buscarc" method="post" class="form-horizontal">
                        <div class="form-group">
                        <div class="row">
                            <label class="col-md-2 control-label pull-left clearfix" for="">Buscar por:</label>
                        </div>
                           <div class="col-md-2">
                            <select name="escolha" class="form-control">
                                <option value="nome">Nome</option>
                                <option value="cpf">CPF</option>
                                <option value="email">Email</option>
                            </select>
                        </div>
                            <div class="col-md-7">
                                <input type="text" name="str" id="" class="form-control" placeholder="1234">
                            </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-success  btn-block ">Buscar</button>
                        </div>
                    </div>

                </form>
                    </div>
            </div>
        </div>
        <!--Inclui Rodapé-->
        <jsp:include page="../comum/rodape.jsp"/>
        
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>