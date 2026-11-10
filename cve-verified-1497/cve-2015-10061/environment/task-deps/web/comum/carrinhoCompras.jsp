<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>HQ Shop</title>

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
        <!--Inclui cabeçalho-->
        <jsp:include page="navAnonimo.jsp"/>

        <!-- Navigation -->
        <!-- Page Content -->
        <div class="container">

            <div class="row">

                <h1>Carrinho</h1>
                <table class="table table-striped">
                    <tr>
                        <th>Item</th>
                        <th>Quantidade</th>
                        <th>Valor Unitário</th>
                        <th>Valor Total</th>
                    </tr>
                    <tr>
                        <td><img src="http://placehold.it/50x50" alt="" /> Turma da Monica Ed.50</td>
                        <td>2</td>
                        <td>R$ 109,90</td>
                        <td>R$ 218,80</td>
                    </tr>
                    <tr>
                        <td><img src="http://placehold.it/50x50" alt="" /> Wolverine Aniversário</td>
                        <td>1</td>
                        <td>R$ 85,60</td>
                        <td>R$ 85,60</td>
                    </tr>
                    <tr>
                        <td><img src="http://placehold.it/50x50" alt="" /> Casa e Construção maio/2015</td>
                        <td>1</td>
                        <td>R$ 10,99</td>
                        <td>R$ 10,99</td>
                    </tr>
                    <tr class="warning text-info lead">
                        <td></td>
                        <td></td>
                        <td>Total: </td>
                        <td>R$ 340,00</td>
                    </tr>
                </table>
            </div>
            <div class="row">
            <button class="btn btn-success btn-lg col-sm-3 col-sm-push-9">Finalizar Compra</button>
            </div>

            <div class="row">


                <div class="container">

                    <hr>

                    <!-- Footer -->
                    <footer>
                        <div class="row">
                            <div class="col-lg-12">
                                <p>Site desenvolvido por Bruno R. Sella, Evandro Luís Machado e Yuri Jungles para aprovação nas matérias de Web 2 e DAC.</p>
                            </div>
                        </div>
                    </footer>

                </div>
            </div>
        </div>
                <!-- /.container -->

                <!-- jQuery -->
                <script src="../js/jquery.min.js"></script>

                <!-- Bootstrap Core JavaScript -->
                <script src="../js/bootstrap.min.js"></script>

                </body>

                </html>
