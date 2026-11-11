<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>Magazine Store</title>

        <!-- Bootstrap Core CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="../css/shop-homepage.css" rel="stylesheet">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>

        <jsp:include page="navAnonimo.jsp"/>
        <!-- Page Content -->
        <div class="container">

            <div class="row">

                <div class="col-md-3">


                    <div class="list-group">

                        <a href="#" class="list-group-item">Revistas</a>
                        <a href="#" class="list-group-item">Revistas em Quadrinhos</a>
                    </div>
                </div>

                <div class="col-md-9">
                    <div class="row">
                        <div class="col-md-5 col-md-offset-1" style="padding: 0px">
                            <input type="text" class="form-control" placeholder="Pesquisar por..." />
                        </div>
                        <div class="col-md-3" style="padding: 0px">
                            <select name="sexo" id="sexo" class="form-control " >
                                <option >Tudo</option>
                                <option value="t" required>Título</option>
                                <option value="g" required>Gênero</option>
                                <option value="a" required>Autor</option>
                            </select>
                        </div>
                        <div class="col-md-1" style="padding: 0px">
                            <button class="btn btn-default form-control" type="text">
                                <span class="glyphicon glyphicon-search"></span>
                            </button>
                        </div>
                    </div>

                    <br/>
                    <div class="row">
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="verProduto.jsp">Monica Edição 1000</a>
                                    </h4>
                                    <p>
                                        Gênero: Comédia<br/>
                                        Número de Páginas: 55<br/>
                                        Editora: Globo<br/>
                                        Autor: Maurício de Souza<br/>
                                    <h4 class="pull-left">R$24.99</h4>
                                    <br/>
                                    <a href="carrinhoCompras.jsp " class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="#">Wolverine Aniversário</a>
                                    </h4>
                                    <p>
                                        Gênero: Ação<br/>
                                        Número de Páginas: 203<br/>
                                        Editora: Marvel<br/>
                                        Autor: Marvel Comics<br/>
                                    <h4 class="pull-left">R$204.99</h4>
                                    <br/>
                                    <a href="#" class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="#">Casa e Construção maio/2015</a>
                                    </h4>
                                    <p>
                                        Gênero: Casa<br/>
                                        Número de Páginas: 34<br/>
                                        Editora: Minhateca<br/>
                                        Autor: Joao do Pé de Feijão<br/>
                                    <h4 class="pull-left">R$28.99</h4>
                                    <br/>
                                    <a href="#" class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="#">Monica Edição 1000</a>
                                    </h4>
                                    <p>
                                        Gênero: Comédia<br/>
                                        Número de Páginas: 55<br/>
                                        Editora: Globo<br/>
                                        Autor: Maurício de Souza<br/>
                                    <h4 class="pull-left">R$24.99</h4>
                                    <br/>
                                    <a href="#" class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="#">Monica Edição 1000</a>
                                    </h4>
                                    <p>
                                        Gênero: Comédia<br/>
                                        Número de Páginas: 55<br/>
                                        Editora: Globo<br/>
                                        Autor: Maurício de Souza<br/>
                                    <h4 class="pull-left">R$24.99</h4>
                                    <br/>
                                    <a href="#" class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4 col-lg-4 col-md-4">
                            <div class="thumbnail">
                                <img src="http://placehold.it/320x150" alt="">
                                <div class="caption">
                                    <h4><a href="#">Monica Edição 1000</a>
                                    </h4>
                                    <p>
                                        Gênero: Comédia<br/>
                                        Número de Páginas: 55<br/>
                                        Editora: Globo<br/>
                                        Autor: Maurício de Souza<br/>
                                    <h4 class="pull-left">R$24.99</h4>
                                    <br/>
                                    <a href="#" class="pull-right">
                                        Adicionar ao Carrinho
                                        <span class="glyphicon glyphicon-shopping-cart"></span></a>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="col-sm-4 col-lg-4 col-md-4">
                        </div>

                    </div>

                </div>

            </div>

        </div>
        <!-- /.container -->

        <!--Inclui Rodapé-->
        <jsp:include page="rodape.jsp"/>



        <!-- jQuery -->
        <script src="../js/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="../js/bootstrap.min.js"></script>

    </body>

</html>