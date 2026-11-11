<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Cadastro de Categoria</title>

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
        <!--Inclui cabeçalho-->
        <jsp:include page="../administrador/navAdministrador.jsp"/>
        <div class="container">
           <div class="row">
            <div class="col-md-3">
                <p class="lead">Magazine Store</p>
                <div class="list-group">
                    <a href="buscarCliente.jsp" class="list-group-item">Buscar Cliente</a>
                    <a href="../administrador/cadastrarProduto.jsp" class="list-group-item">Cadastrar Produto</a>
                    <a href="../administrador/cadastrarCategoria.jsp" class="list-group-item">Cadastrar Categoria</a>
                    <a href="../administrador/cadastrarEditora.jsp" class="list-group-item">Cadastrar Editora</a>
                </div>
            </div>
            <div class="col-md-9 ">
                <h1>Buscar Cliente</h1>
                <form action="listarCliente.jsp" class="form-horizontal">
                        <div class="form-group">
                        <div class="row">
                            <label class="col-md-2 control-label pull-left clearfix" for="">Buscar por:</label>
                        </div>
                           <div class="col-md-2">
                            <select class="form-control">
                                <option>Nome</option>
                                <option>CPF</option>
                                <option>Email</option>
                            </select>
                        </div>
                            <div class="col-md-7">
                                <input type="text" id="" class="form-control" placeholder="1234">
                            </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-success  btn-block ">Buscar</button>
                        </div>
                    </div>

                    </div>
                </form>
            </div>
        </div>
        </div>
        <!--Inclui Rodapé-->
        <jsp:include page="rodape.jsp"/>
        
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>