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
        <div class="container" style="padding-top:100px;">
            <div class="row">
                <div class="col-md-3">
                    <div class="list-group">
                        <a href="#" class="list-group-item">Ação</a>
                        <a href="#" class="list-group-item">Aventura</a>
                        <a href="#" class="list-group-item">Infantil</a>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="panel panel-default">
                        <div class="panel-body">
                            <form class="navbar-form navbar-right">
                                <div class="form-group">
                                    <select class="form-control">
                                        <option>Nome A-Z</option>
                                        <option>Nome Z-A</option>
                                        <option>Menor Preço</option>
                                        <option>Maior Preço</option>
                                    </select>

                                </div>
                            </form>
                            <p class="navbar-text navbar-right">Ordenar por: </p>
                        </div>
                    </div>
                    <div class="row">

                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4 class="pull-right text-success">R$ 24.99</h4>
                                    <h4><a href="verProduto.jsp">First Product</a>
                                    </h4>
                                    <p>See more snippets like this online store item at Bpp .</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4 class="pull-right text-success">R$ 24.99</h4>
                                    <h4><a href="#">First Product</a>
                                    </h4>
                                    <p>See more snippets like this online store item at Bpp .</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4 class="pull-right text-success">R$ 24.99</h4>
                                    <h4><a href="#">First Product</a>
                                    </h4>
                                    <p>See more snippets like this online store item at Bpp .</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4 class="pull-right text-success">R$ 24.99</h4>
                                    <h4><a href="#">First Product</a>
                                    </h4>
                                    <p>See more snippets like this online store item at Bpp .</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4 class="pull-right text-success">R$ 24.99</h4>
                                    <h4><a href="#">First Product</a>
                                    </h4>
                                    <p>See more snippets like this online store item at Bpp .</p>
                                </div>
                            </div>
                        </div>

                    </div>            


                </div>
            </div>
            <jsp:include page="rodape.jsp"/>
            <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
            <script src="../js/jquery.min.js"></script>
            <!-- Include all compiled plugins (below), or include individual files as needed -->
            <script src="../js/bootstrap.min.js"></script>
    </body>
</html>