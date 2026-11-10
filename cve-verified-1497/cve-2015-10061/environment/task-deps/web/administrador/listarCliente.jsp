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
            <h1>Clientes</h1>
            <div id="accordion" class="panel-group">
               <div class="panel panel-default">
                   <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Evandro João</a>
                            <div class="pull-right">
                                <a href="#">
                                <span class="glyphicon glyphicon-eye-open" style="font-size: 20px"></span>
                                </a>
                                <a href="">
                                 <span class="glyphicon glyphicon-pencil" style="font-size: 20px"></span>
                                </a>
                            </div>
                       </h4>
                   </div>
                   <div id="collapseOne" class="panel-collapse collapse">
                       <div class="panel-body">
                           <table class="table table-striped table-bordered">
                               <tr>
                                   <th>Número da Compra #</th>
                                   <th>Data</th>
                                   <th>Valor Total</th>
                               </tr>
                               <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                                              <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                                              <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                               </tr>
                               
                           </table>
                       </div>
                   </div>
               </div>
                <div class="panel panel-default">
                   <div class="panel-heading">
                        <h4 class="panel-title">
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Evandro João</a>
                            <div class="pull-right">
                                <a href="#">
                                <span class="glyphicon glyphicon-eye-open" style="font-size: 20px"></span>
                                </a>
                                <a href="">
                                 <span class="glyphicon glyphicon-pencil" style="font-size: 20px"></span>
                                </a>
                            </div>
                       </h4>
                   </div>
                   <div id="collapseTwo" class="panel-collapse collapse">
                       <div class="panel-body">
                           <table class="table table-striped table-bordered">
                               <tr>
                                   <th>Número da Compra #</th>
                                   <th>Data</th>
                                   <th>Valor Total</th>
                               </tr>
                               <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                                              <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                                              <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                                </tr>
                                <tr>
                                   <td>183</td>
                                   <td>12/11/2015</td>
                                   <td>R$ 204,40</td>
                               </tr>
                               
                           </table>
                       </div>
                   </div>
               </div>
           </div>
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